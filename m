Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab3K1KcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:32:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:48144 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab3K1KcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:32:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,790,1378882800"; 
   d="scan'208";a="416438028"
Date: Thu, 28 Nov 2013 15:04:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Florian Meier <florian.meier@koalo.de>, Daniel Mack <zonque@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mmp_pdma: Style neatening
Message-ID: <20131128093435.GA8834@intel.com>
References: <5288E327.8050809@koalo.de>
 <1384704123.2727.8.camel@joe-AO722>
 <5288F0E1.3020101@koalo.de>
 <1384719176.2727.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384719176.2727.19.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 12:12:56PM -0800, Joe Perches wrote:
> Neaten code used as a template for other drivers.
> Make the code more consistent with kernel styles.
> 
> o Convert #defines with (1<<foo) to BIT(foo)
> o Alignment wrapping
> o Logic inversions to put return at end of functions
> o Convert devm_kzalloc with multiply to devm_kcalloc
> o typo of Peripheral fix
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> > At least, the code is directly taken from mmp_pdma.c ;-)
> 
> Well, maybe the template code should be updated if there
> are going to be more of these.
>  
> Uncompiled/untested.
Compile tested and applied.

BUT you should not have hijacked the thread and sent this patch on a different
chain!

--
~Vinod
> 
>  drivers/dma/mmp_pdma.c | 204 +++++++++++++++++++++++++------------------------
>  1 file changed, 105 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index dcb1e05..c2658f6 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -5,6 +5,7 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> @@ -32,38 +33,37 @@
>  #define DTADR		0x0208
>  #define DCMD		0x020c
>  
> -#define DCSR_RUN	(1 << 31)	/* Run Bit (read / write) */
> -#define DCSR_NODESC	(1 << 30)	/* No-Descriptor Fetch (read / write) */
> -#define DCSR_STOPIRQEN	(1 << 29)	/* Stop Interrupt Enable (read / write) */
> -#define DCSR_REQPEND	(1 << 8)	/* Request Pending (read-only) */
> -#define DCSR_STOPSTATE	(1 << 3)	/* Stop State (read-only) */
> -#define DCSR_ENDINTR	(1 << 2)	/* End Interrupt (read / write) */
> -#define DCSR_STARTINTR	(1 << 1)	/* Start Interrupt (read / write) */
> -#define DCSR_BUSERR	(1 << 0)	/* Bus Error Interrupt (read / write) */
> -
> -#define DCSR_EORIRQEN	(1 << 28)       /* End of Receive Interrupt Enable (R/W) */
> -#define DCSR_EORJMPEN	(1 << 27)       /* Jump to next descriptor on EOR */
> -#define DCSR_EORSTOPEN	(1 << 26)       /* STOP on an EOR */
> -#define DCSR_SETCMPST	(1 << 25)       /* Set Descriptor Compare Status */
> -#define DCSR_CLRCMPST	(1 << 24)       /* Clear Descriptor Compare Status */
> -#define DCSR_CMPST	(1 << 10)       /* The Descriptor Compare Status */
> -#define DCSR_EORINTR	(1 << 9)        /* The end of Receive */
> -
> -#define DRCMR(n)	((((n) < 64) ? 0x0100 : 0x1100) + \
> -				 (((n) & 0x3f) << 2))
> -#define DRCMR_MAPVLD	(1 << 7)	/* Map Valid (read / write) */
> -#define DRCMR_CHLNUM	0x1f		/* mask for Channel Number (read / write) */
> +#define DCSR_RUN	BIT(31)	/* Run Bit (read / write) */
> +#define DCSR_NODESC	BIT(30)	/* No-Descriptor Fetch (read / write) */
> +#define DCSR_STOPIRQEN	BIT(29)	/* Stop Interrupt Enable (read / write) */
> +#define DCSR_REQPEND	BIT(8)	/* Request Pending (read-only) */
> +#define DCSR_STOPSTATE	BIT(3)	/* Stop State (read-only) */
> +#define DCSR_ENDINTR	BIT(2)	/* End Interrupt (read / write) */
> +#define DCSR_STARTINTR	BIT(1)	/* Start Interrupt (read / write) */
> +#define DCSR_BUSERR	BIT(0)	/* Bus Error Interrupt (read / write) */
> +
> +#define DCSR_EORIRQEN	BIT(28)	/* End of Receive Interrupt Enable (R/W) */
> +#define DCSR_EORJMPEN	BIT(27)	/* Jump to next descriptor on EOR */
> +#define DCSR_EORSTOPEN	BIT(26)	/* STOP on an EOR */
> +#define DCSR_SETCMPST	BIT(25)	/* Set Descriptor Compare Status */
> +#define DCSR_CLRCMPST	BIT(24)	/* Clear Descriptor Compare Status */
> +#define DCSR_CMPST	BIT(10)	/* The Descriptor Compare Status */
> +#define DCSR_EORINTR	BIT(9)	/* The end of Receive */
> +
> +#define DRCMR(n)	((((n) < 64) ? 0x0100 : 0x1100) + (((n) & 0x3f) << 2))
> +#define DRCMR_MAPVLD	BIT(7)	/* Map Valid (read / write) */
> +#define DRCMR_CHLNUM	0x1f	/* mask for Channel Number (read / write) */
>  
>  #define DDADR_DESCADDR	0xfffffff0	/* Address of next descriptor (mask) */
> -#define DDADR_STOP	(1 << 0)	/* Stop (read / write) */
> -
> -#define DCMD_INCSRCADDR	(1 << 31)	/* Source Address Increment Setting. */
> -#define DCMD_INCTRGADDR	(1 << 30)	/* Target Address Increment Setting. */
> -#define DCMD_FLOWSRC	(1 << 29)	/* Flow Control by the source. */
> -#define DCMD_FLOWTRG	(1 << 28)	/* Flow Control by the target. */
> -#define DCMD_STARTIRQEN	(1 << 22)	/* Start Interrupt Enable */
> -#define DCMD_ENDIRQEN	(1 << 21)	/* End Interrupt Enable */
> -#define DCMD_ENDIAN	(1 << 18)	/* Device Endian-ness. */
> +#define DDADR_STOP	BIT(0)	/* Stop (read / write) */
> +
> +#define DCMD_INCSRCADDR	BIT(31)	/* Source Address Increment Setting. */
> +#define DCMD_INCTRGADDR	BIT(30)	/* Target Address Increment Setting. */
> +#define DCMD_FLOWSRC	BIT(29)	/* Flow Control by the source. */
> +#define DCMD_FLOWTRG	BIT(28)	/* Flow Control by the target. */
> +#define DCMD_STARTIRQEN	BIT(22)	/* Start Interrupt Enable */
> +#define DCMD_ENDIRQEN	BIT(21)	/* End Interrupt Enable */
> +#define DCMD_ENDIAN	BIT(18)	/* Device Endian-ness. */
>  #define DCMD_BURST8	(1 << 16)	/* 8 byte burst */
>  #define DCMD_BURST16	(2 << 16)	/* 16 byte burst */
>  #define DCMD_BURST32	(3 << 16)	/* 32 byte burst */
> @@ -132,10 +132,14 @@ struct mmp_pdma_device {
>  	spinlock_t phy_lock; /* protect alloc/free phy channels */
>  };
>  
> -#define tx_to_mmp_pdma_desc(tx) container_of(tx, struct mmp_pdma_desc_sw, async_tx)
> -#define to_mmp_pdma_desc(lh) container_of(lh, struct mmp_pdma_desc_sw, node)
> -#define to_mmp_pdma_chan(dchan) container_of(dchan, struct mmp_pdma_chan, chan)
> -#define to_mmp_pdma_dev(dmadev) container_of(dmadev, struct mmp_pdma_device, device)
> +#define tx_to_mmp_pdma_desc(tx)					\
> +	container_of(tx, struct mmp_pdma_desc_sw, async_tx)
> +#define to_mmp_pdma_desc(lh)					\
> +	container_of(lh, struct mmp_pdma_desc_sw, node)
> +#define to_mmp_pdma_chan(dchan)					\
> +	container_of(dchan, struct mmp_pdma_chan, chan)
> +#define to_mmp_pdma_dev(dmadev)					\
> +	container_of(dmadev, struct mmp_pdma_device, device)
>  
>  static void set_desc(struct mmp_pdma_phy *phy, dma_addr_t addr)
>  {
> @@ -162,19 +166,18 @@ static void enable_chan(struct mmp_pdma_phy *phy)
>  	writel(dalgn, phy->base + DALGN);
>  
>  	reg = (phy->idx << 2) + DCSR;
> -	writel(readl(phy->base + reg) | DCSR_RUN,
> -					phy->base + reg);
> +	writel(readl(phy->base + reg) | DCSR_RUN, phy->base + reg);
>  }
>  
>  static void disable_chan(struct mmp_pdma_phy *phy)
>  {
>  	u32 reg;
>  
> -	if (phy) {
> -		reg = (phy->idx << 2) + DCSR;
> -		writel(readl(phy->base + reg) & ~DCSR_RUN,
> -						phy->base + reg);
> -	}
> +	if (!phy)
> +		return;
> +
> +	reg = (phy->idx << 2) + DCSR;
> +	writel(readl(phy->base + reg) & ~DCSR_RUN, phy->base + reg);
>  }
>  
>  static int clear_chan_irq(struct mmp_pdma_phy *phy)
> @@ -183,26 +186,27 @@ static int clear_chan_irq(struct mmp_pdma_phy *phy)
>  	u32 dint = readl(phy->base + DINT);
>  	u32 reg = (phy->idx << 2) + DCSR;
>  
> -	if (dint & BIT(phy->idx)) {
> -		/* clear irq */
> -		dcsr = readl(phy->base + reg);
> -		writel(dcsr, phy->base + reg);
> -		if ((dcsr & DCSR_BUSERR) && (phy->vchan))
> -			dev_warn(phy->vchan->dev, "DCSR_BUSERR\n");
> -		return 0;
> -	}
> -	return -EAGAIN;
> +	if (!(dint & BIT(phy->idx)))
> +		return -EAGAIN;
> +
> +	/* clear irq */
> +	dcsr = readl(phy->base + reg);
> +	writel(dcsr, phy->base + reg);
> +	if ((dcsr & DCSR_BUSERR) && (phy->vchan))
> +		dev_warn(phy->vchan->dev, "DCSR_BUSERR\n");
> +
> +	return 0;
>  }
>  
>  static irqreturn_t mmp_pdma_chan_handler(int irq, void *dev_id)
>  {
>  	struct mmp_pdma_phy *phy = dev_id;
>  
> -	if (clear_chan_irq(phy) == 0) {
> -		tasklet_schedule(&phy->vchan->tasklet);
> -		return IRQ_HANDLED;
> -	} else
> +	if (clear_chan_irq(phy) != 0)
>  		return IRQ_NONE;
> +
> +	tasklet_schedule(&phy->vchan->tasklet);
> +	return IRQ_HANDLED;
>  }
>  
>  static irqreturn_t mmp_pdma_int_handler(int irq, void *dev_id)
> @@ -224,8 +228,8 @@ static irqreturn_t mmp_pdma_int_handler(int irq, void *dev_id)
>  
>  	if (irq_num)
>  		return IRQ_HANDLED;
> -	else
> -		return IRQ_NONE;
> +
> +	return IRQ_NONE;
>  }
>  
>  /* lookup free phy channel as descending priority */
> @@ -245,9 +249,9 @@ static struct mmp_pdma_phy *lookup_phy(struct mmp_pdma_chan *pchan)
>  	 */
>  
>  	spin_lock_irqsave(&pdev->phy_lock, flags);
> -	for (prio = 0; prio <= (((pdev->dma_channels - 1) & 0xf) >> 2); prio++) {
> +	for (prio = 0; prio <= ((pdev->dma_channels - 1) & 0xf) >> 2; prio++) {
>  		for (i = 0; i < pdev->dma_channels; i++) {
> -			if (prio != ((i & 0xf) >> 2))
> +			if (prio != (i & 0xf) >> 2)
>  				continue;
>  			phy = &pdev->phy[i];
>  			if (!phy->vchan) {
> @@ -389,14 +393,16 @@ static int mmp_pdma_alloc_chan_resources(struct dma_chan *dchan)
>  	if (chan->desc_pool)
>  		return 1;
>  
> -	chan->desc_pool =
> -		dma_pool_create(dev_name(&dchan->dev->device), chan->dev,
> -				  sizeof(struct mmp_pdma_desc_sw),
> -				  __alignof__(struct mmp_pdma_desc_sw), 0);
> +	chan->desc_pool = dma_pool_create(dev_name(&dchan->dev->device),
> +					  chan->dev,
> +					  sizeof(struct mmp_pdma_desc_sw),
> +					  __alignof__(struct mmp_pdma_desc_sw),
> +					  0);
>  	if (!chan->desc_pool) {
>  		dev_err(chan->dev, "unable to allocate descriptor pool\n");
>  		return -ENOMEM;
>  	}
> +
>  	mmp_pdma_free_phy(chan);
>  	chan->idle = true;
>  	chan->dev_addr = 0;
> @@ -404,7 +410,7 @@ static int mmp_pdma_alloc_chan_resources(struct dma_chan *dchan)
>  }
>  
>  static void mmp_pdma_free_desc_list(struct mmp_pdma_chan *chan,
> -				  struct list_head *list)
> +				    struct list_head *list)
>  {
>  	struct mmp_pdma_desc_sw *desc, *_desc;
>  
> @@ -434,8 +440,8 @@ static void mmp_pdma_free_chan_resources(struct dma_chan *dchan)
>  
>  static struct dma_async_tx_descriptor *
>  mmp_pdma_prep_memcpy(struct dma_chan *dchan,
> -	dma_addr_t dma_dst, dma_addr_t dma_src,
> -	size_t len, unsigned long flags)
> +		     dma_addr_t dma_dst, dma_addr_t dma_src,
> +		     size_t len, unsigned long flags)
>  {
>  	struct mmp_pdma_chan *chan;
>  	struct mmp_pdma_desc_sw *first = NULL, *prev = NULL, *new;
> @@ -515,8 +521,8 @@ fail:
>  
>  static struct dma_async_tx_descriptor *
>  mmp_pdma_prep_slave_sg(struct dma_chan *dchan, struct scatterlist *sgl,
> -			 unsigned int sg_len, enum dma_transfer_direction dir,
> -			 unsigned long flags, void *context)
> +		       unsigned int sg_len, enum dma_transfer_direction dir,
> +		       unsigned long flags, void *context)
>  {
>  	struct mmp_pdma_chan *chan = to_mmp_pdma_chan(dchan);
>  	struct mmp_pdma_desc_sw *first = NULL, *prev = NULL, *new = NULL;
> @@ -591,10 +597,11 @@ fail:
>  	return NULL;
>  }
>  
> -static struct dma_async_tx_descriptor *mmp_pdma_prep_dma_cyclic(
> -	struct dma_chan *dchan, dma_addr_t buf_addr, size_t len,
> -	size_t period_len, enum dma_transfer_direction direction,
> -	unsigned long flags, void *context)
> +static struct dma_async_tx_descriptor *
> +mmp_pdma_prep_dma_cyclic(struct dma_chan *dchan,
> +			 dma_addr_t buf_addr, size_t len, size_t period_len,
> +			 enum dma_transfer_direction direction,
> +			 unsigned long flags, void *context)
>  {
>  	struct mmp_pdma_chan *chan;
>  	struct mmp_pdma_desc_sw *first = NULL, *prev = NULL, *new;
> @@ -636,8 +643,8 @@ static struct dma_async_tx_descriptor *mmp_pdma_prep_dma_cyclic(
>  			goto fail;
>  		}
>  
> -		new->desc.dcmd = chan->dcmd | DCMD_ENDIRQEN |
> -					(DCMD_LENGTH & period_len);
> +		new->desc.dcmd = (chan->dcmd | DCMD_ENDIRQEN |
> +				  (DCMD_LENGTH & period_len));
>  		new->desc.dsadr = dma_src;
>  		new->desc.dtadr = dma_dst;
>  
> @@ -677,12 +684,11 @@ fail:
>  }
>  
>  static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
> -		unsigned long arg)
> +			    unsigned long arg)
>  {
>  	struct mmp_pdma_chan *chan = to_mmp_pdma_chan(dchan);
>  	struct dma_slave_config *cfg = (void *)arg;
>  	unsigned long flags;
> -	int ret = 0;
>  	u32 maxburst = 0, addr = 0;
>  	enum dma_slave_buswidth width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
>  
> @@ -739,11 +745,12 @@ static int mmp_pdma_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
>  		return -ENOSYS;
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static enum dma_status mmp_pdma_tx_status(struct dma_chan *dchan,
> -			dma_cookie_t cookie, struct dma_tx_state *txstate)
> +					  dma_cookie_t cookie,
> +					  struct dma_tx_state *txstate)
>  {
>  	return dma_cookie_status(dchan, cookie, txstate);
>  }
> @@ -845,15 +852,14 @@ static int mmp_pdma_remove(struct platform_device *op)
>  	return 0;
>  }
>  
> -static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev,
> -							int idx, int irq)
> +static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev, int idx, int irq)
>  {
>  	struct mmp_pdma_phy *phy  = &pdev->phy[idx];
>  	struct mmp_pdma_chan *chan;
>  	int ret;
>  
> -	chan = devm_kzalloc(pdev->dev,
> -			sizeof(struct mmp_pdma_chan), GFP_KERNEL);
> +	chan = devm_kzalloc(pdev->dev, sizeof(struct mmp_pdma_chan),
> +			    GFP_KERNEL);
>  	if (chan == NULL)
>  		return -ENOMEM;
>  
> @@ -861,8 +867,8 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev,
>  	phy->base = pdev->base;
>  
>  	if (irq) {
> -		ret = devm_request_irq(pdev->dev, irq,
> -			mmp_pdma_chan_handler, 0, "pdma", phy);
> +		ret = devm_request_irq(pdev->dev, irq, mmp_pdma_chan_handler, 0,
> +				       "pdma", phy);
>  		if (ret) {
>  			dev_err(pdev->dev, "channel request irq fail!\n");
>  			return ret;
> @@ -877,8 +883,7 @@ static int mmp_pdma_chan_init(struct mmp_pdma_device *pdev,
>  	INIT_LIST_HEAD(&chan->chain_running);
>  
>  	/* register virt channel to dma engine */
> -	list_add_tail(&chan->chan.device_node,
> -			&pdev->device.channels);
> +	list_add_tail(&chan->chan.device_node, &pdev->device.channels);
>  
>  	return 0;
>  }
> @@ -913,13 +918,12 @@ retry:
>  	 * the lookup and the reservation */
>  	chan = dma_get_slave_channel(candidate);
>  
> -	if (chan) {
> -		struct mmp_pdma_chan *c = to_mmp_pdma_chan(chan);
> -		c->drcmr = dma_spec->args[0];
> -		return chan;
> -	}
> +	if (!chan)
> +		goto retry;
>  
> -	goto retry;
> +	to_mmp_pdma_chan(chan)->drcmr = dma_spec->args[0];
> +
> +	return chan;
>  }
>  
>  static int mmp_pdma_probe(struct platform_device *op)
> @@ -934,6 +938,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>  	pdev = devm_kzalloc(&op->dev, sizeof(*pdev), GFP_KERNEL);
>  	if (!pdev)
>  		return -ENOMEM;
> +
>  	pdev->dev = &op->dev;
>  
>  	spin_lock_init(&pdev->phy_lock);
> @@ -945,8 +950,8 @@ static int mmp_pdma_probe(struct platform_device *op)
>  
>  	of_id = of_match_device(mmp_pdma_dt_ids, pdev->dev);
>  	if (of_id)
> -		of_property_read_u32(pdev->dev->of_node,
> -				"#dma-channels", &dma_channels);
> +		of_property_read_u32(pdev->dev->of_node, "#dma-channels",
> +				     &dma_channels);
>  	else if (pdata && pdata->dma_channels)
>  		dma_channels = pdata->dma_channels;
>  	else
> @@ -958,8 +963,9 @@ static int mmp_pdma_probe(struct platform_device *op)
>  			irq_num++;
>  	}
>  
> -	pdev->phy = devm_kzalloc(pdev->dev,
> -		dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
> +	pdev->phy = devm_kcalloc(pdev->dev,
> +				 dma_channels, sizeof(struct mmp_pdma_chan),
> +				 GFP_KERNEL);
>  	if (pdev->phy == NULL)
>  		return -ENOMEM;
>  
> @@ -968,8 +974,8 @@ static int mmp_pdma_probe(struct platform_device *op)
>  	if (irq_num != dma_channels) {
>  		/* all chan share one irq, demux inside */
>  		irq = platform_get_irq(op, 0);
> -		ret = devm_request_irq(pdev->dev, irq,
> -			mmp_pdma_int_handler, 0, "pdma", pdev);
> +		ret = devm_request_irq(pdev->dev, irq, mmp_pdma_int_handler, 0,
> +				       "pdma", pdev);
>  		if (ret)
>  			return ret;
>  	}
> @@ -1044,7 +1050,7 @@ bool mmp_pdma_filter_fn(struct dma_chan *chan, void *param)
>  	if (chan->device->dev->driver != &mmp_pdma_driver.driver)
>  		return false;
>  
> -	c->drcmr = *(unsigned int *) param;
> +	c->drcmr = *(unsigned int *)param;
>  
>  	return true;
>  }
> @@ -1052,6 +1058,6 @@ EXPORT_SYMBOL_GPL(mmp_pdma_filter_fn);
>  
>  module_platform_driver(mmp_pdma_driver);
>  
> -MODULE_DESCRIPTION("MARVELL MMP Periphera DMA Driver");
> +MODULE_DESCRIPTION("MARVELL MMP Peripheral DMA Driver");
>  MODULE_AUTHOR("Marvell International Ltd.");
>  MODULE_LICENSE("GPL v2");
> 
> 
> 

-- 
