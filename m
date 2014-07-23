Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaGWMMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:12:17 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:59644 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaGWMMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:12:16 -0400
Date: Wed, 23 Jul 2014 14:11:41 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Yao Yuan <yao.yuan@freescale.com>
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>, "marex@denx.de" <marex@denx.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Message-ID: <20140723141141.6ac64f85@ipc1.ka-ro>
In-Reply-To: <b1778af62e7b42b39381fb2699b34eb1@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
	<1406103883-3572-2-git-send-email-yao.yuan@freescale.com>
	<20140723114834.411f6bb4@ipc1.ka-ro>
	<b1778af62e7b42b39381fb2699b34eb1@BL2PR03MB338.namprd03.prod.outlook.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yao Yuan wrote:
> Hi,
> 
> Thanks for your review.
> 
> Lothar Waßmann wrote:
> > Yuan Yao wrote:
> > > Add dma support for i2c. This function depend on DMA driver.
> > > You can turn on it by write both the dmas and dma-name properties in dts node.
> > >
> > > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > > ---
> > >  drivers/i2c/busses/i2c-imx.c | 377
> [...]
> > > +
> > > +fail_rx:
> > > +	dma_release_channel(dma->chan_rx);
> > > +fail_tx:
> > > +	dma_release_channel(dma->chan_tx);
> > > +fail_al:
> > > +	devm_kfree(dev, dma);
> > >
> > No need for this one (that's the whole point of using devm_kzalloc())!
> > 
> 
> When DMA request failed, I2C will switch to PIO mode. So if the failed reason is just like DMA channel request failed. At this time the DMA should free by devm_kfree(). Is it?
> 
OK. I didn't notice that failing DMA support wasn't a showstopper for
the whole driver.
In this case I would remove the 'failed' from the messages inside 
i2c_imx_dma_request() to make them more benign looking and output them
with dev_dbg(), so they can be en-/disabled with CONFIG_I2C_DEBUG_BUS.

What about returning -EPROBE_DEFER in appropriate cases (when there is
a chance that the DMA driver will be probed later than the I2C driver)?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
