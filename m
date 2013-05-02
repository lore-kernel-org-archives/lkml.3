Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3EBIi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 04:38:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64739 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3EBIiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 04:38:54 -0400
Date: Thu, 2 May 2013 09:38:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 12/32] ARM: ux500: Remove superfluous 'psize' attribute
 from Audio platform data
Message-ID: <20130502083849.GH25256@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-13-git-send-email-lee.jones@linaro.org>
 <20130501144213.GG25256@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130501144213.GG25256@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 May 2013, Lee Jones wrote:

> On Thu, 18 Apr 2013, Lee Jones wrote:
> 
> > 'psize' is used to calculate the maximum DMA burst size. However it
> > is only taken into consideration when editing the DMA channel's
> > configuration. The Audio DMA platform data is only used to allocate
> > a channel, not configure it. That will be done at a later date within
> > the MSP driver.
> > 
> > We're also removing comments which are no longer required, as
> > 'data_width' is no longer set in any device's platform data period.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/mach-ux500/board-mop500-audio.c |   38 ------------------------------
> >  1 file changed, 38 deletions(-)
> > 
> > diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
> > index f012cfa..972bec0 100644
> > --- a/arch/arm/mach-ux500/board-mop500-audio.c
> > +++ b/arch/arm/mach-ux500/board-mop500-audio.c
> > @@ -23,25 +23,13 @@
> >  static struct stedma40_chan_cfg msp0_dma_rx = {
> >  	.high_priority = true,
> >  	.dir = STEDMA40_PERIPH_TO_MEM,
> > -
> >  	.dev_type = DB8500_DMA_DEV31_MSP0_SLIM0_CH0,
> > -
> > -	.src_info.psize = STEDMA40_PSIZE_LOG_4,
> > -	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
> > -
> > -	/* data_width is set during configuration */
> >  };
> >  
> >  static struct stedma40_chan_cfg msp0_dma_tx = {
> >  	.high_priority = true,
> >  	.dir = STEDMA40_MEM_TO_PERIPH,
> > -
> >  	.dev_type = DB8500_DMA_DEV31_MSP0_SLIM0_CH0,
> > -
> > -	.src_info.psize = STEDMA40_PSIZE_LOG_4,
> > -	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
> > -
> > -	/* data_width is set during configuration */
> >  };
> >  
> >  struct msp_i2s_platform_data msp0_platform_data = {
> > @@ -53,25 +41,13 @@ struct msp_i2s_platform_data msp0_platform_data = {
> >  static struct stedma40_chan_cfg msp1_dma_rx = {
> >  	.high_priority = true,
> >  	.dir = STEDMA40_PERIPH_TO_MEM,
> > -
> >  	.dev_type = DB8500_DMA_DEV30_MSP3,
> > -
> > -	.src_info.psize = STEDMA40_PSIZE_LOG_4,
> > -	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
> > -
> > -	/* data_width is set during configuration */
> >  };
> >  
> >  static struct stedma40_chan_cfg msp1_dma_tx = {
> >  	.high_priority = true,
> >  	.dir = STEDMA40_MEM_TO_PERIPH,
> > -
> >  	.dev_type = DB8500_DMA_DEV30_MSP1,
> > -
> > -	.src_info.psize = STEDMA40_PSIZE_LOG_4,
> > -	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
> > -
> > -	/* data_width is set during configuration */
> >  };
> >  
> >  struct msp_i2s_platform_data msp1_platform_data = {
> > @@ -83,29 +59,15 @@ struct msp_i2s_platform_data msp1_platform_data = {
> >  static struct stedma40_chan_cfg msp2_dma_rx = {
> >  	.high_priority = true,
> >  	.dir = STEDMA40_PERIPH_TO_MEM,
> > -
> >  	.dev_type = DB8500_DMA_DEV14_MSP2,
> > -
> > -	/* MSP2 DMA doesn't work with PSIZE == 4 on DB8500v2 */
> > -	.src_info.psize = STEDMA40_PSIZE_LOG_1,
> > -	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
> > -
> > -	/* data_width is set during configuration */
> >  };
> >  
> >  static struct stedma40_chan_cfg msp2_dma_tx = {
> >  	.high_priority = true,
> >  	.dir = STEDMA40_MEM_TO_PERIPH,
> > -
> >  	.dev_type = DB8500_DMA_DEV14_MSP2,
> > -
> > -	.src_info.psize = STEDMA40_PSIZE_LOG_4,
> > -	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
> > -
> >  	.use_fixed_channel = true,
> >  	.phy_channel = 1,
> > -
> > -	/* data_width is set during configuration */
> >  };
> >  
> >  static struct platform_device *db8500_add_msp_i2s(struct device *parent,
> 
> Linus, poke.

I've just seen this response from you (it didn't make it to my offline
mail store for some reason):

> Linus Walleij wrote:
> So if I understand correctly this is now handled by dmaengine_pcm.c,
> os that right?

Unfortunately not. At the moment ux500 sound is very broken in
Mainline. I looked at it recently and the driver is almost completely
different to the one maintained internally.

There were DMA changes relating to this driver pending for v3.10,
which I believe have just been taking into -next. I will straighten
out the DMA issues shortly, but there are other ones remaining still -
mostly surrounding widgets. Ideally this is something Ola should fix,
as he has the expertise to do so, but he doesn't appear to have been
very active upstream of late.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
