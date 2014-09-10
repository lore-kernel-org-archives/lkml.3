Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaIJFYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 01:24:08 -0400
Received: from mail-bl2on0135.outbound.protection.outlook.com ([65.55.169.135]:18800
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbaIJFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 01:24:07 -0400
Date: Wed, 10 Sep 2014 13:16:16 +0800
From: Robin Gong <b38343@freescale.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: <kernel@pengutronix.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Frank.Li@freescale.com>
Subject: Re: [PATCH v1] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140910051615.GA29006@Robin-OptiPlex-780>
References: <1410312816-32171-1-git-send-email-b38343@freescale.com>
 <20140910032128.GD18566@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140910032128.GD18566@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(24454002)(189002)(51704005)(199003)(92566001)(92726001)(50466002)(4396001)(107046002)(81342001)(81156004)(33656002)(95666004)(76482001)(50986999)(76176999)(46406003)(84676001)(20776003)(64706001)(23726002)(47776003)(54356999)(87936001)(575784001)(79102001)(99396002)(110136001)(102836001)(81542001)(26826002)(83506001)(80022001)(104016003)(77982001)(97736003)(106466001)(44976005)(83322001)(19580395003)(97756001)(33716001)(85306004)(69596002)(19580405001)(6806004)(85852003)(21056001)(74502001)(105606002)(31966008)(90102001)(74662001)(83072002)(68736004)(46102001)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:21:30AM +0800, Shawn Guo wrote:
> On Wed, Sep 10, 2014 at 09:33:36AM +0800, Robin Gong wrote:
> > There is one weird data in rxfifo after one full rx/tx transfer
> > done sometimes. It looks a design issue and hard to workaround
> > totally, so disable dma functhion here. And will re-enable it
> > once the root cause found.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  arch/arm/boot/dts/imx6dl.dtsi | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
> > index b453e0e..e84a1ff 100644
> > --- a/arch/arm/boot/dts/imx6dl.dtsi
> > +++ b/arch/arm/boot/dts/imx6dl.dtsi
> > @@ -102,6 +102,22 @@
> >  	};
> >  };
> >  
> > +&ecspi1 {
> > +	dma-names = "", "";
> > +};
> > +
> > +&ecspi2 {
> > +	dma-names = "", "";
> > +};
> > +
> > +&ecspi3 {
> > +	dma-names = "", "";
> > +};
> > +
> > +&ecspi4 {
> > +	dma-names = "", "";
> > +};
> > +
> 
> This looks odd.  Can we drop the dma properties from imx6qdl.dtsi,
> and only add them in imx6q.dtsi instead?
> 
> Shawn
>
Ok, I'll send v2.
> >  &hdmi {
> >  	compatible = "fsl,imx6dl-hdmi";
> >  };
> > -- 
> > 1.9.1
> > 
