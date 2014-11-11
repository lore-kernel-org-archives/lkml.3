Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaKKROF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:14:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaKKROD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:14:03 -0500
Date: Tue, 11 Nov 2014 18:13:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141111171357.GK31490@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141111165731.GA2584@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:57:31PM -0200, Henrique de Moraes Holschuh wrote:
> Meh, I don't know where I came up with the wrong information that kmalloc
> aligned to 16-bytes instead of 8 bytes.
> 
> I do wonder why I didn't hit this while testing, though.  Maybe an artifact
> of slub, or just my luck that I never got a memory block that was not
> aligned to 16 bytes.

The ARCH_KMALLOC_MINALIGN is conditioned on ARCH_DMA_MINALIGN and a
bunch of other things. All I'm saying is, this needs a careful study
when, if at all, kmalloc will not give an 16-byte aligned buffer.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
