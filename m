Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3H0OrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:47:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3H0OrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:47:04 -0400
Date: Tue, 27 Aug 2013 16:46:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] DMA: shdma: fix a bad merge - remove free_irq()
In-Reply-To: <20130827090112.GT2748@intel.com>
Message-ID: <Pine.LNX.4.64.1308271625560.11515@axis700.grange>
References: <Pine.LNX.4.64.1308261426320.1767@axis700.grange>
 <20130826135308.GP2748@intel.com> <Pine.LNX.4.64.1308271028500.11515@axis700.grange>
 <20130827090112.GT2748@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:wvusDmt7dsfcpC+dQuQKwkErZCRgsM3JPGnNdvJfms2
 08+uZnyu+pYnkFxv50xP7v4YgQd5bEmMd/F9+OLBuQbW5VJo7B
 ENQ5JEXEY+v7JguvfGN+KXVGwxOqAB4WGVl1GMr8aLtTMscQ3e
 wXuYk9LgjCdMZerWNi47fZ+c/HpWReo+q7ybqcPpLABzD+Q5Hw
 +65ax8Q0RFw8tCpV+262rKnxHxQahzpYFVFqNu329h38m51c3s
 3g8HLY+SoCsiPRv3yzYGKrqR4qmqEeBuL1UuvVXdp1Fh+l/xXO
 EkiDbiqbyHpr5qvWuNk9FFteSiNyaVx1Smkk+rsVkfrmSKT3sq
 YhpyBZzH0QQU1umTCxN5QOnFn2LZjGNHVrVd6LWmtqR1HvAeBW
 16KlIbazjWjHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013, Vinod Koul wrote:

> On Tue, Aug 27, 2013 at 11:21:00AM +0200, Guennadi Liakhovetski wrote:
> > Hi Vinod,
> > 
> > On Mon, 26 Aug 2013, Vinod Koul wrote:
> > 
> > > On Mon, Aug 26, 2013 at 02:27:51PM +0200, Guennadi Liakhovetski wrote:
> > > > A bad merge resulted in a left-over free_irq() call. This patch removes it.
> > > Applied, thanks
> > > 
> > > Can you also test this branch and see if anything is remaining
> > > 
> > > And can you take care then ARM patches in last serries are merged this week...
> > 
> > Ok, I wanted to just test -next, but the latest is still of 22 Aug and 
> > that's too old. So, I took the current sh-mobile tree and merged your 
> > tree on top. There was 1 merge conflict in arch/arm/Makefile, but that's 
> > unrelated. After doing that I've discovered the following problems:
> > 
> > 1. you applied a wrong version (v1) of my patch "DMA: shdma: support the 
> > new CHCLR register layout" - not v2, whose patchwork ID I provided:
> > 
> > > DMA: shdma: support the new CHCLR register layout
> > > pw ID: 2825593
> I have redone the topic branch picking the v2 patch
> 
> > I suggest to revert that commit and apply the correct one.
> > 
> > 2. you missed this patch:
> > 
> > > DMA: shdma: move two macros to a header
> > > pw ID: 2831934
> > 
> > Please, pick it up too, even though it's just a cosmetic one.
> I ahve fixed that up in merge, pls verfiy. So need need of update patch which
> you sent..

Ok, to me it looks like you did fix some patches in the topic/sh branch, 
but:

patch "DMA: shdma: move two macros to a header" is missing
patch "dma: use dev_get_platdata()" is missing (but ok, it's common for 
drivers/dma, not sh-specific)
patch "shdma: fixup sh_dmae_get_partial() calculation error" is missing

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
