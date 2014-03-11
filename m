Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaCKKKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:10:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54490 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753262AbaCKKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:10:07 -0400
Date: Tue, 11 Mar 2014 11:08:38 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>
Subject: Re: [PATCH v4 6/7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140311100838.GQ2815@lukather>
References: <1394462512-11620-1-git-send-email-maxime.ripard@free-electrons.com>
 <1394462512-11620-7-git-send-email-maxime.ripard@free-electrons.com>
 <1394531574.28803.222.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TMgB3/Ch1aWgZB1L"
Content-Disposition: inline
In-Reply-To: <1394531574.28803.222.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TMgB3/Ch1aWgZB1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 11, 2014 at 09:52:55AM +0000, Shevchenko, Andriy wrote:
> On Mon, 2014-03-10 at 15:41 +0100, Maxime Ripard wrote:
> > The Allwinner A31 has a 16 channels DMA controller that it shares with =
the
> > newer A23. Although sharing some similarities with the DMA controller o=
f the
> > older Allwinner SoCs, it's significantly different, I don't expect it t=
o be
> > possible to share the driver for these two.
> >=20
> > The A31 Controller is able to memory-to-memory or memory-to-device tran=
sfers on
> > the 16 channels in parallel.
>=20
> Since it's going to be next cycle of review, I add few more nitpicks
> below.
>=20
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  .../devicetree/bindings/dma/sun6i-dma.txt          |  45 +
> >  drivers/dma/Kconfig                                |   8 +
> >  drivers/dma/Makefile                               |   1 +
> >  drivers/dma/sun6i-dma.c                            | 986 +++++++++++++=
++++++++
> >  4 files changed, 1040 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/dma/sun6i-dma.txt
> >  create mode 100644 drivers/dma/sun6i-dma.c
> >=20
> > diff --git a/Documentation/devicetree/bindings/dma/sun6i-dma.txt b/Docu=
mentation/devicetree/bindings/dma/sun6i-dma.txt
> > new file mode 100644
> > index 000000000000..5d7c86d52665
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/dma/sun6i-dma.txt
> > @@ -0,0 +1,45 @@
> > +Allwinner A31 DMA Controller
> > +
> > +This driver follows the generic DMA bindings defined in dma.txt.
> > +
> > +Required properties:
> > +
> > +- compatible:	Must be "allwinner,sun6i-a31-dma"
> > +- reg:		Should contain the registers base address and length
> > +- interrupts:	Should contain a reference to the interrupt used by this=
 device
> > +- clocks:	Should contain a reference to the parent AHB clock
> > +- resets:	Should contain a reference to the reset controller asserting
> > +	  	this device in reset
> > +- #dma-cells :	Should be 1, a single cell holding a line request number
> > +
> > +Example:
> > +	dma: dma-controller@01c02000 {
> > +		compatible =3D "allwinner,sun6i-a31-dma";
> > +		reg =3D <0x01c02000 0x1000>;
> > +		interrupts =3D <0 50 4>;
> > +		clocks =3D <&ahb1_gates 6>;
> > +		resets =3D <&ahb1_rst 6>;
> > +		#dma-cells =3D <1>;
> > +	};
> > +
> > +Clients:
> > +
> > +DMA clients connected to the A31 DMA controller must use the format
> > +described in the dma.txt file, using a two-cell specifier for each
> > +channel: a phandle plus one integer cells.
> > +The two cells in order are:
> > +
> > +1. A phandle pointing to the DMA controller.
> > +2. The port ID as specified in the datasheet
> > +
> > +Example:
> > +spi2: spi@01c6a000 {
> > +	compatible =3D "allwinner,sun6i-a31-spi";
> > +	reg =3D <0x01c6a000 0x1000>;
> > +	interrupts =3D <0 67 4>;
> > +	clocks =3D <&ahb1_gates 22>, <&spi2_clk>;
> > +	clock-names =3D "ahb", "mod";
> > +	dmas =3D <&dma 25>, <&dma 25>;
> > +	dma-names =3D "rx", "tx";
> > +	resets =3D <&ahb1_rst 22>;
> > +};
> > diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > index 605b016bcea4..7923697eaa2e 100644
> > --- a/drivers/dma/Kconfig
> > +++ b/drivers/dma/Kconfig
> > @@ -351,6 +351,14 @@ config MOXART_DMA
> >  	help
> >  	  Enable support for the MOXA ART SoC DMA controller.
> > =20
> > +config DMA_SUN6I
> > +	tristate "Allwinner A31 SoCs DMA support"
> > +	depends on ARCH_SUNXI
> > +	select DMA_ENGINE
> > +	select DMA_VIRTUAL_CHANNELS
> > +	help
> > +	  Support for the DMA engine for Allwinner A31 SoCs.
> > +
> >  config DMA_ENGINE
> >  	bool
> > =20
> > diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> > index a029d0f4a1be..18cdbad1927c 100644
> > --- a/drivers/dma/Makefile
> > +++ b/drivers/dma/Makefile
> > @@ -44,3 +44,4 @@ obj-$(CONFIG_DMA_JZ4740) +=3D dma-jz4740.o
> >  obj-$(CONFIG_TI_CPPI41) +=3D cppi41.o
> >  obj-$(CONFIG_K3_DMA) +=3D k3dma.o
> >  obj-$(CONFIG_MOXART_DMA) +=3D moxart-dma.o
> > +obj-$(CONFIG_DMA_SUN6I) +=3D sun6i-dma.o
> > diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
> > new file mode 100644
> > index 000000000000..a11040633b30
> > --- /dev/null
> > +++ b/drivers/dma/sun6i-dma.c
> > @@ -0,0 +1,986 @@
> > +/*
> > + * Copyright (C) 2013-2014 Allwinner Tech Co., Ltd
> > + * Author: Sugar <shuge@allwinnertech.com>
> > + *
> > + * Copyright (C) 2014 Maxime Ripard
> > + * Maxime Ripard <maxime.ripard@free-electrons.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/dmaengine.h>
> > +#include <linux/dmapool.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/of_dma.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/reset.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +
> > +#include "virt-dma.h"
> > +
> > +/*
> > + * There's 16 physical channels that can work in parallel.
> > + *
> > + * However we have 30 different endpoints for our requests.
> > + *
> > + * Since the channels are able to handle only an unidirectional
> > + * transfer, we need to allocate more virtual channels so that
> > + * everyone can grab one channel.
> > + *
> > + * Some devices can't work in both direction (mostly because it
> > + * wouldn't make sense), so we have a bit fewer virtual channels than
> > + * 2 channels per endpoints.
> > + */
> > +
> > +#define NR_MAX_CHANNELS		16
> > +#define NR_MAX_REQUESTS		30
> > +#define NR_MAX_VCHANS		53
> > +
> > +/*
> > + * Common registers
> > + */
> > +#define DMA_IRQ_EN(x)		((x) * 0x04)
> > +#define DMA_IRQ_HALF			BIT(0)
> > +#define DMA_IRQ_PKG			BIT(1)
> > +#define DMA_IRQ_QUEUE			BIT(2)
> > +
> > +#define DMA_IRQ_CHAN_NR			8
> > +#define DMA_IRQ_CHAN_WIDTH		4
> > +
> > +
> > +#define DMA_IRQ_STAT(x)		((x) * 0x04 + 0x10)
> > +
> > +#define DMA_STAT		0x30
> > +
> > +/*
> > + * Channels specific registers
> > + */
> > +#define DMA_CHAN_ENABLE		0x00
> > +#define DMA_CHAN_ENABLE_START		BIT(0)
> > +#define DMA_CHAN_ENABLE_STOP		0
> > +
> > +#define DMA_CHAN_PAUSE		0x04
> > +#define DMA_CHAN_PAUSE_PAUSE		BIT(1)
> > +#define DMA_CHAN_PAUSE_RESUME		0
> > +
> > +#define DMA_CHAN_LLI_ADDR	0x08
> > +
> > +#define DMA_CHAN_CUR_CFG	0x0c
> > +#define DMA_CHAN_CFG_SRC_DRQ(x)		((x) & 0x1f)
> > +#define DMA_CHAN_CFG_SRC_IO_MODE	BIT(5)
> > +#define DMA_CHAN_CFG_SRC_LINEAR_MODE	(0 << 5)
> > +#define DMA_CHAN_CFG_SRC_BURST(x)	(((x) & 0x3) << 7)
> > +#define DMA_CHAN_CFG_SRC_WIDTH(x)	(((x) & 0x3) << 9)
> > +
> > +#define DMA_CHAN_CFG_DST_DRQ(x)		(DMA_CHAN_CFG_SRC_DRQ(x) << 16)
> > +#define DMA_CHAN_CFG_DST_IO_MODE	(DMA_CHAN_CFG_SRC_IO_MODE << 16)
> > +#define DMA_CHAN_CFG_DST_LINEAR_MODE	(DMA_CHAN_CFG_SRC_LINEAR_MODE << =
16)
> > +#define DMA_CHAN_CFG_DST_BURST(x)	(DMA_CHAN_CFG_SRC_BURST(x) << 16)
> > +#define DMA_CHAN_CFG_DST_WIDTH(x)	(DMA_CHAN_CFG_SRC_WIDTH(x) << 16)
> > +
> > +#define DMA_CHAN_CUR_SRC	0x10
> > +
> > +#define DMA_CHAN_CUR_DST	0x14
> > +
> > +#define DMA_CHAN_CUR_CNT	0x18
> > +
> > +#define DMA_CHAN_CUR_PARA	0x1c
> > +
> > +
> > +/*
> > + * Various hardware related defines
> > + */
> > +#define LLI_LAST_ITEM	0xfffff800
> > +#define NORMAL_WAIT	8
> > +#define DRQ_SDRAM	1
> > +
> > +/*
> > + * Hardware representation of the LLI
> > + *
> > + * The hardware will be fed the physical address of this structure,
> > + * and read its content in order to start the transfer.
> > + */
> > +struct sun6i_dma_lli {
> > +	u32			cfg;
> > +	u32			src;
> > +	u32			dst;
> > +	u32			len;
> > +	u32			para;
> > +	u32			p_lli_next;
> > +	struct sun6i_dma_lli	*v_lli_next;
> > +} __packed;
> > +
> > +
> > +struct sun6i_desc {
> > +	struct virt_dma_desc	vd;
> > +	dma_addr_t		p_lli;
> > +	struct sun6i_dma_lli	*v_lli;
> > +};
> > +
> > +struct sun6i_pchan {
> > +	u32			idx;
> > +	void __iomem		*base;
> > +	struct sun6i_vchan	*vchan;
> > +	struct sun6i_desc	*desc;
> > +	struct sun6i_desc	*done;
> > +};
> > +
> > +struct sun6i_vchan {
> > +	struct virt_dma_chan	vc;
> > +	struct list_head	node;
> > +	struct dma_slave_config	cfg;
> > +	struct sun6i_pchan	*phy;
> > +	u8			port;
> > +};
> > +
> > +struct sun6i_dma_dev {
> > +	struct dma_device	slave;
> > +	void __iomem		*base;
> > +	struct clk		*clk;
> > +	struct reset_control	*rstc;
> > +	spinlock_t		lock;
> > +	struct tasklet_struct	task;
> > +	struct list_head	pending;
> > +	struct dma_pool		*pool;
> > +	struct sun6i_pchan	*pchans;
> > +	struct sun6i_vchan	*vchans;
> > +};
> > +
> > +static struct device *chan2dev(struct dma_chan *chan)
> > +{
> > +	return &chan->dev->device;
> > +}
> > +
> > +static inline struct sun6i_dma_dev *to_sun6i_dma_dev(struct dma_device=
 *d)
> > +{
> > +	return container_of(d, struct sun6i_dma_dev, slave);
> > +}
> > +
> > +static inline struct sun6i_vchan *to_sun6i_vchan(struct dma_chan *chan)
> > +{
> > +	return container_of(chan, struct sun6i_vchan, vc.chan);
> > +}
> > +
> > +static inline struct sun6i_desc *
> > +to_sun6i_desc(struct dma_async_tx_descriptor *tx)
> > +{
> > +	return container_of(tx, struct sun6i_desc, vd.tx);
> > +}
> > +
> > +static inline void sun6i_dma_dump_com_regs(struct sun6i_dma_dev *sdev)
> > +{
> > +	dev_dbg(sdev->slave.dev, "Common register:\n"
> > +		"\tmask0(%04x): 0x%08x\n"
> > +		"\tmask1(%04x): 0x%08x\n"
> > +		"\tpend0(%04x): 0x%08x\n"
> > +		"\tpend1(%04x): 0x%08x\n"
> > +		"\tstats(%04x): 0x%08x\n",
> > +		DMA_IRQ_EN(0), readl(sdev->base + DMA_IRQ_EN(0)),
> > +		DMA_IRQ_EN(1), readl(sdev->base + DMA_IRQ_EN(1)),
> > +		DMA_IRQ_STAT(0), readl(sdev->base + DMA_IRQ_STAT(0)),
> > +		DMA_IRQ_STAT(1), readl(sdev->base + DMA_IRQ_STAT(1)),
> > +		DMA_STAT, readl(sdev->base + DMA_STAT));
> > +}
> > +
> > +static inline void sun6i_dma_dump_chan_regs(struct sun6i_dma_dev *sdev,
> > +					    struct sun6i_pchan *pchan)
> > +{
> > +	phys_addr_t reg =3D __virt_to_phys((unsigned long)pchan->base);
> > +
> > +	dev_dbg(sdev->slave.dev, "Chan %d reg: %pa\n"
> > +		"\t___en(%04x): \t0x%08x\n"
> > +		"\tpause(%04x): \t0x%08x\n"
> > +		"\tstart(%04x): \t0x%08x\n"
> > +		"\t__cfg(%04x): \t0x%08x\n"
> > +		"\t__src(%04x): \t0x%08x\n"
> > +		"\t__dst(%04x): \t0x%08x\n"
> > +		"\tcount(%04x): \t0x%08x\n"
> > +		"\t_para(%04x): \t0x%08x\n\n",
> > +		pchan->idx, &reg,
> > +		DMA_CHAN_ENABLE,
> > +		readl(pchan->base + DMA_CHAN_ENABLE),
> > +		DMA_CHAN_PAUSE,
> > +		readl(pchan->base + DMA_CHAN_PAUSE),
> > +		DMA_CHAN_LLI_ADDR,
> > +		readl(pchan->base + DMA_CHAN_LLI_ADDR),
> > +		DMA_CHAN_CUR_CFG,
> > +		readl(pchan->base + DMA_CHAN_CUR_CFG),
> > +		DMA_CHAN_CUR_SRC,
> > +		readl(pchan->base + DMA_CHAN_CUR_SRC),
> > +		DMA_CHAN_CUR_DST,
> > +		readl(pchan->base + DMA_CHAN_CUR_DST),
> > +		DMA_CHAN_CUR_CNT,
> > +		readl(pchan->base + DMA_CHAN_CUR_CNT),
> > +		DMA_CHAN_CUR_PARA,
> > +		readl(pchan->base + DMA_CHAN_CUR_PARA));
> > +}
> > +
> > +static inline u8 convert_burst(u8 maxburst)
> > +{
> > +	if (maxburst =3D=3D 1 || maxburst > 16)
> > +		return 0;
> > +
> > +	return fls(maxburst) - 1;
> > +}
> > +
> > +static inline u8 convert_buswidth(enum dma_slave_buswidth addr_width)
> > +{
> > +	switch (addr_width) {
> > +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> > +		return 1;
> > +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> > +		return 2;
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> > +static void *sun6i_dma_lli_add(struct sun6i_dma_lli *prev,
> > +			       struct sun6i_dma_lli *next,
> > +			       dma_addr_t next_phy,
> > +			       struct sun6i_desc *txd)
> > +{
> > +	if ((!prev && !txd) || !next)
> > +		return NULL;
> > +
> > +	if (!prev) {
> > +		txd->p_lli =3D next_phy;
> > +		txd->v_lli =3D next;
> > +	} else {
> > +		prev->p_lli_next =3D next_phy;
> > +		prev->v_lli_next =3D next;
> > +	}
> > +
> > +	next->p_lli_next =3D LLI_LAST_ITEM;
> > +	next->v_lli_next =3D NULL;
> > +
> > +	return next;
> > +}
> > +
> > +static inline void sun6i_dma_cfg_lli(struct sun6i_dma_lli *lli,
> > +				     dma_addr_t src,
> > +				     dma_addr_t dst, u32 len,
> > +				     struct dma_slave_config *config)
> > +{
> > +	u32 src_width, dst_width, src_burst, dst_burst;
> > +
> > +	if (!config)
> > +		return;
> > +
> > +	src_burst =3D convert_burst(config->src_maxburst);
> > +	dst_burst =3D convert_burst(config->dst_maxburst);
> > +
> > +	src_width =3D convert_buswidth(config->src_addr_width);
> > +	dst_width =3D convert_buswidth(config->dst_addr_width);
> > +
> > +	lli->cfg =3D DMA_CHAN_CFG_SRC_BURST(src_burst) |
> > +		DMA_CHAN_CFG_SRC_WIDTH(src_width) |
> > +		DMA_CHAN_CFG_DST_BURST(dst_burst) |
> > +		DMA_CHAN_CFG_DST_WIDTH(dst_width);
> > +
> > +	lli->src =3D src;
> > +	lli->dst =3D dst;
> > +	lli->len =3D len;
> > +	lli->para =3D NORMAL_WAIT;
> > +
>=20
> Redundant empty line.

Right.

>=20
> > +}
> > +
> > +static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
> > +				      struct sun6i_dma_lli *lli)
> > +{
> > +	phys_addr_t p_lli =3D __virt_to_phys((unsigned long)lli);
> > +
> > +	dev_dbg(chan2dev(&vchan->vc.chan),
> > +		"\n\tdesc:   p - %pa v - 0x%08x\n"
>=20
> %p for plain pointers.

Ok.

> > +		"\t\tc - 0x%08x s - 0x%08x d - 0x%08x\n"
> > +		"\t\tl - 0x%08x p - 0x%08x n - 0x%08x\n",
> > +		&p_lli, (u32)lli,
> > +		lli->cfg, lli->src, lli->dst,
> > +		lli->len, lli->para, lli->p_lli_next);
> > +}
> > +
> > +static void sun6i_dma_free_desc(struct virt_dma_desc *vd)
> > +{
> > +	struct sun6i_desc *txd =3D to_sun6i_desc(&vd->tx);
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(vd->tx.chan->device);
> > +	struct sun6i_dma_lli *v_lli, *v_next;
> > +	dma_addr_t p_lli, p_next;
> > +
> > +	if (unlikely(!txd))
> > +		return;
> > +
> > +	p_lli =3D txd->p_lli;
> > +	v_lli =3D txd->v_lli;
> > +
> > +	while (v_lli) {
> > +		v_next =3D v_lli->v_lli_next;
> > +		p_next =3D v_lli->p_lli_next;
> > +
> > +		dma_pool_free(sdev->pool, v_lli, p_lli);
> > +
> > +		v_lli =3D v_next;
> > +		p_lli =3D p_next;
> > +	}
> > +
> > +	kfree(txd);
> > +}
> > +
> > +static int sun6i_dma_terminate_all(struct sun6i_vchan *vchan)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(vchan->vc.chan.device=
);
> > +	struct sun6i_pchan *pchan =3D vchan->phy;
> > +	unsigned long flags;
> > +	LIST_HEAD(head);
> > +
> > +	spin_lock(&sdev->lock);
> > +	list_del_init(&vchan->node);
> > +	spin_unlock(&sdev->lock);
> > +
> > +	spin_lock_irqsave(&vchan->vc.lock, flags);
> > +
> > +	vchan_get_all_descriptors(&vchan->vc, &head);
> > +
> > +	if (pchan) {
> > +		writel(DMA_CHAN_ENABLE_STOP, pchan->base + DMA_CHAN_ENABLE);
> > +		writel(DMA_CHAN_PAUSE_RESUME, pchan->base + DMA_CHAN_PAUSE);
> > +
> > +		vchan->phy =3D NULL;
> > +		pchan->vchan =3D NULL;
> > +		pchan->desc =3D NULL;
> > +		pchan->done =3D NULL;
> > +	}
> > +
> > +	spin_unlock_irqrestore(&vchan->vc.lock, flags);
> > +
> > +	vchan_dma_desc_free_list(&vchan->vc, &head);
> > +
> > +	return 0;
> > +}
> > +
> > +static int sun6i_dma_start_desc(struct sun6i_vchan *vchan)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(vchan->vc.chan.device=
);
> > +	struct virt_dma_desc *desc =3D vchan_next_desc(&vchan->vc);
> > +	struct sun6i_pchan *pchan =3D vchan->phy;
> > +	u32 irq_val, irq_reg, irq_offset;
> > +
> > +	if (!pchan)
> > +		return -EAGAIN;
> > +
> > +	if (!desc) {
> > +		pchan->desc =3D NULL;
> > +		pchan->done =3D NULL;
> > +		return -EAGAIN;
> > +	}
> > +
> > +	list_del(&desc->node);
> > +
> > +	pchan->desc =3D to_sun6i_desc(&desc->tx);
> > +	pchan->done =3D NULL;
> > +
> > +	sun6i_dma_dump_lli(vchan, pchan->desc->v_lli);
> > +
> > +	irq_reg =3D pchan->idx / DMA_IRQ_CHAN_NR;
> > +	irq_offset =3D pchan->idx % DMA_IRQ_CHAN_NR;
> > +
> > +	irq_val =3D readl(sdev->base + DMA_IRQ_EN(irq_offset));
> > +	irq_val |=3D DMA_IRQ_QUEUE << (irq_offset * DMA_IRQ_CHAN_WIDTH);
> > +	writel(irq_val, sdev->base + DMA_IRQ_EN(irq_offset));
> > +
> > +	writel(pchan->desc->p_lli, pchan->base + DMA_CHAN_LLI_ADDR);
> > +	writel(DMA_CHAN_ENABLE_START, pchan->base + DMA_CHAN_ENABLE);
> > +
> > +	sun6i_dma_dump_com_regs(sdev);
> > +	sun6i_dma_dump_chan_regs(sdev, pchan);
> > +
> > +	return 0;
> > +}
> > +
> > +static void sun6i_dma_tasklet(unsigned long data)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D (struct sun6i_dma_dev *)data;
> > +	struct sun6i_vchan *vchan;
> > +	struct sun6i_pchan *pchan;
> > +	unsigned int pchan_alloc =3D 0;
> > +	unsigned int pchan_idx;
> > +
> > +	list_for_each_entry(vchan, &sdev->slave.channels, vc.chan.device_node=
) {
> > +		spin_lock_irq(&vchan->vc.lock);
> > +
> > +		pchan =3D vchan->phy;
> > +
> > +		if (pchan && pchan->done) {
> > +			if (sun6i_dma_start_desc(vchan)) {
> > +				/*
> > +				 * No current txd associated with this channel
> > +				 */
> > +				dev_dbg(sdev->slave.dev, "pchan %u: free\n",
> > +					pchan->idx);
> > +
> > +				/* Mark this channel free */
> > +				vchan->phy =3D NULL;
> > +				pchan->vchan =3D NULL;
> > +			}
> > +		}
> > +		spin_unlock_irq(&vchan->vc.lock);
> > +	}
> > +
> > +	spin_lock_irq(&sdev->lock);
> > +	for (pchan_idx =3D 0; pchan_idx < NR_MAX_CHANNELS; pchan_idx++) {
> > +		pchan =3D &sdev->pchans[pchan_idx];
> > +
> > +		if (pchan->vchan =3D=3D NULL && !list_empty(&sdev->pending)) {
>=20
> !pchan->vchan && ...

Ok.

> And you may decrease indentation level here if you use negative
> condition.

Hmmm, I'm not following you here. What do you mean?

> > +			vchan =3D list_first_entry(&sdev->pending,
> > +						 struct sun6i_vchan, node);
> > +
> > +			/* Remove from pending channels */
> > +			list_del_init(&vchan->node);
> > +			pchan_alloc |=3D BIT(pchan_idx);
> > +
> > +			/* Mark this channel allocated */
> > +			pchan->vchan =3D vchan;
> > +			vchan->phy =3D pchan;
> > +			dev_dbg(sdev->slave.dev, "pchan %u: alloc vchan %p\n",
> > +				pchan->idx, &vchan->vc);
> > +		}
> > +	}
> > +	spin_unlock_irq(&sdev->lock);
> > +
> > +	for (pchan_idx =3D 0; pchan_idx < NR_MAX_CHANNELS; pchan_idx++) {
> > +		if (pchan_alloc & BIT(pchan_idx)) {
>=20
> Ditto.
>=20
> > +			pchan =3D sdev->pchans + pchan_idx;
> > +			vchan =3D pchan->vchan;
> > +			if (vchan) {
> > +				spin_lock_irq(&vchan->vc.lock);
> > +				sun6i_dma_start_desc(vchan);
> > +				spin_unlock_irq(&vchan->vc.lock);
> > +			}
> > +		}
> > +	}
> > +}
> > +
> > +static irqreturn_t sun6i_dma_interrupt(int irq, void *dev_id)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D dev_id;
> > +	struct sun6i_vchan *vchan;
> > +	struct sun6i_pchan *pchan;
> > +	int i, j, ret =3D IRQ_NONE;
> > +	u32 status;
> > +
> > +	for (i =3D 0; i < 2; i++) {
> > +		status =3D readl(sdev->base + DMA_IRQ_STAT(i));
> > +		if (!status)
> > +			continue;
> > +
> > +		dev_dbg(sdev->slave.dev, "DMA irq status %s: 0x%x\n",
> > +			i ? "high" : "low", status);
> > +
> > +		writel(status, sdev->base + DMA_IRQ_STAT(i));
> > +
> > +		for (j =3D 0; (j < 8) && status; j++) {
> > +			if (status & DMA_IRQ_QUEUE) {
> > +				pchan =3D sdev->pchans + j;
> > +				vchan =3D pchan->vchan;
> > +
> > +				if (vchan) {
> > +					unsigned long flags;
> > +
> > +					spin_lock_irqsave(&vchan->vc.lock,
> > +							  flags);
> > +					vchan_cookie_complete(&pchan->desc->vd);
> > +					pchan->done =3D pchan->desc;
> > +					spin_unlock_irqrestore(&vchan->vc.lock,
> > +							       flags);
> > +				}
> > +			}
> > +
> > +			status =3D status >> 4;
> > +		}
> > +
> > +		tasklet_schedule(&sdev->task);
> > +		ret =3D IRQ_HANDLED;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
> > +		struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> > +		size_t len, unsigned long flags)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(chan->device);
> > +	struct sun6i_vchan *vchan =3D to_sun6i_vchan(chan);
> > +	struct dma_slave_config *sconfig =3D &vchan->cfg;
> > +	struct sun6i_dma_lli *v_lli;
> > +	struct sun6i_desc *txd;
> > +	dma_addr_t p_lli;
> > +
> > +	dev_dbg(chan2dev(chan),
> > +		"%s; chan: %d, dest: %pad, src: %pad, len: %zu. flags: 0x%08lx\n",
> > +		__func__, vchan->vc.chan.chan_id, &dest, &src, len, flags);
> > +
> > +	if (!len)
> > +		return NULL;
> > +
> > +	txd =3D kzalloc(sizeof(*txd), GFP_NOWAIT);
> > +	if (!txd)
> > +		return NULL;
> > +
> > +	v_lli =3D dma_pool_alloc(sdev->pool, GFP_NOWAIT, &p_lli);
> > +	if (!v_lli) {
> > +		dev_err(sdev->slave.dev, "Failed to alloc lli memory\n");
> > +		kfree(txd);
> > +		return NULL;
> > +	}
> > +
> > +	sun6i_dma_cfg_lli(v_lli, src, dest, len, sconfig);
> > +	v_lli->cfg |=3D DMA_CHAN_CFG_SRC_DRQ(DRQ_SDRAM) |
> > +		DMA_CHAN_CFG_DST_DRQ(DRQ_SDRAM) |
> > +		DMA_CHAN_CFG_DST_LINEAR_MODE |
> > +		DMA_CHAN_CFG_SRC_LINEAR_MODE;
> > +
> > +	sun6i_dma_lli_add(NULL, v_lli, p_lli, txd);
> > +
> > +	sun6i_dma_dump_lli(vchan, v_lli);
> > +
> > +	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
> > +}
> > +
> > +static struct dma_async_tx_descriptor *sun6i_dma_prep_slave_sg(
> > +		struct dma_chan *chan, struct scatterlist *sgl,
> > +		unsigned int sg_len, enum dma_transfer_direction dir,
> > +		unsigned long flags, void *context)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(chan->device);
> > +	struct sun6i_vchan *vchan =3D to_sun6i_vchan(chan);
> > +	struct dma_slave_config *sconfig =3D &vchan->cfg;
> > +	struct sun6i_dma_lli *v_lli, *prev =3D NULL;
> > +	struct sun6i_desc *txd;
> > +	struct scatterlist *sg;
> > +	dma_addr_t p_lli;
> > +	int i;
> > +
> > +	if (!sgl)
> > +		return NULL;
> > +
> > +	if (!is_slave_direction(dir)) {
> > +		dev_err(chan2dev(chan), "Invalid DMA direction\n");
> > +		return NULL;
> > +	}
> > +
> > +	txd =3D kzalloc(sizeof(*txd), GFP_NOWAIT);
> > +	if (!txd)
> > +		return NULL;
> > +
> > +	for_each_sg(sgl, sg, sg_len, i) {
> > +		v_lli =3D dma_pool_alloc(sdev->pool, GFP_NOWAIT, &p_lli);
> > +		if (!v_lli) {
> > +			kfree(txd);
> > +			return NULL;
> > +		}
> > +
> > +		if (dir =3D=3D DMA_MEM_TO_DEV) {
> > +			sun6i_dma_cfg_lli(v_lli, sg_dma_address(sg),
> > +					  sconfig->dst_addr, sg_dma_len(sg),
> > +					  sconfig);
> > +			v_lli->cfg |=3D DMA_CHAN_CFG_DST_IO_MODE |
> > +				DMA_CHAN_CFG_SRC_LINEAR_MODE |
> > +				DMA_CHAN_CFG_SRC_DRQ(DRQ_SDRAM) |
> > +				DMA_CHAN_CFG_DST_DRQ(vchan->port);
> > +
> > +			dev_dbg(chan2dev(chan),
> > +				"%s; chan: %d, dest: %pad, src: %pad, len: %zu. flags: 0x%08lx\n",
> > +				__func__, vchan->vc.chan.chan_id,
> > +				&sconfig->dst_addr, &sg_dma_address(sg),
> > +				sg_dma_len(sg), flags);
> > +
> > +		} else {
> > +			sun6i_dma_cfg_lli(v_lli, sconfig->src_addr,
> > +					  sg_dma_address(sg), sg_dma_len(sg),
> > +					  sconfig);
> > +			v_lli->cfg |=3D DMA_CHAN_CFG_DST_LINEAR_MODE |
> > +				DMA_CHAN_CFG_SRC_IO_MODE |
> > +				DMA_CHAN_CFG_DST_DRQ(DRQ_SDRAM) |
> > +				DMA_CHAN_CFG_SRC_DRQ(vchan->port);
> > +
> > +			dev_dbg(chan2dev(chan),
> > +				"%s; chan: %d, dest: %pad, src: %pad, len: %zu. flags: 0x%08lx\n",
> > +				__func__, vchan->vc.chan.chan_id,
> > +				&sg_dma_address(sg), &sconfig->src_addr,
> > +				sg_dma_len(sg), flags);
> > +		}
> > +
> > +		prev =3D sun6i_dma_lli_add(prev, v_lli, p_lli, txd);
> > +	}
> > +
> > +#ifdef DEBUG
> > +	dev_dbg(chan2dev(chan), "First: %pad\n", &txd->p_lli);
>=20
> dev_dbg is aware of DEBUG. So, please, remove that #ifdef at all.

Yep, but the line just below isn't.

The ifdef here is not really to prevent the call to dev_dbg, but rather...

> > +	for (prev =3D txd->v_lli; prev !=3D NULL; prev =3D prev->v_lli_next)

=2E.. this.

>=20
> You may remove '!=3D NULL' part.

Ok.

> > +		sun6i_dma_dump_lli(vchan, prev);
> > +#endif
> > +
> > +	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
> > +}
> > +
> > +static int sun6i_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd =
cmd,
> > +		       unsigned long arg)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D to_sun6i_dma_dev(chan->device);
> > +	struct sun6i_vchan *vchan =3D to_sun6i_vchan(chan);
> > +	struct sun6i_pchan *pchan =3D vchan->phy;
> > +	unsigned long flags;
> > +	int ret =3D 0;
> > +
> > +	switch (cmd) {
> > +	case DMA_RESUME:
> > +		dev_dbg(chan2dev(chan), "vchan %p: resume\n", &vchan->vc);
> > +
> > +		spin_lock_irqsave(&vchan->vc.lock, flags);
> > +
> > +		if (pchan) {
> > +			writel(DMA_CHAN_PAUSE_RESUME,
> > +			       pchan->base + DMA_CHAN_PAUSE);
> > +		} else if (!list_empty(&vchan->vc.desc_issued)) {
> > +			spin_lock(&sdev->lock);
> > +			list_add_tail(&vchan->node, &sdev->pending);
> > +			spin_unlock(&sdev->lock);
> > +		}
> > +
> > +		spin_unlock_irqrestore(&vchan->vc.lock, flags);
> > +		break;
> > +
> > +	case DMA_PAUSE:
> > +		dev_dbg(chan2dev(chan), "vchan %p: pause\n", &vchan->vc);
> > +
> > +		if (pchan) {
> > +			writel(DMA_CHAN_PAUSE_PAUSE,
> > +			       pchan->base + DMA_CHAN_PAUSE);
> > +		} else {
> > +			spin_lock(&sdev->lock);
> > +			list_del_init(&vchan->node);
> > +			spin_unlock(&sdev->lock);
> > +		}
> > +		break;
> > +
> > +	case DMA_TERMINATE_ALL:
> > +		ret =3D sun6i_dma_terminate_all(vchan);
> > +		break;
> > +	case DMA_SLAVE_CONFIG:
> > +		memcpy(&vchan->cfg, (struct dma_slave_config *)arg,
>=20
> (void *) is enough here.

Ok

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TMgB3/Ch1aWgZB1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTHuCmAAoJEBx+YmzsjxAgbF4P/ikysxMAlzUDagcTiQxaY1Fc
Xdr0ML13MNKbC+flZLSKOH6oL+pEXo1++vuLvD+Bdo9MK2Qq9C/HEq7xUk9o5Fis
IUdj0942lAubxORqDgM46YK/GCkelaSq0T7D1jqXyHGzX11CHwk3zv8iPOUnnI95
08ELJdtzAimFtUlsYaomlvKx1B3BW4+5siHJPKCEv2ltpOR2vPYlOitZp4YRd86t
mI7SWPgJV54BKucbM0OWktyZeSgpx3uujYyrVvPYMkHaGPl1SgcxBqzAcvvYnNx/
e0xtlQyIOUnbJZp251uJRYiDZE9TUBI6Zl3ckw83MFJtGqeskZ8W3yX/9CikkJ1w
Uxf1rsG36P3AkItJQclaMfddzZmr8n69U5RQzFshbfFJOMo7vyGuuZSX2VmhYOES
dMU4NOMo33DUVwnjLTa6RBxR/I1pZ1EIeKtfjkww6328773arDq6obOSO77zBzPe
HU8MBzIKXi1E2OFWtbkxQ0vSgy/muJ9qI2fyJhlC8v2O/0M4LwRP9bthwD8YyYyn
v6UXJRwFPGdEBaR7sX4tmSp5hiWQs2IJ1KGh4iyBjFPHSISXaynaCA7hHsc7g2rq
FTUWbqE+X8zCLCg8jhus4ScTRGYRKrph5LwFFZaDuJ1dbDag4SvOKsVfMUHapp/U
sDIPMcBabeSCvgObl1bx
=lmXd
-----END PGP SIGNATURE-----

--TMgB3/Ch1aWgZB1L--
