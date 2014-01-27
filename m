Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaA0PfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:35:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaA0PfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:35:21 -0500
Date: Mon, 27 Jan 2014 16:35:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Ben Dooks <ben@trinity.fluff.org>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, dmaengine@vger.kernel.org
Subject: Re: [Q] block / zynq: DMA bouncing
In-Reply-To: <20140127152457.GA1073@trinity.fluff.org>
Message-ID: <Pine.LNX.4.64.1401271634470.23931@axis700.grange>
References: <Pine.LNX.4.64.1401271549280.23931@axis700.grange>
 <20140127152457.GA1073@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:lFFGsEJH7VlA9fMu2n0Px67jjjW5zZOY92OyUBwsGHK
 pVQ5wgpKX1DAlAGAO4Ut/uJl7Fb6fy9m+m0ME1DSoRg2Q8Mgkj
 H/CPozenZaxEMx40o09sKiRghj1qHAzD/YqfF0CKL2OvLhVa33
 k13+PpMW+unoSL7QrwIGyJ1F5v9gqMab9Hs1CK7WmCbaSX/Smv
 qL8aHQWhtI6QT3Lyia5PHBWu5qTnOtK+TNtC2TcX340dAU2YqA
 cOtmKrciMLlJA8V/KRFjNZskgjsX7J0PqGPY5dEM+Pe+shGhyY
 Ul905uwDGs5pHFl2EP6xW33CdNkPKjhYUa1a3Dz46fXJKe8eeo
 /M28SUkfzfBhqnN9ZU+qn7bt0aqrkBj/WOBd82U+eMhyaxa3Ta
 cphwJfOl4fbvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, 27 Jan 2014, Ben Dooks wrote:

> On Mon, Jan 27, 2014 at 04:13:56PM +0100, Guennadi Liakhovetski wrote:
> > Hi all,
> > 
> > I'm working on an MMC driver with a DMA capability. All has been working 
> > well, until at some point I've got a bus error, when the mmc driver had 
> > been handed in a buffer at 0x3000 physical RAM address. The reason is, 
> > that on Zynq arch bus masters cannot access RAM below 0x80000. Therefore 
> > my question: how shall I configure this in software?
> > 
> > The way I found was to use ARM-specific struct dmabounce_device_info and 
> > implement its .needs_bounce() method to return true for those addresses. 
> > Is this the right way or is there a better / more straight-forward one?
> > 
> > To do the above I have to enable CONFIG_DMABOUNCE, which then selects 
> > CONFIG_ZONE_DMA. Having done just that I suddenly discover, that 0x3000 
> > buffers aren't used any more, so, I cannot actually verify my 
> > implementation :) Looking at ZONE_DMA it looks like it is still covering 
> > the whole RAM range (/proc/zoneinfo shows start_pfn=0 in zone DMA), so, I 
> > don't see why 0x3000 should be excluded now.
> > 
> > So, is using the .needs_bounce() method the correct way to support DMA on 
> > this arch or is there a better one?
> 
> I have a similar issue with Renesas R8A7790 where there is a bus bridge
> that can only deal with transactions to one half of the available RAM.

Have you tried enabling CONFIG_DMABOUNCE?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
