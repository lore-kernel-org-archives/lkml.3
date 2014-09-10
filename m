Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaIJFjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 01:39:51 -0400
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:27888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750791AbaIJFjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 01:39:49 -0400
X-Greylist: delayed 9155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 01:39:48 EDT
Date: Wed, 10 Sep 2014 13:46:22 +0800
From: Robin Gong <b38343@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <broonie@kernel.org>,
        <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <marex@denx.de>, <shawn.guo@linaro.org>, <Frank.Li@freescale.com>
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
Message-ID: <20140910054621.GA29307@Robin-OptiPlex-780>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
 <540FD084.6000805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <540FD084.6000805@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(479174003)(189002)(377454003)(199003)(51704005)(24454002)(69596002)(92726001)(104016003)(95666004)(97756001)(23726002)(81342001)(46102001)(44976005)(33716001)(4396001)(84676001)(6806004)(76482001)(83506001)(46406003)(68736004)(1411001)(74662001)(90102001)(97736003)(92566001)(105606002)(102836001)(50466002)(77982001)(76176999)(81542001)(74502001)(54356999)(21056001)(31966008)(26826002)(47776003)(106466001)(50986999)(87936001)(85852003)(79102001)(110136001)(80022001)(20776003)(81156004)(83072002)(99396002)(83322001)(64706001)(85306004)(107046002)(33656002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB491;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:46:04AM +0530, Varka Bhadram wrote:
> On 09/10/2014 07:00 AM, Robin Gong wrote:
> >Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> >to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
> 
> (...)
> 
> >+
> >+static int spi_imx_sdma_init(struct device *dev, struct spi_imx_data *spi_imx,
> >+			     struct spi_master *master,
> >+			     const struct resource *res)
> >+{
> >+	struct dma_slave_config slave_config = {};
> >+	int ret;
> >+
> >+	/* Prepare for TX DMA: */
> >+	master->dma_tx = dma_request_slave_channel(dev, "tx");
> >+	if (!master->dma_tx) {
> >+		dev_err(dev, "cannot get the TX DMA channel!\n");
> >+		ret = -EINVAL;
> >+		goto err;
> >+	}
> >+
> >+	slave_config.direction = DMA_MEM_TO_DEV;
> >+	slave_config.dst_addr = res->start + MXC_CSPITXDATA;
> >+	slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
> >+	slave_config.dst_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
> >+	ret = dmaengine_slave_config(master->dma_tx, &slave_config);
> >+	if (ret) {
> >+		dev_err(dev, "error in TX dma configuration.");
> >+		
> 
> Missed terminating new line..
>
You mean lack "\n" in the print info? If yes, I can improve it in v6.
> -- 
> Regards,
> Varka Bhadram.
> 
