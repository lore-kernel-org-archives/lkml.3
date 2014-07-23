Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaGWMP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:15:29 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:59658 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaGWMP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:15:27 -0400
Date: Wed, 23 Jul 2014 14:15:02 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Message-ID: <20140723141502.2d726afe@ipc1.ka-ro>
In-Reply-To: <53CF9933.8030908@gmail.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
	<1406103883-3572-2-git-send-email-yao.yuan@freescale.com>
	<20140723114834.411f6bb4@ipc1.ka-ro>
	<b1778af62e7b42b39381fb2699b34eb1@BL2PR03MB338.namprd03.prod.outlook.com>
	<53CF9933.8030908@gmail.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Varka Bhadram wrote:
> On 07/23/2014 04:41 PM, Yao Yuan wrote:
> > Hi,
> >
> > Thanks for your review.
> >
> > Lothar Waßmann wrote:
> >> Yuan Yao wrote:
> >>> Add dma support for i2c. This function depend on DMA driver.
> >>> You can turn on it by write both the dmas and dma-name properties in dts node.
> >>>
> >>> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> >>> ---
> >>>   drivers/i2c/busses/i2c-imx.c | 377
> > [...]
> >>> +
> >>> +fail_rx:
> >>> +	dma_release_channel(dma->chan_rx);
> >>> +fail_tx:
> >>> +	dma_release_channel(dma->chan_tx);
> >>> +fail_al:
> >>> +	devm_kfree(dev, dma);
> >>>
> >> No need for this one (that's the whole point of using devm_kzalloc())!
> >>
> > When DMA request failed, I2C will switch to PIO mode. So if the failed reason is just like DMA channel request failed. At this time the DMA should free by devm_kfree(). Is it?
> 
> If probe failed the memory will be freed automatically because
> we are using devm_kzalloc()...
> 
> If we use devm_kzalloc() ,no need to free manually on fail...
> 
Yes, but as Yuan Yao stated, the driver will still work
without DMA but carry around the unecessary allocated imx_i2c_dma
struct.
The devm_kfree() is not in the failure path of the driver's probe()
function, but in the function that tries to initialize the optional DMA
support.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
