Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3IYHWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:22:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3IYHW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:22:29 -0400
Date: Wed, 25 Sep 2013 09:22:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Simon Horman <horms@verge.net.au>
cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v5 5/7] ARM: shmobile: r8a73a4: add a DMAC platform device
 and clock for it
In-Reply-To: <20130925071020.GH6663@verge.net.au>
Message-ID: <Pine.LNX.4.64.1309250921590.324@axis700.grange>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
 <1375455042-24093-6-git-send-email-g.liakhovetski@gmx.de>
 <20130925055036.GA6663@verge.net.au> <Pine.LNX.4.64.1309250850100.324@axis700.grange>
 <20130925071020.GH6663@verge.net.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:7a6j18P2Vy/clBEC+yXBDWacgkDy5gCRYPMOruyPof9
 A3wyvSWSZ+QuEB0VQWi1bsg3wPukpyTP63fgq/E3V1Kki8foN5
 7mfX7pB3AInicUfyWEXqCnkGKi2cvOMcsl1MfsSbLRmVznBmSa
 rl3MTnCJv0N1/yMDLUBeTMNaNywwV9K+iMP+dJ2zvpCPy3yYd5
 9+a+2SYlDjkm1scEPgFudlKRjoR1jMuBRJ4KzmCwLA++vSEC+e
 0XuSYUPu3qG2kIG0UY2lBSjjGnh+lP+KjWR2qCw01olaIwa7cc
 omHkpYxKv/ZoCAnLWdvmnjNJ+8dUw8tVnDEP3bYabxHyjzi2lv
 tYwNjsaYpM8RcaKvb9iqRBBX6Of7BVqJX93eRMcZt/hIfTrtQZ
 rmMRHWUOP+M6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, Simon Horman wrote:

> On Wed, Sep 25, 2013 at 08:52:17AM +0200, Guennadi Liakhovetski wrote:
> > Hi Simon,
> > 
> > Thanks for following up on this.
> > 
> > On Wed, 25 Sep 2013, Simon Horman wrote:
> > 
> > > On Fri, Aug 02, 2013 at 04:50:40PM +0200, Guennadi Liakhovetski wrote:
> > > > Add a DMAC platform device and clock definitions for it on r8a73a4.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > > > ---
> > > > 
> > > > Depends on "DMA: shdma: support the new CHCLR register layout"
> > > > https://lkml.org/lkml/2013/7/10/146
> > > 
> > > That change seems to be present upstream.
> > > 
> > > Does this patch depend on any of the other patches
> > > in this series?
> > 
> > I don't think this one does, however, üatches 6 and 7 do. But patches 1-4 
> > from this series are already in next, so, the rest can go in too?
> 
> Yes, I think there should be a way.
> 
> It seems to me that patches 1-4 are present in v3.12-rc1,
> could you confirm that is the case?

Yes, you're right, they're there.

Thanks
Guennadi

> If so it should be straightforward
> for me to queue up patches 6 and 7 (and 5 which seems to already be
> straightforward).
> 
> 
> > 
> > Thanks
> > Guennadi
> > 
> > > 
> > > > 
> > > >  arch/arm/mach-shmobile/clock-r8a73a4.c        |    4 +-
> > > >  arch/arm/mach-shmobile/include/mach/r8a73a4.h |    9 +++
> > > >  arch/arm/mach-shmobile/setup-r8a73a4.c        |   91 +++++++++++++++++++++++++
> > > >  3 files changed, 103 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/arch/arm/mach-shmobile/clock-r8a73a4.c b/arch/arm/mach-shmobile/clock-r8a73a4.c
> > > > index 8ea5ef6..357b9bc 100644
> > > > --- a/arch/arm/mach-shmobile/clock-r8a73a4.c
> > > > +++ b/arch/arm/mach-shmobile/clock-r8a73a4.c
> > > > @@ -504,7 +504,7 @@ static struct clk div6_clks[DIV6_NR] = {
> > > >  
> > > >  /* MSTP */
> > > >  enum {
> > > > -	MSTP217, MSTP216, MSTP207, MSTP206, MSTP204, MSTP203,
> > > > +	MSTP218, MSTP217, MSTP216, MSTP207, MSTP206, MSTP204, MSTP203,
> > > >  	MSTP329, MSTP323, MSTP318, MSTP317, MSTP316,
> > > >  	MSTP315, MSTP314, MSTP313, MSTP312, MSTP305, MSTP300,
> > > >  	MSTP411, MSTP410, MSTP409,
> > > > @@ -519,6 +519,7 @@ static struct clk mstp_clks[MSTP_NR] = {
> > > >  	[MSTP207] = SH_CLK_MSTP32(&div6_clks[DIV6_MP],	SMSTPCR2, 7, 0), /* SCIFB1 */
> > > >  	[MSTP216] = SH_CLK_MSTP32(&div6_clks[DIV6_MP],	SMSTPCR2, 16, 0), /* SCIFB2 */
> > > >  	[MSTP217] = SH_CLK_MSTP32(&div6_clks[DIV6_MP],	SMSTPCR2, 17, 0), /* SCIFB3 */
> > > > +	[MSTP218] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR2, 18, 0), /* DMAC */
> > > >  	[MSTP300] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],	SMSTPCR3, 0, 0), /* IIC2 */
> > > >  	[MSTP305] = SH_CLK_MSTP32(&div6_clks[DIV6_MMC1],SMSTPCR3, 5, 0), /* MMCIF1 */
> > > >  	[MSTP312] = SH_CLK_MSTP32(&div6_clks[DIV6_SDHI2],SMSTPCR3, 12, 0), /* SDHI2 */
> > > > @@ -578,6 +579,7 @@ static struct clk_lookup lookups[] = {
> > > >  	CLKDEV_DEV_ID("sh-sci.3", &mstp_clks[MSTP207]),
> > > >  	CLKDEV_DEV_ID("sh-sci.4", &mstp_clks[MSTP216]),
> > > >  	CLKDEV_DEV_ID("sh-sci.5", &mstp_clks[MSTP217]),
> > > > +	CLKDEV_DEV_ID("sh-dma-engine.0", &mstp_clks[MSTP218]),
> > > >  	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
> > > >  	CLKDEV_DEV_ID("e6520000.i2c", &mstp_clks[MSTP300]),
> > > >  	CLKDEV_DEV_ID("sh_mmcif.1", &mstp_clks[MSTP305]),
> > > > diff --git a/arch/arm/mach-shmobile/include/mach/r8a73a4.h b/arch/arm/mach-shmobile/include/mach/r8a73a4.h
> > > > index f3a9b70..3a0ea48 100644
> > > > --- a/arch/arm/mach-shmobile/include/mach/r8a73a4.h
> > > > +++ b/arch/arm/mach-shmobile/include/mach/r8a73a4.h
> > > > @@ -1,6 +1,15 @@
> > > >  #ifndef __ASM_R8A73A4_H__
> > > >  #define __ASM_R8A73A4_H__
> > > >  
> > > > +/* DMA slave IDs */
> > > > +enum {
> > > > +	SHDMA_SLAVE_INVALID,
> > > > +	SHDMA_SLAVE_MMCIF0_TX,
> > > > +	SHDMA_SLAVE_MMCIF0_RX,
> > > > +	SHDMA_SLAVE_MMCIF1_TX,
> > > > +	SHDMA_SLAVE_MMCIF1_RX,
> > > > +};
> > > > +
> > > >  void r8a73a4_add_standard_devices(void);
> > > >  void r8a73a4_add_dt_devices(void);
> > > >  void r8a73a4_clock_init(void);
> > > > diff --git a/arch/arm/mach-shmobile/setup-r8a73a4.c b/arch/arm/mach-shmobile/setup-r8a73a4.c
> > > > index 2ee45d5..ec77059 100644
> > > > --- a/arch/arm/mach-shmobile/setup-r8a73a4.c
> > > > +++ b/arch/arm/mach-shmobile/setup-r8a73a4.c
> > > > @@ -22,8 +22,10 @@
> > > >  #include <linux/of_platform.h>
> > > >  #include <linux/platform_data/irq-renesas-irqc.h>
> > > >  #include <linux/serial_sci.h>
> > > > +#include <linux/sh_dma.h>
> > > >  #include <linux/sh_timer.h>
> > > >  #include <mach/common.h>
> > > > +#include <mach/dma-register.h>
> > > >  #include <mach/irqs.h>
> > > >  #include <mach/r8a73a4.h>
> > > >  #include <asm/mach/arch.h>
> > > > @@ -199,12 +201,101 @@ void __init r8a73a4_add_dt_devices(void)
> > > >  	r8a7790_register_cmt(10);
> > > >  }
> > > >  
> > > > +/* DMA */
> > > > +static const struct sh_dmae_slave_config dma_slaves[] = {
> > > > +	{
> > > > +		.slave_id	= SHDMA_SLAVE_MMCIF0_TX,
> > > > +		.addr		= 0xee200034,
> > > > +		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
> > > > +		.mid_rid	= 0xd1,
> > > > +	}, {
> > > > +		.slave_id	= SHDMA_SLAVE_MMCIF0_RX,
> > > > +		.addr		= 0xee200034,
> > > > +		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
> > > > +		.mid_rid	= 0xd2,
> > > > +	}, {
> > > > +		.slave_id	= SHDMA_SLAVE_MMCIF1_TX,
> > > > +		.addr		= 0xee220034,
> > > > +		.chcr		= CHCR_TX(XMIT_SZ_32BIT),
> > > > +		.mid_rid	= 0xe1,
> > > > +	}, {
> > > > +		.slave_id	= SHDMA_SLAVE_MMCIF1_RX,
> > > > +		.addr		= 0xee220034,
> > > > +		.chcr		= CHCR_RX(XMIT_SZ_32BIT),
> > > > +		.mid_rid	= 0xe2,
> > > > +	},
> > > > +};
> > > > +
> > > > +#define DMAE_CHANNEL(a, b)				\
> > > > +	{						\
> > > > +		.offset         = (a) - 0x20,		\
> > > > +		.dmars          = (a) - 0x20 + 0x40,	\
> > > > +		.chclr_bit	= (b),			\
> > > > +		.chclr_offset	= 0x80 - 0x20,		\
> > > > +	}
> > > > +
> > > > +static const struct sh_dmae_channel dma_channels[] = {
> > > > +	DMAE_CHANNEL(0x8000, 0),
> > > > +	DMAE_CHANNEL(0x8080, 1),
> > > > +	DMAE_CHANNEL(0x8100, 2),
> > > > +	DMAE_CHANNEL(0x8180, 3),
> > > > +	DMAE_CHANNEL(0x8200, 4),
> > > > +	DMAE_CHANNEL(0x8280, 5),
> > > > +	DMAE_CHANNEL(0x8300, 6),
> > > > +	DMAE_CHANNEL(0x8380, 7),
> > > > +	DMAE_CHANNEL(0x8400, 8),
> > > > +	DMAE_CHANNEL(0x8480, 9),
> > > > +	DMAE_CHANNEL(0x8500, 10),
> > > > +	DMAE_CHANNEL(0x8580, 11),
> > > > +	DMAE_CHANNEL(0x8600, 12),
> > > > +	DMAE_CHANNEL(0x8680, 13),
> > > > +	DMAE_CHANNEL(0x8700, 14),
> > > > +	DMAE_CHANNEL(0x8780, 15),
> > > > +	DMAE_CHANNEL(0x8800, 16),
> > > > +	DMAE_CHANNEL(0x8880, 17),
> > > > +	DMAE_CHANNEL(0x8900, 18),
> > > > +	DMAE_CHANNEL(0x8980, 19),
> > > > +};
> > > > +
> > > > +static const struct sh_dmae_pdata dma_pdata = {
> > > > +	.slave		= dma_slaves,
> > > > +	.slave_num	= ARRAY_SIZE(dma_slaves),
> > > > +	.channel	= dma_channels,
> > > > +	.channel_num	= ARRAY_SIZE(dma_channels),
> > > > +	.ts_low_shift	= TS_LOW_SHIFT,
> > > > +	.ts_low_mask	= TS_LOW_BIT << TS_LOW_SHIFT,
> > > > +	.ts_high_shift	= TS_HI_SHIFT,
> > > > +	.ts_high_mask	= TS_HI_BIT << TS_HI_SHIFT,
> > > > +	.ts_shift	= dma_ts_shift,
> > > > +	.ts_shift_num	= ARRAY_SIZE(dma_ts_shift),
> > > > +	.dmaor_init     = DMAOR_DME,
> > > > +	.chclr_present	= 1,
> > > > +	.chclr_bitwise	= 1,
> > > > +};
> > > > +
> > > > +static struct resource dma_resources[] = {
> > > > +	DEFINE_RES_MEM(0xe6700020, 0x89e0),
> > > > +	DEFINE_RES_IRQ_NAMED(gic_spi(220), "error_irq"),
> > > > +	{
> > > > +		/* IRQ for channels 0-19 */
> > > > +		.start  = gic_spi(200),
> > > > +		.end    = gic_spi(219),
> > > > +		.flags  = IORESOURCE_IRQ,
> > > > +	},
> > > > +};
> > > > +
> > > > +#define r8a73a4_register_dmac()							\
> > > > +	platform_device_register_resndata(&platform_bus, "sh-dma-engine", 0,	\
> > > > +				dma_resources, ARRAY_SIZE(dma_resources),	\
> > > > +				&dma_pdata, sizeof(dma_pdata))
> > > > +
> > > >  void __init r8a73a4_add_standard_devices(void)
> > > >  {
> > > >  	r8a73a4_add_dt_devices();
> > > >  	r8a73a4_register_irqc(0);
> > > >  	r8a73a4_register_irqc(1);
> > > >  	r8a73a4_register_thermal();
> > > > +	r8a73a4_register_dmac();
> > > >  }
> > > >  
> > > >  void __init r8a73a4_init_delay(void)
> > > > -- 
> > > > 1.7.2.5
> > > > 
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
