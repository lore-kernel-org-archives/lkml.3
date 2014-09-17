Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaIQDiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:38:46 -0400
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:55356
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753617AbaIQDio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:38:44 -0400
X-Greylist: delayed 759 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 23:38:43 EDT
Date: Wed, 17 Sep 2014 11:45:15 +0800
From: Robin Gong <b38343@freescale.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <kernel@pengutronix.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917034514.GF27452@Robin-OptiPlex-780>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-2-git-send-email-b38343@freescale.com>
 <20140917021044.GD4796@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917021044.GD4796@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(199003)(24454002)(104016003)(77982003)(74502003)(33716001)(85306004)(21056001)(102836001)(87936001)(69596002)(4396001)(97756001)(74662003)(80022003)(46102003)(81342003)(79102003)(19580395003)(46406003)(81156004)(81542003)(84676001)(83072002)(99396002)(83322001)(85852003)(68736004)(92566001)(19580405001)(50466002)(6806004)(54356999)(76176999)(50986999)(23726002)(26826002)(64706001)(105606002)(97736003)(44976005)(20776003)(92726001)(106466001)(33656002)(47776003)(90102001)(110136001)(107046002)(31966008)(76482002)(95666004)(83506001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB343;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB343;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:10:45AM +0800, Shawn Guo wrote:
> On Fri, Sep 12, 2014 at 04:48:57PM +0800, Robin Gong wrote:
> > All chips of i.mx6 can be powered off by programming SNVS.
> > For example :
> > On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> > pmic ON/OFF pin, that will cause the whole PMIC powered off
> > except VSNVS. And system can restart once PMIC_ON_REQ goes
> > high by push POWRER key.
> 
> What's the behavior for those boards on which PMIC_ON_REQ isn't
> connected to anywhere?
>
System can't be powered off if not connect PMIC_ON_REQ. Although all of our
reference design for i.mx6 chips are connecting  PMIC_ON_REQ with external
PMIC, we need consider others may not use external PMIC. I'll add the info
into commit log or Kconfig.
> BTW, the commit log of the driver patch [[PATCH v2 2/3] ] should be
> improved.
> 
> Shawn
>
You mean the above info need added into commit log ,right?
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  .../bindings/power_supply/imx-snvs-poweroff.txt     | 21 +++++++++++++++++++++
> >  arch/arm/boot/dts/imx6qdl.dtsi                      |  5 +++++
> >  arch/arm/boot/dts/imx6sl.dtsi                       |  5 +++++
> >  arch/arm/boot/dts/imx6sx.dtsi                       |  5 +++++
> >  4 files changed, 36 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> > new file mode 100644
> > index 0000000..1a3ab9a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
> > @@ -0,0 +1,21 @@
> > +i.mx6 Poweroff Driver
> > +
> > +SNVS_LPCR in SNVS module can power off the whole system by pull
> > +PMIC_ON_REQ low.
> > +
> > +Required Properties:
> > +-compatible: "fsl,sec-v4.0-poweroff"
> > +-reg: Specifies the physical address of the SNVS_LPCR register
> > +
> > +Example:
> > +	snvs@020cc000 {
> > +		compatible = "fsl,sec-v4.0-mon", "simple-bus";
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +		ranges = <0 0x020cc000 0x4000>;
> > +		.....
> > +		snvs-poweroff@38 {
> > +			compatible = "fsl,sec-v4.0-poweroff";
> > +			reg = <0x38 0x4>;
> > +		};
> > +	}
> > diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> > index 70d7207..d2d7563 100644
> > --- a/arch/arm/boot/dts/imx6qdl.dtsi
> > +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> > @@ -650,6 +650,11 @@
> >  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
> >  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
> >  				};
> > +
> > +				snvs-poweroff@38 {
> > +					compatible = "fsl,sec-v4.0-poweroff";
> > +					reg = <0x38 0x4>;
> > +				};
> >  			};
> >  
> >  			epit1: epit@020d0000 { /* EPIT1 */
> > diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
> > index ba67714..6e1d8f6 100644
> > --- a/arch/arm/boot/dts/imx6sl.dtsi
> > +++ b/arch/arm/boot/dts/imx6sl.dtsi
> > @@ -568,6 +568,11 @@
> >  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
> >  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
> >  				};
> > +
> > +				snvs-poweroff@38 {
> > +					compatible = "fsl,sec-v4.0-poweroff";
> > +					reg = <0x38 0x4>;
> > +				};
> >  			};
> >  
> >  			epit1: epit@020d0000 {
> > diff --git a/arch/arm/boot/dts/imx6sx.dtsi b/arch/arm/boot/dts/imx6sx.dtsi
> > index d137caca..c1f937e 100644
> > --- a/arch/arm/boot/dts/imx6sx.dtsi
> > +++ b/arch/arm/boot/dts/imx6sx.dtsi
> > @@ -671,6 +671,11 @@
> >  					reg = <0x34 0x58>;
> >  					interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
> >  				};
> > +
> > +				snvs-poweroff@38 {
> > +					compatible = "fsl,sec-v4.0-poweroff";
> > +					reg = <0x38 0x4>;
> > +				};
> >  			};
> >  
> >  			epit1: epit@020d0000 {
> > -- 
> > 1.9.1
> > 
