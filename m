Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaFVMeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 08:34:06 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38250 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750977AbaFVMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 08:34:05 -0400
Date: Sun, 22 Jun 2014 13:33:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marex@denx.de>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security System crypto
	accelerator
Message-ID: <20140622123335.GE32514@n2100.arm.linux.org.uk>
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <201406142101.02747.marex@denx.de> <53A6C4D0.1030102@gmail.com> <201406221423.15193.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201406221423.15193.marex@denx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 02:23:15PM +0200, Marek Vasut wrote:
> On Sunday, June 22, 2014 at 01:58:08 PM, Corentin LABBE wrote:
> [...]
> > >> + * This program is free software; you can redistribute it and/or modify
> > >> + * it under the terms of the GNU General Public License as published by
> > >> + * the Free Software Foundation version 2 of the License
> > > 
> > > The license text seems incomplete.
> > > [...]
> > 
> > I will replace it with a simplier line "Licensed under the GPL-2."
> 
> I'd suggest you to use the SPDX license identifiers then, but that's not 
> something the kernel crowd agreed upon yet IIRC.Therefore , just make the text 
> complete please.

Marek,

The full text of the first paragraph (in COPYING) is:

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

which is deemed to be entirely sufficient; quoting the full text is
discouraged, especially when it includes the FSF address.  It is also
acceptable to restrict it to version 2 only, in which case something
like this can be used:

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 2 as
   published by the Free Software Foundation.

Of course, it's up to the author to make up their own mind at the end
of the day.

> Oh, ok, good question -- dear list, shall one use sg_page()+kmap or sg_virt()?

sg_page() + kmap() is preferred, because sg_virt() fails with highmem.
Using sg_virt() means you restrict the driver to non-highmem memory,
and if the kernel wants to place the data into a highmem page, it will
have to use bounce buffers (so it's inefficient).

What's even better is to use the scatterlist iterator, which will handle
this for you.  See the sg_miter_*() functions.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
