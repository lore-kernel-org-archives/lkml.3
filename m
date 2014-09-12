Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaILHOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:14:54 -0400
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:55026
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752477AbaILHOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:14:53 -0400
Date: Fri, 12 Sep 2014 15:14:28 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Markus Pargmann <mpa@pengutronix.de>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140912071426.GA30261@audiosh1>
References: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
 <20140911225737.GA13926@Alpha> <20140912020110.GA414@audiosh1>
 <20140912061706.GA10680@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140912061706.GA10680@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(52314003)(24454002)(35774003)(92566001)(76176999)(84676001)(83072002)(46406003)(86362001)(95666004)(110136001)(106466001)(74502001)(31966008)(97756001)(90102001)(87936001)(26826002)(107046002)(23726002)(68736004)(85852003)(79102001)(20776003)(19580395003)(50986999)(50466002)(15975445006)(64706001)(93886004)(83506001)(54356999)(104016003)(102836001)(21056001)(33716001)(80022001)(105606002)(6806004)(77982001)(15202345003)(97736003)(85306004)(99396002)(74662001)(76482001)(44976005)(33656002)(81542001)(47776003)(4396001)(83322001)(81342001)(92726001)(46102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0612;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 08:17:06AM +0200, Markus Pargmann wrote:
> Hi,
> 
> On Fri, Sep 12, 2014 at 10:01:12AM +0800, Shengjiu Wang wrote:
> > On Thu, Sep 11, 2014 at 03:57:37PM -0700, Nicolin Chen wrote:
> > > On Thu, Sep 11, 2014 at 01:38:29PM +0800, Shengjiu Wang wrote:
> > > > Move the ipg clock enable and disable operation to startup and shutdown,
> > > > that is only enable ipg clock when ssi is working. Keep clock is disabled
> > > > when ssi is in idle.
> > > > otherwise, _fsl_ssi_set_dai_fmt function need to be called in probe,
> > > > so add ipg clock control for it.
> > > 
> > > It seems to be no objection so far against my last suggestion to
> > > use regmap's mmio_clk() for named ipg clk only. So you may still
> > > consider about that.
> > >
> > I think mmio_clk() can be put to another patch. and this patch only for clk_enable()
> > and clk_disable() operation.
> 
> I would also prefer Nicolin's suggestion using regmap's mmio clk. I
> think it may be better to not add this particular patch at all and just
> go with the mmio_clk patch. It should be easy enough to just add the
> clock names to the devicetrees. That way we can avoid all those clock
> enable/disable function calls.
>
I considered if use Nicolin's suggestion, I still need ot add those
enable/disable function calls, because I want to remove the enable/disable
function call in fsl_ssi_imx_probe, then I need to add enable/disable 
function call in _fsl_ssi_set_dai_fmt(), which is called in fsl_ssi_probe().
_fsl_ssi_set_dai_fmt() need to access the registers.

> >  
> > > Anyway, I'd like to do thing in parallel. So I just simply tested
> > > it on my side and its works fine, it may still need to be tested
> > > by others though.
> > > 
> > > Nicolina
> > 
> > Hi Markus
> > 
> > could you please review it, and share your comments?
> 
> I think the clock enabling for AC97 is missing in your patch.
> 
I add clock enable in fsl_ssi_startup(), I think it is enough for AC97, does it?

wang shengjiu

> Best regards,
> 
> Markus
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |


