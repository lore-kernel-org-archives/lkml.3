Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbaKMLxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:53:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49401 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbaKMLxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:53:40 -0500
Date: Thu, 13 Nov 2014 12:53:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141113115332.GB14070@pd.tnic>
References: <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
 <20141111171357.GK31490@pd.tnic>
 <20141111195400.GG2584@khazad-dum.debian.net>
 <20141112123115.GC16807@pd.tnic>
 <20141113001846.GB19734@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141113001846.GB19734@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 10:18:47PM -0200, Henrique de Moraes Holschuh wrote:
> The detail is that: since most Intel microcodes are bigger than the kmalloc
> cache, most of the time kmalloc will return page-aligned addresses, which
> don't need any alignment.

Yeah, you keep saying that. Do you have an actual proof too?

Because if this turns out wrong, we'll end up doing two allocations
instead of one, which is dumb. My suggestion was to do one allocation
only.

> Your version also needs to keep the original pointer around for kfree, which
> is going to be annoying.
> 
> My version has the drawback that it requires the use of INTEL_UCODE_PTR(p)

Yeah, just drop that macro - use simply PTR_ALIGN and
INTEL_MICROCODE_MINALIGN.

> to get to the microcode data, but you can just kfree(p), and it will only
> add the 16 bytes when absolutely required.  This is nice, because it means
> we won't waste an extra page in the most common case, and we don't have to
> find a place to store any extra pointers.

Yeah yeah, proof please.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
