Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbaHZHLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:11:43 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:57994
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754354AbaHZHLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:11:35 -0400
Date: Tue, 26 Aug 2014 15:17:59 +0800
From: Robin Gong <b38343@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: <broonie@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Frank.Li@freescale.com>, <shawn.guo@linaro.org>
Subject: Re: [PATCH v4] spi: spi-imx: add DMA support
Message-ID: <20140826071757.GA32751@Robin-OptiPlex-780>
References: <1408752835-10995-1-git-send-email-b38343@freescale.com>
 <201408251007.22393.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201408251007.22393.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(51704005)(377454003)(199003)(23726002)(50986999)(44976005)(107046002)(69596002)(99396002)(20776003)(54356999)(81156004)(110136001)(47776003)(68736004)(83322001)(64706001)(76176999)(83072002)(81542001)(74502001)(74662001)(92726001)(92566001)(79102001)(31966008)(90102001)(6806004)(85306004)(4396001)(102836001)(33716001)(46406003)(106466001)(85852003)(80022001)(97756001)(95666004)(84676001)(81342001)(105606002)(83506001)(33656002)(87936001)(97736001)(77982001)(104016003)(21056001)(26826002)(46102001)(76482001)(50466002)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB488;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:07:22AM +0200, Marek Vasut wrote:
> On Saturday, August 23, 2014 at 02:13:55 AM, Robin Gong wrote:
> > After enable DMA
> 
> Please also add a commit message which describes the change, not only some test 
> results.
> 
> [...]
> 
 Ok, I will enrich it in next version.
> > @@ -911,6 +1194,13 @@ static int spi_imx_probe(struct platform_device
> > *pdev) goto out_put_per;
> > 
> >  	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
> > +	/*
> > +	 * Only validated on i.mx6 now, can remove the constrain if validated on
> > +	 * other chips.
> > +	 */
> 
> Given that the check below tests for imx51_ecspi_devtype_data ... does that 
> mean, that this code was never tested on MX51 and MX53, yet will be enabled
> for those chips and might possibly break them ?
> 
Yes, because there is no available mx51 mx53 boards in my hands. But I think it
won't bring too much trouble, since they share the same IP.
No, the patch won't break current MX51 and MX53, because they didn't enable dma
in dts setting,and they will keep use pio mode.

> > +	if (spi_imx->devtype_data == &imx51_ecspi_devtype_data
> > +	    && spi_imx_sdma_init(&pdev->dev, spi_imx, master, res))
> > +		dev_err(&pdev->dev, "dma setup error,use pio instead\n");
> > 
> >  	spi_imx->devtype_data->reset(spi_imx);
> > 
> > @@ -949,6 +1239,7 @@ static int spi_imx_remove(struct platform_device
> > *pdev) writel(0, spi_imx->base + MXC_CSPICTRL);
> >  	clk_unprepare(spi_imx->clk_ipg);
> >  	clk_unprepare(spi_imx->clk_per);
> > +	spi_imx_sdma_exit(spi_imx);
> >  	spi_master_put(master);
> > 
> >  	return 0;
> 
> Best regards,
> Marek Vasut
