Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaIJKCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:02:04 -0400
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:28448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751361AbaIJKCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:02:02 -0400
Date: Wed, 10 Sep 2014 18:01:42 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Timur Tabi <timur@tabi.org>, <Li.Xiubo@freescale.com>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <mpa@pengutronix.de>
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140910100141.GA17326@audiosh1>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada> <540F5706.1050303@tabi.org>
 <20140909195928.GA5224@Asurada>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140909195928.GA5224@Asurada>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(24454002)(189002)(51704005)(199003)(377454003)(479174003)(102836001)(93886004)(105606002)(54356999)(83506001)(81342001)(50466002)(64706001)(110136001)(99396002)(50986999)(77982001)(4396001)(97736003)(92726001)(46102001)(44976005)(47776003)(83322001)(80022001)(33716001)(21056001)(6806004)(69596002)(85306004)(33656002)(74662001)(90102001)(104016003)(87936001)(76482001)(81542001)(81156004)(84676001)(83072002)(46406003)(97756001)(74502001)(76176999)(107046002)(1411001)(23726002)(68736004)(79102001)(86362001)(92566001)(106466001)(31966008)(95666004)(26826002)(20776003)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0612;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 12:59:29PM -0700, Nicolin Chen wrote:
> On Tue, Sep 09, 2014 at 02:37:42PM -0500, Timur Tabi wrote:
> > On 09/09/2014 01:38 PM, Nicolin Chen wrote:
> > >make sure to have the call for imx only because it seems that
> > >the other platforms do not depend on the clock.
> > 
> > Although I doubt anyone will every add support for clocks to PowerPC "side"
> > of this driver, I would prefer to avoid IMX-specific changes. Instead, the
> > code should check if a clock is available.  That's why I suggested this
> > change:
> > 
> > -	if (ssi_private->soc->imx)
> > +	if (!IS_ERR(ssi_private->clk))
> 
> Hmm.... I think the following change may be better?
> 
> probe() {
> 	....
> +	/*
> +	 * Initially mark the clock to NULL for all platforms so that later
> +	 * clk_prepare_enable() will ignore and return 0 for non-clock cases.
> +	 */
> +	ssi_private->clk = NULL;
> 	.....
> 	fsl_ssi_imx_probe();
> }
ssi_private is initialized to zero in beginning of probe. I think no need to
add this change here.

wang shengjiu
> 
> In this way, all platforms, not confined to imx any more, will be able
> to call clk_prepare_enable(). Then we don't need an extra platform check
> before calling it.
