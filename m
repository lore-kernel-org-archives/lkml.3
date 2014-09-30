Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaI3KEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:04:08 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53552 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI3KEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:04:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Chen <peter.chen@freescale.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com,
        alexandre.belloni@free-electrons.com, p.zabel@pengutronix.de,
        jszhang@marvell.com, sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Tue, 30 Sep 2014 12:03:42 +0200
Message-ID: <3366285.QN2R3CQNzG@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930001206.GA11657@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com> <20140930001206.GA11657@peterchendt>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gSV0XD1NwcSEntq+j/Fikypw6f6njQdCJyCatEzrEXg
 WP7aWYoyusF7EmpM5RrhDtG4L1tP882u2Ko7tXIOPl9UNrG1LA
 +QatiolaPNE0hGi1legisIGyyYfZzhRE8NRbrskM1PzAgdRzBZ
 3JitbnXz62eR+j8HvIrXx5VZoyIYjEh9qJar1Ypp0+hfSYHfJ5
 0OQtN4PSqsoMOFEKkGV4wlVnXXo+kBktswNRCIZ5Wzi9rYG7YR
 Fjl/jXXq+5Vz08W96Vbn6cDwN9SNPfMph8Ej7nSivHw+j7A57A
 GkN96TFU2/yI2SPI9S5u5uAryOKW3b2mXSDp3zOV5jSJHliVLA
 HVBoingpXMLK50tNxHbM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 08:12:07 Peter Chen wrote:
> > +
> > +     if (dev->of_node) {
> > +             ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > +             if (ret)
> > +                     goto clk_err;
> > +     } else {
> > +             ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +             if (ret)
> > +                     goto clk_err;
> > +     }
> 
> My suggestion:
> 
> - call dma_coerce_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32)) for both 
> dt and non-dt

No, as I explained before, hardcoding the dma mask is always wrong, don't
do that. Call dma_set_mask_and_coherent and check the return value.
It's not wrong to do that for both DT and ATAGS.

	Arnd
