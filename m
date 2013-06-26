Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3FZEKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:10:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45447 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3FZEKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:10:00 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Fernandes, Joel" <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/5] ARM: dts: add AM33XX MMC support
Thread-Topic: [PATCH 2/5] ARM: dts: add AM33XX MMC support
Thread-Index: AQHOcgv03zJYruQ9akimQy0oL2f475lHYU3w
Date: Wed, 26 Jun 2013 04:08:59 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC43DC8@DBDE04.ent.ti.com>
References: <1372209881-6616-1-git-send-email-joelagnel@ti.com>
In-Reply-To: <1372209881-6616-1-git-send-email-joelagnel@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 06:54:41, Fernandes, Joel wrote:
> From: Matt Porter <mporter@ti.com>
> 
> Adds AM33XX MMC support for am335x-bone, am335x-evm, and
> am335x-evmsk.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/boot/dts/am335x-bone.dts  |    7 +++++++
>  arch/arm/boot/dts/am335x-evm.dts   |    7 +++++++
>  arch/arm/boot/dts/am335x-evmsk.dts |    7 +++++++
>  arch/arm/boot/dts/am33xx.dtsi      |   28 ++++++++++++++++++++++++++++
>  4 files changed, 49 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index 5302f79..80bff9c 100644
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
> index 0423298..62af561 100644
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
> index f67c360..8904b88 100644
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
> index b4fda12..119f8a9 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -229,6 +229,34 @@
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


MMC1 also needs "ti,needs-special-hs-handling" dt property to indicate support 
for properly supporting SD HS cards.

>From commit
commit cd587096c0e2b85a67e77721a753679bac89b394

    mmc: omap_hsmmc: Enable HSPE bit for high speed cards

    HSMMC IP on AM33xx need a special setting to handle High-speed cards.
    Other platforms like TI81xx, OMAP4 may need this as-well. This depends
    on the HSMMC IP timing closure done for the high speed cards.

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
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
