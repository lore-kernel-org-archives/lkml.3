Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbaLKXOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 18:14:30 -0500
Received: from mail-by2on0099.outbound.protection.outlook.com ([207.46.100.99]:5279
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934114AbaLKXO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 18:14:28 -0500
Date: Thu, 11 Dec 2014 17:14:24 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 6/6] staging: fpga manager: add driver for altera
 socfpga manager
In-Reply-To: <20141210150548.GB23358@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1412111710470.11739@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <1418156090-23578-7-git-send-email-atull@opensource.altera.com> <20141210150548.GB23358@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0062.namprd05.prod.outlook.com (10.141.20.32) To
 DM2PR0301MB1247.namprd03.prod.outlook.com (25.160.219.24)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1247;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:DM2PR0301MB1247;
X-Forefront-PRVS: 0422860ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(51704005)(24454002)(189002)(54356999)(76176999)(31966008)(50986999)(46406003)(120916001)(99396003)(42186005)(92566001)(87976001)(106356001)(83506001)(23726002)(105586002)(4396001)(86152002)(53416004)(69596002)(66066001)(107046002)(122386002)(81156004)(50466002)(47776003)(64706001)(20776003)(86362001)(110136001)(46102003)(68736005)(33716001)(97736003)(21056001)(62966003)(40100003)(77156002)(101416001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1247;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1247;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0638;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Steffen Trumtrar wrote:

> > +static inline void altera_fpga_reg_set_bitsl(struct altera_fpga_priv *priv,
> > +					     u32 offset, u32 bits)
> > +{
> > +	u32 val;
> > +
> > +	val = altera_fpga_reg_readl(priv, offset);
> > +	val |= bits;
> > +	altera_fpga_reg_writel(priv, offset, val);
> > +}
> > +
> > +static inline void altera_fpga_reg_clr_bitsl(struct altera_fpga_priv *priv,
> > +					     u32 offset, u32 bits)
> > +{
> > +	u32 val;
> > +
> > +	val = altera_fpga_reg_readl(priv, offset);
> > +	val &= ~bits;
> > +	altera_fpga_reg_writel(priv, offset, val);
> > +}
> > +
> 
> Why do you need these? Can't you just use regmap_mmio?

I would like to do that as an improvement as time allows, not now.

> > +	ret = request_irq(priv->irq, altera_fpga_isr, 0, "altera-fpga-mgr",
> > +			  priv);
> > +	if (ret < 0)
> > +		goto err_dispose_irq;
> 
> devm_request_irq

Will do, thanks.

Alan
