Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaFVMXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 08:23:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50474 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaFVMXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 08:23:22 -0400
X-Auth-Info: tfLeM7WINrnpcBp6OulfNSz1TK7oIStXmZ3e57ITeRw=
From: Marek Vasut <marex@denx.de>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v3 1/4] crypto: Add Allwinner Security System crypto accelerator
Date: Sun, 22 Jun 2014 14:23:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
References: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com> <201406142101.02747.marex@denx.de> <53A6C4D0.1030102@gmail.com>
In-Reply-To: <53A6C4D0.1030102@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201406221423.15193.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 22, 2014 at 01:58:08 PM, Corentin LABBE wrote:
[...]
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation version 2 of the License
> > 
> > The license text seems incomplete.
> > [...]
> 
> I will replace it with a simplier line "Licensed under the GPL-2."

I'd suggest you to use the SPDX license identifiers then, but that's not 
something the kernel crowd agreed upon yet IIRC.Therefore , just make the text 
complete please.

[...]

> >> +	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> >> +	if (src_addr == NULL) {
> >> +		dev_err(ss->dev, "KMAP error for src SG\n");
> >> +		return -1;
> >> +	}
> > 
> > Why can't you just use dma_map_sg() or somesuch ?
> 
> I do not see why I will use a DMA function in a driver without DMA support.
> Perhaps I do not know some tricks.
> Can I use writel/readl on address gived by DMA API ?

Oh, ok, good question -- dear list, shall one use sg_page()+kmap or sg_virt()?

btw. I just noticed you're just feeding the hardware FIFO in a loop with data in 
the scatterlists, do I understand it correctly ? The driver will consume quite a 
lot of CPU time to do that, can you not implement DMA here ?

[...]

Best regards,
Marek Vasut
