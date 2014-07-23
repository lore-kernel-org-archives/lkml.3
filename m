Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbaGWQw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:52:58 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:37121 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbaGWQw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:52:57 -0400
X-Auth-Info: n3z8uy77uG0dTwGAIabwDH4vr8mYCAmzlxYG/GYJbZM=
From: Marek Vasut <marex@denx.de>
To: Lothar =?iso-8859-1?q?Wa=DFmann?= <LW@karo-electronics.de>
Subject: Re: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Date: Wed, 23 Jul 2014 18:52:53 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Varka Bhadram <varkabhadram@gmail.com>, Yao Yuan <yao.yuan@freescale.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com> <53CF9933.8030908@gmail.com> <20140723141502.2d726afe@ipc1.ka-ro>
In-Reply-To: <20140723141502.2d726afe@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201407231852.53893.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 23, 2014 at 02:15:02 PM, Lothar Waßmann wrote:
> Hi,
> 
> Varka Bhadram wrote:
> > On 07/23/2014 04:41 PM, Yao Yuan wrote:
> > > Hi,
> > > 
> > > Thanks for your review.
> > > 
> > > Lothar Waßmann wrote:
> > >> Yuan Yao wrote:
> > >>> Add dma support for i2c. This function depend on DMA driver.
> > >>> You can turn on it by write both the dmas and dma-name properties in
> > >>> dts node.
> > >>> 
> > >>> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > >>> ---
> > >>> 
> > >>>   drivers/i2c/busses/i2c-imx.c | 377
> > > 
> > > [...]
> > > 
> > >>> +
> > >>> +fail_rx:
> > >>> +	dma_release_channel(dma->chan_rx);
> > >>> +fail_tx:
> > >>> +	dma_release_channel(dma->chan_tx);
> > >>> +fail_al:
> > >>> +	devm_kfree(dev, dma);
> > >> 
> > >> No need for this one (that's the whole point of using devm_kzalloc())!
> > > 
> > > When DMA request failed, I2C will switch to PIO mode. So if the failed
> > > reason is just like DMA channel request failed. At this time the DMA
> > > should free by devm_kfree(). Is it?
> > 
> > If probe failed the memory will be freed automatically because
> > we are using devm_kzalloc()...
> > 
> > If we use devm_kzalloc() ,no need to free manually on fail...
> 
> Yes, but as Yuan Yao stated, the driver will still work
> without DMA but carry around the unecessary allocated imx_i2c_dma
> struct.
> The devm_kfree() is not in the failure path of the driver's probe()
> function, but in the function that tries to initialize the optional DMA
> support.

If the DMA fails, I'd just make the entire probe fail. In case you cannot probe 
DMA for your hardware, which is exected to be DMA capable, it means something is 
wrong anyway.

Best regards,
Marek Vasut
