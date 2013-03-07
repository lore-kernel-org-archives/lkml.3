Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3CGOMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:12:05 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:34555 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab3CGOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:12:03 -0500
Date: Thu, 7 Mar 2013 09:12:35 -0500
From: Matt Porter <mporter@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Cc: "Krishnamoorthy, Balaji T" <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Message-ID: <20130307141235.GQ6209@beef>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
 <1362629799-22485-3-git-send-email-mporter@ti.com>
 <41fde401c8e646689123d7c6d3a2dffc@DLEE71.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41fde401c8e646689123d7c6d3a2dffc@DLEE71.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 05:29:24AM +0000, Vaibhav Hiremath wrote:
> > -----Original Message-----
> > From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> > owner@vger.kernel.org] On Behalf Of Porter, Matt
> > Sent: Thursday, March 07, 2013 9:47 AM
> > To: Krishnamoorthy, Balaji T; Chris Ball; Cousson, Benoit; Tony
> > Lindgren; Russell King
> > Cc: Devicetree Discuss; Linux ARM Kernel List; Linux OMAP List; Linux
> > Kernel Mailing List; Linux MMC List
> > Subject: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > 
> > Adds AM33XX MMC support for am335x-bone, am335x-evm, and
> > am335x-evmsk.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > ---
> >  arch/arm/boot/dts/am335x-bone.dts  |    7 +++++++
> >  arch/arm/boot/dts/am335x-evm.dts   |    7 +++++++
> >  arch/arm/boot/dts/am335x-evmsk.dts |    7 +++++++
> >  arch/arm/boot/dts/am33xx.dtsi      |   28 ++++++++++++++++++++++++++++
> >  4 files changed, 49 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/am335x-bone.dts
> > b/arch/arm/boot/dts/am335x-bone.dts
> > index 11b240c..a154ce0 100644
> > --- a/arch/arm/boot/dts/am335x-bone.dts
> > +++ b/arch/arm/boot/dts/am335x-bone.dts
> > @@ -120,6 +120,8 @@
> >  		};
> > 
> >  		ldo3_reg: regulator@5 {
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <3300000>;
> >  			regulator-always-on;
> >  		};
> > 
> > @@ -136,3 +138,8 @@
> >  &cpsw_emac1 {
> >  	phy_id = <&davinci_mdio>, <1>;
> >  };
> > +
> > +&mmc1 {
> > +	status = "okay";
> > +	vmmc-supply = <&ldo3_reg>;
> > +};
> > diff --git a/arch/arm/boot/dts/am335x-evm.dts
> > b/arch/arm/boot/dts/am335x-evm.dts
> > index d649644..2907da6 100644
> > --- a/arch/arm/boot/dts/am335x-evm.dts
> > +++ b/arch/arm/boot/dts/am335x-evm.dts
> > @@ -232,6 +232,8 @@
> >  		};
> > 
> >  		vmmc_reg: regulator@12 {
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <3300000>;
> >  			regulator-always-on;
> >  		};
> >  	};
> > @@ -244,3 +246,8 @@
> >  &cpsw_emac1 {
> >  	phy_id = <&davinci_mdio>, <1>;
> >  };
> > +
> > +&mmc1 {
> > +	status = "okay";
> > +	vmmc-supply = <&vmmc_reg>;
> > +};
> > diff --git a/arch/arm/boot/dts/am335x-evmsk.dts
> > b/arch/arm/boot/dts/am335x-evmsk.dts
> > index f5a6162..f050c46 100644
> > --- a/arch/arm/boot/dts/am335x-evmsk.dts
> > +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> > @@ -244,7 +244,14 @@
> >  		};
> > 
> >  		vmmc_reg: regulator@12 {
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <3300000>;
> >  			regulator-always-on;
> >  		};
> >  	};
> >  };
> > +
> > +&mmc1 {
> > +	status = "okay";
> > +	vmmc-supply = <&vmmc_reg>;
> > +};
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi
> > b/arch/arm/boot/dts/am33xx.dtsi
> > index c3c781a..e029eea 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -234,6 +234,34 @@
> >  			status = "disabled";
> >  		};
> > 
> > +		mmc1: mmc@48060000 {
> > +			compatible = "ti,omap3-hsmmc";
> > +			ti,hwmods = "mmc1";
> > +			ti,dual-volt;
> > +			ti,needs-special-reset;
> > +			dmas = <&edma 24
> > +				&edma 25>;
> > +			dma-names = "tx", "rx";
> > +			status = "disabled";
> > +		};
> > +
> > +		mmc2: mmc@481d8000 {
> > +			compatible = "ti,omap3-hsmmc";
> > +			ti,hwmods = "mmc2";
> > +			ti,needs-special-reset;
> > +			dmas = <&edma 2
> > +				&edma 3>;
> > +			dma-names = "tx", "rx";
> > +			status = "disabled";
> > +		};
> > +
> > +		mmc3: mmc@47810000 {
> > +			compatible = "ti,omap3-hsmmc";
> > +			ti,hwmods = "mmc3";
> > +			ti,needs-special-reset;
> > +			status = "disabled";
> > +		};
> Any specific reason why you did not add edma entry here as well?

Yes, I've answered this one before and I think this illustrates a need
for a comment in the .dtsi. mmc3 edma event are on the crossbar and so
the event that will be mapped is system-specific. Since Luca is still
working on DT support for WiLink, there's no way to show an example of
how this is used upstream as that's the only in-kernel user.

I have a test driver I've cited in the postings that shows how the
crossbar is configured via the board .dts. It doesn't belong in the
.dtsi, however, in this case. When WiLink DT support is ready we can
have an entry in the am335x-evmsk.dts that shows this case.

> Also, I wonder why "interrupt" property is not coming here, I understand
> That hwmod is filling the gap here; but I would still recommend you to complete
> The DT node, as we only support DT boot.

Yeah, I only added needed properties so as to not confuse people as to
where the interrupt resources are coming from. If you feel strongly
about this I don't have a problem with adding unused data in the dts.
I suppose this will help clear things to have a switch away from using
the hwmod data.

> I will test the whole patch series today and update you.

Thanks.

-Matt
