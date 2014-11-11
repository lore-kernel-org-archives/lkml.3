Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaKKKrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:47:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52734 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbaKKKrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:47:04 -0500
Date: Tue, 11 Nov 2014 11:47:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141111104700.GC31490@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141108215749.GC32023@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 07:57:49PM -0200, Henrique de Moraes Holschuh wrote:
> I will remove the WARN_ONCE, and place a comment in its place:
> 
> /*
>  * the memory area holding the microcode update data must be 16-byte
>  * aligned.  This is supposed to be guaranteed by kmalloc().
>  */

So this makes this comment pretty useless as it doesn't do anything
about the case where 16-byte alignment gets violated. Actually I was
expecting something else:

* you either write down *why* kmalloc guarantees alignment. From a quick
look it might but it might not, hint

#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)

* or you actually go and fix this by making sure all memory in the intel
loader is 16-byte aligned. Maybe a loader-specific kmalloc wrapper,
something which allocates a bit more and then aligns it properly, and so
on...

But simply adding a comment which doesn't do anything to solve the
situation doesn't make a lot of sense. And more importantly, doesn't
solve the situation.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
