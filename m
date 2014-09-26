Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaIZHCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:02:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58945 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaIZHCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:02:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        alexandre.belloni@free-electrons.com, p.zabel@pengutronix.de,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Fri, 26 Sep 2014 09:01:49 +0200
Message-ID: <202048167.dt5r3yRThs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140926002339.GB3026@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <3696520.MDUrkdjfGZ@wuerfel> <20140926002339.GB3026@peterchendt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PhV22PjMDaelHrSAhOe7SIhIWHiBNSUqqrrCQvZarzF
 KVXx6N/LRMditS4eRP0VeWKIsxHgZN0qn60r2uA1hUp1QQ1Fhs
 p1ApjG/QBHekFb8TYUJeqBCyIvkxcAKj/w47fpQMTzDe4kbHYt
 Mobxx0I7tRHFZwUIfxnH7kpMes4SgotxoSj3QRJh2EE1QxrPye
 MNLiIeA0tdUKoTL4Dvh8VG+f/5I6I1bac5oFBwhCqxODLBkwx7
 H1XBr8E67KbfkzrsLAR1ab1gOSJ+eEquO6DMSmAdp8VfWhqmUC
 KGWZteF3jZVTLPqPbVG47N7PNKzrCWNIPguN74VCk2kTMQVskR
 Bt9OeonIhsJq6/TjN64E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 08:23:40 Peter Chen wrote:
> In current chipidea structure, the parent (glue layer) driver will not be
> used for dma, udc/host driver uses dma mask from child (core layer), at core
> layer we will do:
> 
> 
>         pdev->dev.dma_mask = dev->dma_mask; /* this device is parent */
>         dma_set_coherent_mask(&pdev->dev, dev->coherent_dma_mask);
> 
> Would you suggestion us a suitable way? Or it is ok we use just Antoine's way that
> call dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) at parent
> driver no matter dt or non-dt? Thanks.

dma_coerce_mask_and_coherent is not ok, it will force a dma mask that is
unrelated to the actual requirements of the hardware.

I think the best way would be to never use the child device pointer for
DMA operations, just use a pointer to the parent device and make the
child dev->dma_mask pointer NULL to ensure all DMA operations fail.

	Arnd
