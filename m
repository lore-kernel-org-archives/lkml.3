Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3HTIYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:24:08 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53900 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3HTIYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:24:04 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v2 2/4] dmaengine: add driver for Samsung s3c24xx SoCs
Date: Tue, 20 Aug 2013 10:23:49 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: kgene.kim@samsung.com, Dan Williams <djbw@fb.com>,
        linus.walleij@linaro.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
References: <201308141359.13872.heiko@sntech.de> <201308141400.25681.heiko@sntech.de> <20130819044811.GR32147@intel.com>
In-Reply-To: <20130819044811.GR32147@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201308201023.50594.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

Am Montag, 19. August 2013, 06:48:12 schrieb Vinod Koul:
> On Wed, Aug 14, 2013 at 02:00:25PM +0200, Heiko Stübner wrote:
> > This adds a new driver to support the s3c24xx dma using the dmaengine
> > and makes the old one in mach-s3c24xx obsolete in the long run.
> > 
> > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > with numerous virtual channels being mapped to a lot less physical ones.
> > The driver therefore borrows a lot from the amba-pl08x driver in this
> > regard. Functionality-wise the driver gains a memcpy ability in addition
> > to the slave_sg one.
> 
> If that is the case why cant we have this driver supported from pl08x
> driver? If the delta is only mapping then can that be seprated or both
> mapping hanlded? Maybe you and Linus have already though about that?

Yes we have ... As Tomasz has already written the hardware itself is very much 
different. It's only the concept of mapping virtual channels to physical 
channels that is somehow similar.

It seems my patch message is lacking in making this clearer ;-) .


> > The driver supports both the method for requesting the peripheral used
> > by SoCs before the S3C2443 and the different method for S3C2443 and
> > later.
> > 
> > On earlier SoCs the hardware channels usable for specific peripherals is
> > constrainted while on later SoCs all channels can be used for any
> > peripheral.
> > 
> > Tested on a s3c2416-based board, memcpy using the dmatest module and
> > slave_sg partially using the spi-s3c64xx driver.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > 
> > +#define DISRC			(0x00)
> > +#define DISRCC			(0x04)
> > +#define DISRCC_INC_INCREMENT	(0 << 0)
> > +#define DISRCC_INC_FIXED	(1 << 0)
> > +#define DISRCC_LOC_AHB		(0 << 1)
> > +#define DISRCC_LOC_APB		(1 << 1)
> > +
> > +#define DIDST			(0x08)
> > +#define DIDSTC			(0x0C)
> > +#define DIDSTC_INC_INCREMENT	(0 << 0)
> > +#define DIDSTC_INC_FIXED	(1 << 0)
> > +#define DIDSTC_LOC_AHB		(0 << 1)
> > +#define DIDSTC_LOC_APB		(1 << 1)
> > +#define DIDSTC_INT_TC0		(0 << 2)
> > +#define DIDSTC_INT_RELOAD	(1 << 2)
> > +
> > +#define DCON			(0x10)
> > +
> > +#define DCON_TC_MASK		0xfffff
> > +#define DCON_DSZ_BYTE		(0 << 20)
> > +#define DCON_DSZ_HALFWORD	(1 << 20)
> > +#define DCON_DSZ_WORD		(2 << 20)
> > +#define DCON_DSZ_MASK		(3 << 20)
> > +#define DCON_DSZ_SHIFT		20
> > +#define DCON_AUTORELOAD		(0 << 22)
> > +#define DCON_NORELOAD		(1 << 22)
> > +#define DCON_HWTRIG		(1 << 23)
> > +#define DCON_HWSRC_SHIFT	24
> > +#define DCON_SERV_SINGLE	(0 << 27)
> > +#define DCON_SERV_WHOLE		(1 << 27)
> > +#define DCON_TSZ_UNIT		(0 << 28)
> > +#define DCON_TSZ_BURST4		(1 << 28)
> > +#define DCON_INT		(1 << 29)
> > +#define DCON_SYNC_PCLK		(0 << 30)
> > +#define DCON_SYNC_HCLK		(1 << 30)
> > +#define DCON_DEMAND		(0 << 31)
> > +#define DCON_HANDSHAKE		(1 << 31)
> > +
> > +#define DSTAT			(0x14)
> > +#define DSTAT_STAT_BUSY		(1 << 20)
> > +#define DSTAT_CURRTC_MASK	0xfffff
> > +
> > +#define DMASKTRIG		(0x20)
> > +#define DMASKTRIG_STOP		(1 << 2)
> > +#define DMASKTRIG_ON		(1 << 1)
> > +#define DMASKTRIG_SWTRIG	(1 << 0)
> > +
> > +#define DMAREQSEL		(0x24)
> > +#define DMAREQSEL_HW		(1 << 0)
> 
> This is proper namespacing...

Hmm, I don't understand meaning of this sentence. Is it a suggestion to change 
anything?


> > +static int s3c24xx_dma_set_runtime_config(struct s3c24xx_dma_chan
> > *s3cchan, +				  struct dma_slave_config *config)
> > +{
> > +	if (!s3cchan->slave)
> > +		return -EINVAL;
> > +
> > +	/* Reject definitely invalid configurations */
> > +	if (config->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
> > +	    config->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
> > +		return -EINVAL;
> > +
> > +	s3cchan->cfg = *config;
> 
> you are takinga  ref to client pointer without a clue on when that would be
> freed. I dont think its a good idea!

hmm, the config pointer is dereferenced here and its data thus copyied into 
s3cchan->cfg, so no reference to the origial config pointer is kept.


> > +static irqreturn_t s3c24xx_dma_irq(int irq, void *data)
> > +{
> > +	struct s3c24xx_dma_phy *phy = data;
> > +	struct s3c24xx_dma_chan *s3cchan = phy->serving;
> > +	struct s3c24xx_txd *txd;
> > +
> > +	dev_dbg(&phy->host->pdev->dev, "interrupt on channel %d\n", phy->id);
> > +
> > +	if (!s3cchan) {
> > +		dev_err(&phy->host->pdev->dev, "interrupt on unused channel 
%d\n",
> > +			phy->id);
> > +		return IRQ_NONE;
> 
> hmmm, these channles belong to you. So if one of them is behvaing badly,
> then not handling the interrupt will make things worse...

hmm ... I'm not sure what a valid handling would be for this.

The interrupt is only asserted when a transfer is completed - there are no 
other interrupt-triggers. But when phy->serving is NULL, this also means that 
the clock of the channel is disabled at this time. So this _should_ never 
happen.

And as written above, the interrupt is only triggered when a transfer was 
completed and the channel is idle again, so if there is no virtual channel 
being served, there is nothing else to do.


Thanks
Heiko
