Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbaHZHqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:46:16 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:25314
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933905AbaHZHqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:46:10 -0400
Date: Tue, 26 Aug 2014 15:52:22 +0800
From: Robin Gong <b38343@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: <broonie@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Frank.Li@freescale.com>, <shawn.guo@linaro.org>
Subject: Re: [PATCH v4] spi: spi-imx: add DMA support
Message-ID: <20140826075220.GA820@Robin-OptiPlex-780>
References: <1408752835-10995-1-git-send-email-b38343@freescale.com>
 <201408251007.22393.marex@denx.de>
 <20140826071757.GA32751@Robin-OptiPlex-780>
 <201408260926.41038.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201408260926.41038.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(377454003)(52604005)(24454002)(199003)(105606002)(83506001)(81156004)(110136001)(99396002)(46102001)(104016003)(6806004)(76482001)(21056001)(31966008)(33716001)(83322001)(77982001)(79102001)(102836001)(95666004)(85852003)(33656002)(50986999)(50466002)(47776003)(90102001)(69596002)(23726002)(106466001)(92566001)(76176999)(87936001)(83072002)(64706001)(97736001)(80022001)(20776003)(26826002)(84676001)(68736004)(54356999)(74662001)(97756001)(44976005)(81342001)(81542001)(46406003)(93886004)(4396001)(92726001)(107046002)(85306004)(74502001)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB495;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 09:26:40AM +0200, Marek Vasut wrote:
> On Tuesday, August 26, 2014 at 09:17:59 AM, Robin Gong wrote:
> > On Mon, Aug 25, 2014 at 10:07:22AM +0200, Marek Vasut wrote:
> > > On Saturday, August 23, 2014 at 02:13:55 AM, Robin Gong wrote:
> > > > After enable DMA
> > > 
> > > Please also add a commit message which describes the change, not only
> > > some test results.
> > > 
> > > [...]
> > 
> >  Ok, I will enrich it in next version.
> > 
> > > > @@ -911,6 +1194,13 @@ static int spi_imx_probe(struct platform_device
> > > > *pdev) goto out_put_per;
> > > > 
> > > >  	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
> > > > 
> > > > +	/*
> > > > +	 * Only validated on i.mx6 now, can remove the constrain if validated
> > > > on +	 * other chips.
> > > > +	 */
> > > 
> > > Given that the check below tests for imx51_ecspi_devtype_data ... does
> > > that mean, that this code was never tested on MX51 and MX53, yet will be
> > > enabled for those chips and might possibly break them ?
> > 
> > Yes, because there is no available mx51 mx53 boards in my hands. But I
> > think it won't bring too much trouble, since they share the same IP.
> > No, the patch won't break current MX51 and MX53, because they didn't enable
> > dma in dts setting,and they will keep use pio mode.
> 
> Thanks for clearing this up, this was the important piece of information for me. 
> Please put it into the commit message.
>
 Okay. Thanks for your reminding.
> Best regards,
> Marek Vasut
