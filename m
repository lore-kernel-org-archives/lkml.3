Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3AKRz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 12:55:56 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46780 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754844Ab3AKRzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 12:55:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19I1imojn5vkRNHHT10Fmi+
Date: Fri, 11 Jan 2013 09:55:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 11/14] ARM: dts: add AM33XX MMC support
Message-ID: <20130111175545.GJ14149@atomide.com>
References: <1357883330-5364-1-git-send-email-mporter@ti.com>
 <1357883330-5364-12-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357883330-5364-12-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [130110 21:47]:
> Adds AM33XX MMC support for am335x-bone, am335x-evm, and
> am335x-evmsk..

This one should be queued separately by Benoit:

Acked-by: Tony Lindgren <tony@atomide.com>
 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/boot/dts/am335x-bone.dts  |    7 +++++++
>  arch/arm/boot/dts/am335x-evm.dts   |    7 +++++++
>  arch/arm/boot/dts/am335x-evmsk.dts |    7 +++++++
>  arch/arm/boot/dts/am33xx.dtsi      |   28 ++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index 11b240c..a154ce0 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -120,6 +120,8 @@
>  		};
>  
>  		ldo3_reg: regulator@5 {
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <3300000>;
>  			regulator-always-on;
>  		};
>  
> @@ -136,3 +138,8 @@
>  &cpsw_emac1 {
>  	phy_id = <&davinci_mdio>, <1>;
>  };
> +
> +&mmc1 {
> +	status = "okay";
> +	vmmc-supply = <&ldo3_reg>;
> +};
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index d649644..2907da6 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -232,6 +232,8 @@
>  		};
>  
>  		vmmc_reg: regulator@12 {
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <3300000>;
>  			regulator-always-on;
>  		};
>  	};
> @@ -244,3 +246,8 @@
>  &cpsw_emac1 {
>  	phy_id = <&davinci_mdio>, <1>;
>  };
> +
> +&mmc1 {
> +	status = "okay";
> +	vmmc-supply = <&vmmc_reg>;
> +};
> diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
> index f5a6162..f050c46 100644
> --- a/arch/arm/boot/dts/am335x-evmsk.dts
> +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> @@ -244,7 +244,14 @@
>  		};
>  
>  		vmmc_reg: regulator@12 {
> +			regulator-min-microvolt = <1800000>;
> +			regulator-max-microvolt = <3300000>;
>  			regulator-always-on;
>  		};
>  	};
>  };
> +
> +&mmc1 {
> +	status = "okay";
> +	vmmc-supply = <&vmmc_reg>;
> +};
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index e711ffb..278b75d 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -235,6 +235,34 @@
>  			status = "disabled";
>  		};
>  
> +		mmc1: mmc@48060000 {
> +			compatible = "ti,omap3-hsmmc";
> +			ti,hwmods = "mmc1";
> +			ti,dual-volt;
> +			ti,needs-special-reset;
> +			dmas = <&edma 24
> +				&edma 25>;
> +			dma-names = "tx", "rx";
> +			status = "disabled";
> +		};
> +
> +		mmc2: mmc@481d8000 {
> +			compatible = "ti,omap3-hsmmc";
> +			ti,hwmods = "mmc2";
> +			ti,needs-special-reset;
> +			dmas = <&edma 2
> +				&edma 3>;
> +			dma-names = "tx", "rx";
> +			status = "disabled";
> +		};
> +
> +		mmc3: mmc@47810000 {
> +			compatible = "ti,omap3-hsmmc";
> +			ti,hwmods = "mmc3";
> +			ti,needs-special-reset;
> +			status = "disabled";
> +		};
> +
>  		wdt2: wdt@44e35000 {
>  			compatible = "ti,omap3-wdt";
>  			ti,hwmods = "wd_timer2";
> -- 
> 1.7.9.5
> 
