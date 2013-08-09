Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030488Ab3HIIZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:25:16 -0400
Received: from [213.199.154.250] ([213.199.154.250]:6920 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030396Ab3HIIZK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:25:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz9371I542I1432I1a09Jc8kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8hbe9i1155h)
From: Lu Jingchang-B35083 <B35083@freescale.com>
To: "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "djbw@fb.com" <djbw@fb.com>, "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wang Huan-B18965 <B18965@freescale.com>,
        Li Xiaochun-B41219 <B41219@freescale.com>
Subject: RE: [PATCH v3 3/3] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCH v3 3/3] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHOknJhXy0IY+ZTAE+GuB+KbJnWeJmMjXxw
Date: Fri, 9 Aug 2013 08:23:52 +0000
Message-ID: <B56CDBE15CE27145A4B77D2D24263E851FE3AD@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1375769118-20783-1-git-send-email-b35083@freescale.com>
 <1375769118-20783-2-git-send-email-b35083@freescale.com>
In-Reply-To: <1375769118-20783-2-git-send-email-b35083@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.98]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vinod,
  
  Could you please help to review the Freescale eDMA driver support patch? 
  Many thanks.


Best Regards,
Jingchang

> -----Original Message-----
> From: Lu Jingchang-B35083
> Sent: Tuesday, August 06, 2013 2:05 PM
> To: vinod.koul@intel.com
> Cc: djbw@fb.com; shawn.guo@linaro.org; linux-kenel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; Lu Jingchang-B35083; Wang Huan-
> B18965; Li Xiaochun-B41219
> Subject: [PATCH v3 3/3] dma: Add Freescale eDMA engine driver support
> 
> Add Freescale enhanced direct memory(eDMA) controller support.
> The eDMA controller deploys DMAMUXs routing DMA request sources(slot)
> to eDMA channels.
> This module can be found on Vybrid and LS-1 SoCs.
> 
> Signed-off-by: Alison Wang <b18965@freescale.com>
> Signed-off-by: Xiaochun Li <b41219@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
> changes in v3:
>   handle all interrupt pending one time.
>   add protect lock on dma transfer complete handling.
>   change desc and tcd alloc flag to GFP_NOWAIT.
>   add some sanity check and error messages.
> 
> changes in v2:
>   using generic dma-channels property instead of fsl,dma-channel.
>   rename the binding document to fsl-edma.txt.
> 
>  Documentation/devicetree/bindings/dma/fsl-edma.txt |  83 ++
>  drivers/dma/Kconfig                                |  10 +
>  drivers/dma/Makefile                               |   1 +
>  drivers/dma/fsl-edma.c                             | 855
> +++++++++++++++++++++
>  4 files changed, 949 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
>  create mode 100644 drivers/dma/fsl-edma.c
> 
> diff --git a/Documentation/devicetree/bindings/dma/fsl-edma.txt
> b/Documentation/devicetree/bindings/dma/fsl-edma.txt
> new file mode 100644
> index 0000000..a75e87c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/fsl-edma.txt
> @@ -0,0 +1,83 @@
> +* Freescale enhanced direct memory access(eDMA) Controller
> +
> +The eDMA engine deploys DMAMUXs routing request sources(slot) to
> +eDMA controller channels.
> +
> +* eDMA Controller
> +Required properties:
> +- compatible : Should be "fsl,<chip>-edma"
> +- reg : Should contain eDMA registers location and length
> +- interrupts : Should contain eDMA interrupt
> +- interrupt-names : Should be "edma-tx" for tx interrupt and
> +  "edma-err" for err interrupt
> +- #dma-cells : Must be <2>.
> +  The first cell specifies the DMAMUX ID. Specific request source
> +  can only be routed by specific DMAMUXs.
> +  the second cell specifies the request source(slot) ID.
> +  See include/dt-bindings/dma/<soc>-edma.h for all the supported
> +  request source IDs.
> +- dma-channels : Number of channels supported by the controller
> +- fsl,dma-mux : Phandle of the DMAMUXs deployed by the controller
> +
> +
> +* DMAMUX
> +Required properties:
> +- reg : Should contain DMAMUX registers location and length
> +- fsl,dmamux-id : DMAMUX ID. DMAMUX IDs are unique in each eDMA
> controller.
> +  inside one eDMA controller, specific request source can only be routed
> by
> +  one of its DMAMUXs.
> +  However Specific request source may be routed to different eDMA
> controller,
> +  thus all the DMAMUXs sharing a the same request sources have the same
> ID.
> +- clocks : Phandle of the clock used by the DMAMUX
> +- clock-names : The clock names
> +
> +Below is the eDMA controller and DMAMUX association, and DMAMUX IDs
> assignment
> +On Vybrid vf610 SoC, DMAMUX0 and DMAMU3 share the same request source
> group,
> +and DMAMUX1 and DMAMU2 share the same request source group.
> +
> +eDMA controller		DMAMUXs		DMAMUX ID
> +-------------------------------------------------
> +eDMA0			DMAMUX0		0
> +			DMAMUX1		1
> +
> +eDMA1			DMAMUX2		1
> +			DMAMUX3		0
> +
> +Examples:
> +
> +edma0: edma@40018000 {
> +	#dma-cells = <2>;
> +	compatible = "fsl,vf610-edma";
> +	reg = <0x40018000 0x2000>;
> +	interrupts = <0 8 0x04>, <0 9 0x04>;
> +	interrupt-names = "edma-tx", "edma-err";
> +	dma-channels = <32>;
> +	fsl,edma-mux = <&dmamux0>, <&dmamux1>;
> +};
> +
> +dmamux0: dmamux@40024000 {
> +	reg = <0x40024000 0x1000>;
> +	fsl,dmamux-id = <0>;
> +	clocks = <&clks VF610_CLK_DMAMUX0>;
> +	clock-names = "dmamux";
> +};
> +
> +
> +* DMA clients
> +DMA client drivers that uses the DMA function must use the format
> described
> +in the dma.txt file, using a three-cell specifier for each channel: a
> phandle
> +plus two integer cells as described above.
> +
> +Examples:
> +
> +sai2: sai@40031000 {
> +	compatible = "fsl,vf610-sai";
> +	reg = <0x40031000 0x1000>;
> +	interrupts = <0 86 0x04>;
> +	clocks = <&clks VF610_CLK_SAI2>;
> +	clock-names = "sai";
> +	dma-names = "tx", "rx";
> +	dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
> +		<&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;
> +	status = "disabled";
> +};
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 6825957..f9a6e06 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -300,6 +300,16 @@ config DMA_JZ4740
>  	select DMA_ENGINE
>  	select DMA_VIRTUAL_CHANNELS
> 
> +config FSL_EDMA
> +	tristate "Freescale eDMA engine support"
> +	depends on OF
> +	select DMA_ENGINE
> +	select DMA_VIRTUAL_CHANNELS
> +	help
> +	  Support the Freescale eDMA engine with DMAMUXs managing route
> +	  between request sources(slot) and eDMA engine channels.
> +	  This module can be found on Freescale Vybrid and LS-1 SoCs.
> +
>  config DMA_ENGINE
>  	bool
> 
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 5e0f2ef..fcbbac9 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -39,3 +39,4 @@ obj-$(CONFIG_MMP_TDMA) += mmp_tdma.o
>  obj-$(CONFIG_DMA_OMAP) += omap-dma.o
>  obj-$(CONFIG_MMP_PDMA) += mmp_pdma.o
>  obj-$(CONFIG_DMA_JZ4740) += dma-jz4740.o
> +obj-$(CONFIG_FSL_EDMA) += fsl-edma.o
> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
> new file mode 100644
> index 0000000..5104e5e
> --- /dev/null
> +++ b/drivers/dma/fsl-edma.c
> @@ -0,0 +1,855 @@
> +/*
> + * drivers/dma/fsl-edma.c
> + *
> + * Copyright 2013 Freescale Semiconductor, Inc.
> + *
> + * Driver for the Freescale eDMA engine with DMAMUXs managing route
> between
> + * request sources(slot) and eDMA engine channels, this module can be
> found
> + * on some Vybrid and Layerscape SoCs.
> + *
> + * This program is free software; you can redistribute  it and/or modify
> it
> + * under  the terms of  the GNU General  Public License as published by
> the
> + * Free Software Foundation;  either version 2 of the  License, or (at
> your
> + * option) any later version.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/clk.h>
> +#include <linux/spinlock.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_dma.h>
> +#include <linux/dmapool.h>
> +
> +#include "virt-dma.h"
> +
> +#define EDMA_CR			0x00
> +#define EDMA_ES			0x04
> +#define EDMA_ERQ		0x0C
> +#define EDMA_EEI		0x14
> +#define EDMA_SERQ		0x1B
> +#define EDMA_CERQ		0x1A
> +#define EDMA_SEEI		0x19
> +#define EDMA_CEEI		0x18
> +#define EDMA_CINT		0x1F
> +#define EDMA_CERR		0x1E
> +#define EDMA_SSRT		0x1D
> +#define EDMA_CDNE		0x1C
> +#define EDMA_INTR		0x24
> +#define EDMA_ERR		0x2C
> +
> +#define EDMA_TCD_SADDR(x)	(0x1000 + 32 * (x))
> +#define EDMA_TCD_SOFF(x)	(0x1004 + 32 * (x))
> +#define EDMA_TCD_ATTR(x)	(0x1006 + 32 * (x))
> +#define EDMA_TCD_NBYTES(x)	(0x1008 + 32 * (x))
> +#define EDMA_TCD_SLAST(x)	(0x100C + 32 * (x))
> +#define EDMA_TCD_DADDR(x)	(0x1010 + 32 * (x))
> +#define EDMA_TCD_DOFF(x)	(0x1014 + 32 * (x))
> +#define EDMA_TCD_CITER_ELINK(x)	(0x1016 + 32 * (x))
> +#define EDMA_TCD_CITER(x)	(0x1016 + 32 * (x))
> +#define EDMA_TCD_DLAST_SGA(x)	(0x1018 + 32 * (x))
> +#define EDMA_TCD_CSR(x)		(0x101C + 32 * (x))
> +#define EDMA_TCD_BITER_ELINK(x)	(0x101E + 32 * (x))
> +#define EDMA_TCD_BITER(x)	(0x101E + 32 * (x))
> +
> +#define EDMA_CR_EDBG		BIT(1)
> +#define EDMA_CR_ERCA		BIT(2)
> +#define EDMA_CR_ERGA		BIT(3)
> +#define EDMA_CR_HOE		BIT(4)
> +#define EDMA_CR_HALT		BIT(5)
> +#define EDMA_CR_CLM		BIT(6)
> +#define EDMA_CR_EMLM		BIT(7)
> +#define EDMA_CR_ECX		BIT(16)
> +#define EDMA_CR_CX		BIT(17)
> +
> +#define EDMA_SEEI_SEEI(x)	((x) & 0x1F)
> +#define EDMA_CEEI_CEEI(x)	((x) & 0x1F)
> +#define EDMA_CINT_CINT(x)	((x) & 0x1F)
> +#define EDMA_CERR_CERR(x)	((x) & 0x1F)
> +
> +#define EDMA_TCD_ATTR_DSIZE(x)		(((x) & 0x0007))
> +#define EDMA_TCD_ATTR_DMOD(x)		(((x) & 0x001F) << 3)
> +#define EDMA_TCD_ATTR_SSIZE(x)		(((x) & 0x0007) << 8)
> +#define EDMA_TCD_ATTR_SMOD(x)		(((x) & 0x001F) << 11)
> +#define EDMA_TCD_ATTR_SSIZE_8BIT	(0x0000)
> +#define EDMA_TCD_ATTR_SSIZE_16BIT	(0x0100)
> +#define EDMA_TCD_ATTR_SSIZE_32BIT	(0x0200)
> +#define EDMA_TCD_ATTR_SSIZE_64BIT	(0x0300)
> +#define EDMA_TCD_ATTR_SSIZE_32BYTE	(0x0500)
> +#define EDMA_TCD_ATTR_DSIZE_8BIT	(0x0000)
> +#define EDMA_TCD_ATTR_DSIZE_16BIT	(0x0001)
> +#define EDMA_TCD_ATTR_DSIZE_32BIT	(0x0002)
> +#define EDMA_TCD_ATTR_DSIZE_64BIT	(0x0003)
> +#define EDMA_TCD_ATTR_DSIZE_32BYTE	(0x0005)
> +
> +#define EDMA_TCD_CITER_MASK		0x7FFF
> +#define EDMA_TCD_BITER_MASK		0x7FFF
> +
> +#define EDMA_TCD_SOFF_SOFF(x)		(x)
> +#define EDMA_TCD_NBYTES_NBYTES(x)	(x)
> +#define EDMA_TCD_SLAST_SLAST(x)		(x)
> +#define EDMA_TCD_DADDR_DADDR(x)		(x)
> +#define EDMA_TCD_CITER_CITER(x)		((x) & 0x7FFF)
> +#define EDMA_TCD_DOFF_DOFF(x)		(x)
> +#define EDMA_TCD_DLAST_SGA_DLAST_SGA(x)	(x)
> +#define EDMA_TCD_BITER_BITER(x)		((x) & 0x7FFF)
> +
> +#define EDMA_TCD_CSR_START		BIT(0)
> +#define EDMA_TCD_CSR_INT_MAJOR		BIT(1)
> +#define EDMA_TCD_CSR_INT_HALF		BIT(2)
> +#define EDMA_TCD_CSR_D_REQ		BIT(3)
> +#define EDMA_TCD_CSR_E_SG		BIT(4)
> +#define EDMA_TCD_CSR_E_LINK		BIT(5)
> +#define EDMA_TCD_CSR_ACTIVE		BIT(6)
> +#define EDMA_TCD_CSR_DONE		BIT(7)
> +
> +#define EDMAMUX_CHCFG_DIS		0x0
> +#define EDMAMUX_CHCFG_ENBL		0x80
> +#define EDMAMUX_CHCFG_SOURCE(n)		((n) & 0x3F)
> +
> +struct fsl_edma_hw_tcd {
> +	u32	saddr;
> +	u16	soff;
> +	u16	attr;
> +	u32	nbytes;
> +	u32	slast;
> +	u32	daddr;
> +	u16	doff;
> +	u16	citer;
> +	u32	dlast_sga;
> +	u16	csr;
> +	u16	biter;
> +} __packed;
> +
> +struct fsl_edma_sw_tcd {
> +	dma_addr_t			ptcd;
> +	struct fsl_edma_hw_tcd		*vtcd;
> +};
> +
> +struct fsl_edma_slave_config {
> +	enum dma_transfer_direction	dir;
> +	enum dma_slave_buswidth		addr_width;
> +	u32				dev_addr;
> +	u32				burst;
> +	u32				attr;
> +};
> +
> +struct fsl_edma_dmamux {
> +	void __iomem			*membase;
> +	struct clk			*clk;
> +	u32				mux_id;
> +};
> +
> +struct fsl_edma_chan {
> +	struct virt_dma_chan		vchan;
> +	enum dma_status			status;
> +	struct fsl_edma_engine		*edma;
> +	struct fsl_edma_dmamux		*edmamux;
> +	struct fsl_edma_desc		*edesc;
> +
> +	u32				slot_id;
> +	struct fsl_edma_slave_config	fsc;
> +	struct dma_pool			*tcd_pool;
> +};
> +
> +struct fsl_edma_desc {
> +	struct virt_dma_desc		vdesc;
> +	struct fsl_edma_chan		*echan;
> +	bool				iscyclic;
> +	unsigned int			n_tcds;
> +	struct fsl_edma_sw_tcd		tcd[];
> +};
> +
> +struct fsl_edma_irq {
> +	int	txirq;
> +	int	errirq;
> +};
> +
> +struct fsl_edma_engine {
> +	struct dma_device	dma_dev;
> +	void __iomem		*membase;
> +	u32			n_chans;
> +	u32			n_muxes;
> +	struct fsl_edma_dmamux	*edmamux;
> +	struct fsl_edma_irq	edmairq;
> +	struct fsl_edma_chan	chans[];
> +};
> +
> +struct fsl_edma_filter_param {
> +	int	mux_id;
> +	int	slot_id;
> +};
> +
> +static inline struct fsl_edma_chan *to_fsl_edma_chan(struct dma_chan
> *chan)
> +{
> +	return container_of(chan, struct fsl_edma_chan, vchan.chan);
> +}
> +
> +static inline struct fsl_edma_desc *to_fsl_edma_desc(struct
> virt_dma_desc *vd)
> +{
> +	return container_of(vd, struct fsl_edma_desc, vdesc);
> +}
> +
> +static inline void fsl_edma_enable_request(struct fsl_edma_chan
> *fsl_chan)
> +{
> +	void __iomem *addr = fsl_chan->edma->membase;
> +	u32 ch = fsl_chan->vchan.chan.chan_id;
> +
> +	writeb(EDMA_SEEI_SEEI(ch), addr + EDMA_SEEI);
> +	writeb(ch, addr + EDMA_SERQ);
> +}
> +
> +static inline void fsl_edma_disable_request(struct fsl_edma_chan
> *fsl_chan)
> +{
> +	void __iomem *addr = fsl_chan->edma->membase;
> +	u32 ch = fsl_chan->vchan.chan.chan_id;
> +
> +	writeb(ch, addr + EDMA_CERQ);
> +	writeb(EDMA_CEEI_CEEI(ch), addr + EDMA_CEEI);
> +}
> +
> +static
> +void fsl_edmamux_config_chan(struct fsl_edma_chan *fsl_chan, unsigned
> char val)
> +{
> +	void __iomem *mux_addr = fsl_chan->edmamux->membase;
> +	unsigned chans_per_mux, ch;
> +
> +	chans_per_mux = fsl_chan->edma->n_chans / fsl_chan->edma->n_muxes;
> +	ch = fsl_chan->vchan.chan.chan_id % chans_per_mux;
> +
> +	writeb(val, mux_addr + ch);
> +}
> +
> +static unsigned int fsl_edma_get_tcd_attr(enum dma_slave_buswidth
> addr_width)
> +{
> +	switch (addr_width) {
> +	case 1:
> +		return EDMA_TCD_ATTR_SSIZE_8BIT | EDMA_TCD_ATTR_DSIZE_8BIT;
> +	case 2:
> +		return EDMA_TCD_ATTR_SSIZE_16BIT | EDMA_TCD_ATTR_DSIZE_16BIT;
> +	case 4:
> +		return EDMA_TCD_ATTR_SSIZE_32BIT | EDMA_TCD_ATTR_DSIZE_32BIT;
> +	case 8:
> +		return EDMA_TCD_ATTR_SSIZE_64BIT | EDMA_TCD_ATTR_DSIZE_64BIT;
> +	default:
> +		return EDMA_TCD_ATTR_SSIZE_32BIT | EDMA_TCD_ATTR_DSIZE_32BIT;
> +	}
> +}
> +
> +static void fsl_edma_free_desc(struct virt_dma_desc *vdesc)
> +{
> +	struct fsl_edma_desc *fsl_desc;
> +	int i;
> +
> +	fsl_desc = to_fsl_edma_desc(vdesc);
> +	for (i = 0; i < fsl_desc->n_tcds; i++)
> +			dma_pool_free(fsl_desc->echan->tcd_pool,
> +					fsl_desc->tcd[i].vtcd,
> +					fsl_desc->tcd[i].ptcd);
> +	kfree(fsl_desc);
> +}
> +
> +static int fsl_edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +		unsigned long arg)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct dma_slave_config *cfg = (void *)arg;
> +
> +	switch (cmd) {
> +	case DMA_TERMINATE_ALL:
> +		fsl_edma_disable_request(fsl_chan);
> +		fsl_chan->edesc = NULL;
> +		vchan_free_chan_resources(&fsl_chan->vchan);
> +		return 0;
> +
> +	case DMA_SLAVE_CONFIG:
> +		fsl_chan->fsc.dir = cfg->direction;
> +		if (cfg->direction == DMA_DEV_TO_MEM) {
> +			fsl_chan->fsc.dev_addr = cfg->src_addr;
> +			fsl_chan->fsc.addr_width = cfg->src_addr_width;
> +			fsl_chan->fsc.burst = cfg->src_maxburst;
> +			fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(cfg-
> >src_addr_width);
> +		} else if (cfg->direction == DMA_MEM_TO_DEV) {
> +			fsl_chan->fsc.dev_addr = cfg->dst_addr;
> +			fsl_chan->fsc.addr_width = cfg->dst_addr_width;
> +			fsl_chan->fsc.burst = cfg->dst_maxburst;
> +			fsl_chan->fsc.attr = fsl_edma_get_tcd_attr(cfg-
> >dst_addr_width);
> +		} else {
> +			return -EINVAL;
> +		}
> +		return 0;
> +
> +	default:
> +		return -ENXIO;
> +	}
> +}
> +
> +static enum dma_status fsl_edma_tx_status(struct dma_chan *chan,
> +		dma_cookie_t cookie, struct dma_tx_state *txstate)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +
> +	if (fsl_chan->status == DMA_ERROR)
> +		return DMA_ERROR;
> +
> +	return dma_cookie_status(chan, cookie, txstate);
> +}
> +
> +static void fsl_edma_set_tcd_params(struct fsl_edma_chan *fsl_chan,
> +		u32 src, u32 dst, u16 attr, u16 soff, u32 nbytes,
> +		u32 slast, u16 citer, u16 biter, u32 doff, u32 dlast_sga,
> +		u16 csr)
> +{
> +	void __iomem *addr = fsl_chan->edma->membase;
> +	u32 ch = fsl_chan->vchan.chan.chan_id;
> +
> +	writew(0, addr + EDMA_TCD_CSR(ch));
> +	writel(src, addr + EDMA_TCD_SADDR(ch));
> +	writel(dst, addr + EDMA_TCD_DADDR(ch));
> +	writew(attr, addr + EDMA_TCD_ATTR(ch));
> +	writew(EDMA_TCD_SOFF_SOFF(soff), addr + EDMA_TCD_SOFF(ch));
> +	writel(EDMA_TCD_NBYTES_NBYTES(nbytes), addr + EDMA_TCD_NBYTES(ch));
> +	writel(EDMA_TCD_SLAST_SLAST(slast), addr + EDMA_TCD_SLAST(ch));
> +	writew(EDMA_TCD_CITER_CITER(citer), addr + EDMA_TCD_CITER(ch));
> +	writew(EDMA_TCD_BITER_BITER(biter), addr + EDMA_TCD_BITER(ch));
> +	writew(EDMA_TCD_DOFF_DOFF(doff), addr + EDMA_TCD_DOFF(ch));
> +	writel(EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga),
> +					addr + EDMA_TCD_DLAST_SGA(ch));
> +	writew(csr, addr + EDMA_TCD_CSR(ch));
> +}
> +
> +static void fill_tcd_params(struct fsl_edma_hw_tcd *tcd, u32 src, u32
> dst,
> +		u16 attr, u16 soff, u32 nbytes, u32 slast, u16 citer,
> +		u16 biter, u16 doff, u32 dlast_sga, bool major_int,
> +		bool disable_req, bool enable_sg)
> +{
> +	tcd->saddr = src;
> +	tcd->attr = attr;
> +	tcd->soff = soff;
> +	tcd->nbytes = nbytes;
> +	tcd->slast = slast;
> +	tcd->daddr = dst;
> +	tcd->citer = citer;
> +	tcd->doff = doff;
> +	tcd->dlast_sga = dlast_sga;
> +	tcd->biter = biter;
> +	tcd->csr = 0;
> +	if (major_int)
> +		tcd->csr |= EDMA_TCD_CSR_INT_MAJOR;
> +
> +	if (disable_req)
> +		tcd->csr |= EDMA_TCD_CSR_D_REQ;
> +
> +	if (enable_sg)
> +		tcd->csr |= EDMA_TCD_CSR_E_SG;
> +}
> +
> +static struct fsl_edma_desc *fsl_edma_alloc_desc(struct fsl_edma_chan
> *fsl_chan,
> +		int sg_len)
> +{
> +	struct fsl_edma_desc *fsl_desc;
> +	int i;
> +
> +	fsl_desc = kzalloc(sizeof(*fsl_desc) + sizeof(struct
> fsl_edma_sw_tcd) * sg_len,
> +				GFP_NOWAIT);
> +	if (!fsl_desc)
> +		return NULL;
> +
> +	fsl_desc->echan = fsl_chan;
> +	fsl_desc->n_tcds = sg_len;
> +	for (i = 0; i < sg_len; i++) {
> +		fsl_desc->tcd[i].vtcd = dma_pool_alloc(fsl_chan->tcd_pool,
> +					GFP_NOWAIT, &fsl_desc->tcd[i].ptcd);
> +		if (!fsl_desc->tcd[i].vtcd)
> +			goto free_on_err;
> +	}
> +	return fsl_desc;
> +
> +free_on_err:
> +	while (--i >= 0)
> +		dma_pool_free(fsl_chan->tcd_pool, fsl_desc->tcd[i].vtcd,
> +				fsl_desc->tcd[i].ptcd);
> +	kfree(fsl_desc);
> +	return NULL;
> +}
> +
> +static struct dma_async_tx_descriptor *fsl_edma_prep_dma_cyclic(
> +		struct dma_chan *chan, dma_addr_t dma_addr, size_t buf_len,
> +		size_t period_len, enum dma_transfer_direction direction,
> +		unsigned long flags, void *context)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct fsl_edma_desc *fsl_desc;
> +	dma_addr_t dma_buf_next;
> +	int sg_len, i;
> +	u32 src_addr, dst_addr, last_sg, nbytes;
> +	u16 soff, doff, iter;
> +
> +	if (!fsl_chan->fsc.dir == DMA_MEM_TO_DEV &&
> +			!fsl_chan->fsc.dir == DMA_DEV_TO_MEM)
> +		return NULL;
> +
> +	sg_len = buf_len / period_len;
> +	fsl_desc = fsl_edma_alloc_desc(fsl_chan, sg_len);
> +	if (!fsl_desc)
> +		return NULL;
> +	fsl_desc->iscyclic = true;
> +
> +	dma_buf_next = dma_addr;
> +	nbytes = fsl_chan->fsc.addr_width * fsl_chan->fsc.burst;
> +	iter = period_len / nbytes;
> +	for (i = 0; i < sg_len; i++) {
> +		if (dma_buf_next >= dma_addr + buf_len)
> +			dma_buf_next = dma_addr;
> +
> +		/* get next sg's physical address */
> +		last_sg = fsl_desc->tcd[(i + 1) % sg_len].ptcd;
> +
> +		if (fsl_chan->fsc.dir == DMA_MEM_TO_DEV) {
> +			src_addr = dma_buf_next;
> +			dst_addr = fsl_chan->fsc.dev_addr;
> +			soff = fsl_chan->fsc.addr_width;
> +			doff = 0;
> +		} else {
> +			src_addr = fsl_chan->fsc.dev_addr;
> +			dst_addr = dma_buf_next;
> +			soff = 0;
> +			doff = fsl_chan->fsc.addr_width;
> +		}
> +
> +		fill_tcd_params(fsl_desc->tcd[i].vtcd, src_addr, dst_addr,
> +				fsl_chan->fsc.attr, soff, nbytes, 0,
> +				iter, iter, doff, last_sg, true, false, true);
> +		dma_buf_next += period_len;
> +	}
> +
> +	return vchan_tx_prep(&fsl_chan->vchan, &fsl_desc->vdesc, flags);
> +}
> +
> +static struct dma_async_tx_descriptor *fsl_edma_prep_slave_sg(
> +		struct dma_chan *chan, struct scatterlist *sgl,
> +		unsigned int sg_len, enum dma_transfer_direction direction,
> +		unsigned long flags, void *context)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct fsl_edma_desc *fsl_desc;
> +	struct scatterlist *sg;
> +	u32 src_addr, dst_addr, last_sg, nbytes;
> +	u16 soff, doff, iter;
> +	int i;
> +
> +	if (!fsl_chan->fsc.dir == DMA_MEM_TO_DEV &&
> +			!fsl_chan->fsc.dir == DMA_DEV_TO_MEM)
> +		return NULL;
> +
> +	fsl_desc = fsl_edma_alloc_desc(fsl_chan, sg_len);
> +	if (!fsl_desc)
> +		return NULL;
> +	fsl_desc->iscyclic = false;
> +
> +	nbytes = fsl_chan->fsc.addr_width * fsl_chan->fsc.burst;
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		/* get next sg's physical address */
> +		last_sg = fsl_desc->tcd[(i + 1) % sg_len].ptcd;
> +
> +		if (fsl_chan->fsc.dir == DMA_MEM_TO_DEV) {
> +			src_addr = sg_dma_address(sg);
> +			dst_addr = fsl_chan->fsc.dev_addr;
> +			soff = fsl_chan->fsc.addr_width;
> +			doff = 0;
> +		} else {
> +			src_addr = fsl_chan->fsc.dev_addr;
> +			dst_addr = sg_dma_address(sg);
> +			soff = 0;
> +			doff = fsl_chan->fsc.addr_width;
> +		}
> +
> +		iter = sg_dma_len(sg) / nbytes;
> +		if (i < sg_len - 1) {
> +			last_sg = fsl_desc->tcd[(i + 1)].ptcd;
> +			fill_tcd_params(fsl_desc->tcd[i].vtcd, src_addr,
> +				dst_addr, fsl_chan->fsc.attr, soff, nbytes, 0,
> +				iter, iter, doff, last_sg, false, false, true);
> +		} else {
> +			last_sg = 0;
> +			fill_tcd_params(fsl_desc->tcd[i].vtcd, src_addr,
> +				dst_addr, fsl_chan->fsc.attr, soff, nbytes, 0,
> +				iter, iter, doff, last_sg, true, true, false);
> +		}
> +	}
> +
> +	return vchan_tx_prep(&fsl_chan->vchan, &fsl_desc->vdesc, flags);
> +}
> +
> +static void fsl_edma_xfer_desc(struct fsl_edma_chan *fsl_chan)
> +{
> +	struct fsl_edma_hw_tcd *tcd;
> +	struct virt_dma_desc *vdesc;
> +
> +	vdesc = vchan_next_desc(&fsl_chan->vchan);
> +	if (!vdesc)
> +		return;
> +	fsl_chan->edesc = to_fsl_edma_desc(vdesc);
> +	tcd = fsl_chan->edesc->tcd[0].vtcd;
> +	fsl_edma_set_tcd_params(fsl_chan, tcd->saddr, tcd->daddr, tcd->attr,
> +			tcd->soff, tcd->nbytes, tcd->slast, tcd->citer,
> +			tcd->biter, tcd->doff, tcd->dlast_sga, tcd->csr);
> +	fsl_edma_enable_request(fsl_chan);
> +	fsl_chan->status = DMA_IN_PROGRESS;
> +}
> +
> +static irqreturn_t fsl_edma_irq_handler(int irq, void *dev_id)
> +{
> +	struct fsl_edma_engine *fsl_edma = dev_id;
> +	unsigned int intr, ch;
> +	void __iomem *base_addr;
> +	struct fsl_edma_chan *fsl_chan;
> +
> +	base_addr = fsl_edma->membase;
> +
> +	intr = readl(base_addr + EDMA_INTR);
> +	if (!intr)
> +		return IRQ_NONE;
> +
> +	for (ch = 0; ch < fsl_edma->n_chans; ch++) {
> +		if (intr & (0x1 << ch)) {
> +			writeb(EDMA_CINT_CINT(ch), base_addr + EDMA_CINT);
> +
> +			fsl_chan = &fsl_edma->chans[ch];
> +
> +			spin_lock(&fsl_chan->vchan.lock);
> +			if (!fsl_chan->edesc->iscyclic) {
> +				list_del(&fsl_chan->edesc->vdesc.node);
> +				vchan_cookie_complete(&fsl_chan->edesc->vdesc);
> +				fsl_chan->edesc = NULL;
> +				fsl_chan->status = DMA_SUCCESS;
> +			} else {
> +				vchan_cyclic_callback(&fsl_chan->edesc->vdesc);
> +			}
> +
> +			if (!fsl_chan->edesc)
> +				fsl_edma_xfer_desc(fsl_chan);
> +
> +			spin_unlock(&fsl_chan->vchan.lock);
> +		}
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t fsl_edma_err_handler(int irq, void *dev_id)
> +{
> +	struct fsl_edma_engine *fsl_edma = dev_id;
> +	unsigned int err, ch;
> +
> +	err = readl(fsl_edma->membase + EDMA_ERR);
> +	if (!err)
> +		return IRQ_NONE;
> +
> +	for (ch = 0; ch < fsl_edma->n_chans; ch++) {
> +		if (err & (0x1 << ch)) {
> +			fsl_edma_disable_request(&fsl_edma->chans[ch]);
> +			writeb(EDMA_CERR_CERR(ch), fsl_edma->membase +
> EDMA_CERR);
> +			fsl_edma->chans[ch].status = DMA_ERROR;
> +		}
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +
> +static void fsl_edma_issue_pending(struct dma_chan *chan)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fsl_chan->vchan.lock, flags);
> +
> +	if (vchan_issue_pending(&fsl_chan->vchan) && !fsl_chan->edesc)
> +		fsl_edma_xfer_desc(fsl_chan);
> +
> +	spin_unlock_irqrestore(&fsl_chan->vchan.lock, flags);
> +}
> +
> +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *fn_param)
> +{
> +	struct fsl_edma_filter_param *fparam = fn_param;
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +
> +	if (fsl_chan->edmamux->mux_id != fparam->mux_id)
> +		return false;
> +
> +	fsl_chan->slot_id = fparam->slot_id;
> +	chan->private = fn_param;
> +	return true;
> +}
> +
> +static struct dma_chan *fsl_edma_xlate(struct of_phandle_args *dma_spec,
> +		struct of_dma *ofdma)
> +{
> +	dma_cap_mask_t mask;
> +	struct fsl_edma_filter_param fparam;
> +
> +	if (dma_spec->args_count != 2)
> +		return NULL;
> +
> +	fparam.mux_id = dma_spec->args[0];
> +	fparam.slot_id = dma_spec->args[1];
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);
> +	dma_cap_set(DMA_CYCLIC, mask);
> +	return dma_request_channel(mask, fsl_edma_filter_fn, (void
> *)&fparam);
> +}
> +
> +static int fsl_edma_alloc_chan_resources(struct dma_chan *chan)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +	struct fsl_edma_filter_param *data = chan->private;
> +	unsigned char val;
> +
> +	val = EDMAMUX_CHCFG_ENBL | EDMAMUX_CHCFG_SOURCE(data->slot_id);
> +	fsl_edmamux_config_chan(fsl_chan, val);
> +
> +	fsl_chan->tcd_pool = dma_pool_create("tcd_pool", chan->device->dev,
> +				sizeof(struct fsl_edma_hw_tcd),
> +				32, 0);
> +	return 0;
> +}
> +
> +static void fsl_edma_free_chan_resources(struct dma_chan *chan)
> +{
> +	struct fsl_edma_chan *fsl_chan = to_fsl_edma_chan(chan);
> +
> +	fsl_edma_disable_request(fsl_chan);
> +	fsl_edmamux_config_chan(fsl_chan, EDMAMUX_CHCFG_DIS);
> +	fsl_chan->edesc = NULL;
> +	vchan_free_chan_resources(&fsl_chan->vchan);
> +	dma_pool_destroy(fsl_chan->tcd_pool);
> +	fsl_chan->tcd_pool = NULL;
> +}
> +
> +static int
> +fsl_init_edmamux(struct platform_device *pdev, struct fsl_edma_engine
> *fsl_edma)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct fsl_edma_dmamux *fsl_edmamux;
> +	struct device_node *phandle;
> +	const void *prop;
> +	struct resource res;
> +	int len, n_muxes, chans_per_mux, ch_off;
> +	int i, j;
> +	int ret;
> +
> +	prop = of_get_property(np, "fsl,dma-mux", &len);
> +	if (!prop) {
> +		dev_err(&pdev->dev, "Can't get DMAMUX.\n");
> +		return -EINVAL;
> +	}
> +
> +	n_muxes = len / sizeof(u32);
> +	chans_per_mux = fsl_edma->n_chans / n_muxes;
> +	fsl_edmamux = devm_kzalloc(&pdev->dev,
> +			sizeof(struct fsl_edma_dmamux) * n_muxes, GFP_KERNEL);
> +	if (!fsl_edmamux)
> +		return -ENOMEM;
> +
> +	fsl_edma->n_muxes = 0;
> +	fsl_edma->edmamux = fsl_edmamux;
> +	for (i = 0; i < n_muxes; i++) {
> +		phandle = of_parse_phandle(np, "fsl,dma-mux", i);
> +		ret = of_address_to_resource(phandle, 0, &res);
> +		if (ret)
> +			return ret;
> +		fsl_edmamux->membase = devm_ioremap_resource(&pdev->dev,
> &res);
> +		if (IS_ERR(fsl_edmamux->membase))
> +			return PTR_ERR(fsl_edmamux->membase);
> +
> +		fsl_edmamux->clk = of_clk_get(phandle, 0);
> +		if (IS_ERR(fsl_edmamux->clk)) {
> +			dev_err(&pdev->dev, "Missing DMAMUX clock.\n");
> +			return PTR_ERR(fsl_edmamux->clk);
> +		}
> +
> +		ret = clk_prepare_enable(fsl_edmamux->clk);
> +		if (ret) {
> +			dev_err(&pdev->dev, "DMAMUX clk enable failed.\n");
> +			return ret;
> +		}
> +
> +		ret = of_property_read_u32_index(phandle, "fsl,dmamux-id", 0,
> +				&fsl_edmamux->mux_id);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Can't get dmamux-id.\n");
> +			return ret;
> +		}
> +
> +		ch_off = fsl_edma->n_muxes * chans_per_mux;
> +		for (j = 0; j < chans_per_mux; j++)
> +			fsl_edma->chans[ch_off + j].edmamux = fsl_edmamux;
> +
> +		fsl_edmamux++;
> +		fsl_edma->n_muxes++;
> +	}
> +	return 0;
> +}
> +
> +static int
> +fsl_edma_init_irq(struct platform_device *pdev, struct fsl_edma_engine
> *fsl_edma)
> +{
> +	int ret;
> +
> +	fsl_edma->edmairq.txirq = platform_get_irq_byname(pdev, "edma-tx");
> +	if (fsl_edma->edmairq.txirq < 0) {
> +		dev_err(&pdev->dev, "Can't get edma-tx irq.\n");
> +		return fsl_edma->edmairq.txirq;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, fsl_edma->edmairq.txirq,
> +			fsl_edma_irq_handler, IRQF_SHARED, "eDMA tx", fsl_edma);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Can't register eDMA tx IRQ.\n");
> +		return  ret;
> +	}
> +
> +	fsl_edma->edmairq.errirq = platform_get_irq_byname(pdev, "edma-
> err");
> +	if (fsl_edma->edmairq.errirq < 0) {
> +		dev_err(&pdev->dev, "Can't get edma-err irq.\n");
> +		return fsl_edma->edmairq.errirq;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, fsl_edma->edmairq.errirq,
> +			fsl_edma_err_handler, IRQF_SHARED, "eDMA err",
> fsl_edma);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Can't register eDMA err IRQ.\n");
> +		return  ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int fsl_edma_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct fsl_edma_engine *fsl_edma;
> +	struct fsl_edma_chan *fsl_chan;
> +	struct resource *res;
> +	int len, chans;
> +	int ret, i;
> +
> +	ret = of_property_read_u32_index(np, "dma-channels", 0, &chans);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Can't get dma-channels.\n");
> +		return ret;
> +	}
> +
> +	len = sizeof(*fsl_edma) + sizeof(*fsl_chan) * chans;
> +	fsl_edma = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
> +	if (!fsl_edma)
> +		return -ENOMEM;
> +
> +	fsl_edma->n_chans = chans;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	fsl_edma->membase = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(fsl_edma->membase))
> +		return PTR_ERR(fsl_edma->membase);
> +
> +	ret = fsl_init_edmamux(pdev, fsl_edma);
> +	if (ret)
> +		return ret;
> +
> +	ret = fsl_edma_init_irq(pdev, fsl_edma);
> +	if (ret)
> +		return ret;
> +
> +	INIT_LIST_HEAD(&fsl_edma->dma_dev.channels);
> +	for (i = 0; i < fsl_edma->n_chans; i++) {
> +		struct fsl_edma_chan *fsl_chan = &fsl_edma->chans[i];
> +
> +		fsl_chan->edma = fsl_edma;
> +
> +		fsl_chan->vchan.desc_free = fsl_edma_free_desc;
> +		vchan_init(&fsl_chan->vchan, &fsl_edma->dma_dev);
> +
> +		writew(0x0, fsl_edma->membase + EDMA_TCD_CSR(i));
> +		fsl_edmamux_config_chan(fsl_chan, EDMAMUX_CHCFG_DIS);
> +	}
> +
> +	dma_cap_set(DMA_SLAVE, fsl_edma->dma_dev.cap_mask);
> +	dma_cap_set(DMA_CYCLIC, fsl_edma->dma_dev.cap_mask);
> +
> +	fsl_edma->dma_dev.dev = &pdev->dev;
> +	fsl_edma->dma_dev.device_alloc_chan_resources
> +		= fsl_edma_alloc_chan_resources;
> +	fsl_edma->dma_dev.device_free_chan_resources
> +		= fsl_edma_free_chan_resources;
> +	fsl_edma->dma_dev.device_tx_status = fsl_edma_tx_status;
> +	fsl_edma->dma_dev.device_prep_slave_sg = fsl_edma_prep_slave_sg;
> +	fsl_edma->dma_dev.device_prep_dma_cyclic = fsl_edma_prep_dma_cyclic;
> +	fsl_edma->dma_dev.device_control = fsl_edma_control;
> +	fsl_edma->dma_dev.device_issue_pending = fsl_edma_issue_pending;
> +
> +	platform_set_drvdata(pdev, fsl_edma);
> +
> +	ret = dma_async_device_register(&fsl_edma->dma_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Can't register Freescale eDMA
> engine.\n");
> +		return ret;
> +	}
> +
> +	ret = of_dma_controller_register(np, fsl_edma_xlate, fsl_edma);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Can't register Freescale eDMA
> of_dma.\n");
> +		dma_async_device_unregister(&fsl_edma->dma_dev);
> +		return ret;
> +	}
> +
> +	/* enable round robin arbitration */
> +	writel(EDMA_CR_ERGA | EDMA_CR_ERCA, fsl_edma->membase + EDMA_CR);
> +
> +	return 0;
> +}
> +
> +static int fsl_edma_remove(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct fsl_edma_engine *fsl_edma = platform_get_drvdata(pdev);
> +	int i;
> +
> +	of_dma_controller_free(np);
> +	dma_async_device_unregister(&fsl_edma->dma_dev);
> +
> +	for (i = 0; i < fsl_edma->n_muxes; i++) {
> +		clk_disable_unprepare(fsl_edma->edmamux[i].clk);
> +		clk_put(fsl_edma->edmamux[i].clk);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id fsl_edma_dt_ids[] = {
> +	{ .compatible = "fsl,vf610-edma", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, fsl_edma_dt_ids);
> +
> +static struct platform_driver fsl_edma_driver = {
> +	.driver		= {
> +		.name	= "fsl-edma",
> +		.owner  = THIS_MODULE,
> +		.of_match_table = fsl_edma_dt_ids,
> +	},
> +	.probe          = fsl_edma_probe,
> +	.remove		= fsl_edma_remove,
> +};
> +
> +module_platform_driver(fsl_edma_driver);
> +
> +MODULE_ALIAS("platform:fsl-edma");
> +MODULE_DESCRIPTION("Freescale eDMA engine driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.8.0


