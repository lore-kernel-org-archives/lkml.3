Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3HZKnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:43:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64792 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3HZKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:43:15 -0400
Date: Mon, 26 Aug 2013 12:43:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 0/3] DMA: shdma: several stylistic improvements and
 support for new SoCs
In-Reply-To: <20130825073525.GD8091@intel.com>
Message-ID: <Pine.LNX.4.64.1308261136430.1767@axis700.grange>
References: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
 <20130825073525.GD8091@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:6L4CNNgUv/9RaBQmjEGeF2tlvjoN0MaKS7TKYeo5s3o
 QcxVSwyMLNvuPhTJYpDU2CKuBmTvtg0ucEYOnxGae3romjR5ph
 XY837G2Kii8jQxhTaY+rBdkRosoJ1mG0ZxfYkDPzQ8DUrDxOMV
 9W3zwBmHBPZmDG7+NfS5Afr6rCUS4T/DiJDyM3CxBqa6X6WdiB
 bcRDGrmgIcsf40Xvx3uYXLW3OSmdcIynhR4l/hvhERBZGvMFv4
 yGKL1dEa9GrxXCwxfiNUwAd3YtVx1mKs8EjxFzEq2258NkgKqQ
 SHiGFM3LDsd6p+nlL94w6MI6yDbZyiS12LTkBNrfXUWxehbcxI
 O8YmdYLYW8UspraZ6keJrd/6DUxizxym9mqvGskJUyvuBN+ye0
 ZJKpwY0eY5W5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Thanks for applying the patches!

On Sun, 25 Aug 2013, Vinod Koul wrote:

> On Tue, Jul 02, 2013 at 05:45:49PM +0200, Guennadi Liakhovetski wrote:
> > Hi
> > 
> > The first two patches in this small series improve driver internals a bit 
> > by using preferred APIs, the 3rd patch adds support for new DMAC versions, 
> > present on AG5, APE6, H2.
> Applied, thanks
> 
> Although the patch 1 didnt apply for me :( I have manually remove a hunk, I dont
> which tree yoy genertaed this agaisnt!

I'm not sure why it didn't apply for you. AFAICS, you mean this hunk:

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index c7950be..3083d62 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c

[snip]

@@ -909,17 +881,12 @@ static int sh_dmae_remove(struct platform_device *pdev)
 {
 	struct sh_dmae_device *shdev = platform_get_drvdata(pdev);
 	struct dma_device *dma_dev = &shdev->shdma_dev.dma_dev;
-	struct resource *res;
-	int errirq = platform_get_irq(pdev, 0);
 
 	dma_async_device_unregister(dma_dev);
 
 	/* Is a NOP if this controller isn't registered with of-dma */
 	of_dma_controller_free(pdev->dev.of_node);
 
-	if (errirq > 0)
-		free_irq(errirq, shdev);
-
 	spin_lock_irq(&sh_dmae_lock);
 	list_del_rcu(&shdev->node);
 	spin_unlock_irq(&sh_dmae_lock);

It didn't apply, because it is based on top of "DMA: shdma: also support 
single top-level DMAC DT nodes" which has been dropped for now in favour 
of keeping a multiplexer node compulsory for shdma for now, sorry. But 
just dropping it isn't right too. With managed error IRQ allocation 
calling free_irq() on clean up path is wrong. I'll post an incremental 
patch asap.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
