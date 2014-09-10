Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaIJLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:16:29 -0400
Received: from mail-bn1bn0108.outbound.protection.outlook.com ([157.56.110.108]:58647
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751973AbaIJLQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:16:27 -0400
Date: Wed, 10 Sep 2014 19:22:59 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <marex@denx.de>,
        <shawn.guo@linaro.org>, <Frank.Li@freescale.com>
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
Message-ID: <20140910112258.GA30794@Robin-OptiPlex-780>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
 <20140910102105.GR2601@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140910102105.GR2601@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(24454002)(51704005)(189002)(199003)(54356999)(26826002)(31966008)(21056001)(50466002)(102836001)(81542001)(74502001)(76176999)(77982001)(83072002)(20776003)(83322001)(99396002)(64706001)(33656002)(107046002)(85306004)(81156004)(50986999)(87936001)(47776003)(80022001)(110136001)(106466001)(85852003)(79102001)(33716001)(4396001)(6806004)(84676001)(23726002)(95666004)(104016003)(69596002)(92726001)(44976005)(97756001)(46102001)(81342001)(97736003)(74662001)(90102001)(105606002)(92566001)(76482001)(83506001)(46406003)(68736004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB491;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:21:05AM +0100, Mark Brown wrote:
> On Wed, Sep 10, 2014 at 09:30:04AM +0800, Robin Gong wrote:
> 
> > +static bool spi_imx_can_dma(struct spi_master *master, struct spi_device *spi,
> > +			 struct spi_transfer *transfer)
> > +{
> > +	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
> > +
> > +	if (spi_imx->dma_is_inited && (transfer->len > spi_imx->rx_wml)
> > +	    && (transfer->len > spi_imx->tx_wml))
> > +		spi_imx->usedma = true;
> > +	else
> > +		spi_imx->usedma = false;
> > +
> > +	return spi_imx->usedma;
> > +}
> 
> This isn't going to work, anything that looks at the usedma flag will
> see the result of the last thing that was checked which may or may not
> be the transfer that it's handling.  The driver should check to see if
> the core mapped the transfer for DMA.
Yes, you're right. I should use "transfer->tx_sg->sgl == NULL" or
"transfer->rx_sg->sgl == NULL" instead of usedma flag in driver, right?

