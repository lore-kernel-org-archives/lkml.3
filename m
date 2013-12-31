Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3LaPo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 10:44:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25575 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3LaPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 10:44:24 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-a5-52c2e65605db
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
Cc: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, mark.rutland@arm.com, jg1.han@samsung.com,
        joshi@samsung.com, t.figa@samsung.com, swarren@wwwdotorg.org,
        rob.herring@calxeda.com, grant.likely@linaro.org,
        christoffer.dall@linaro.org,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH V4 2/2] ARM: dts: Enable ahci sata and sata phy
Date: Tue, 31 Dec 2013 16:44:08 +0100
Message-id: <40868257.6Tm1252hrx@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1388408823-4963-3-git-send-email-yuvaraj.cd@samsung.com>
References: <1388408823-4963-1-git-send-email-yuvaraj.cd@samsung.com>
 <1388408823-4963-3-git-send-email-yuvaraj.cd@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jQd2wZ4eCDJatMrN48fofo8X8I+dY
	LQ782cFocXnhJVaL77u+sFv0LrjKZnHhaQ+bxabH11gtFrYtYbE4tuMRk8XlXXPYLJZev8hk
	cXjFASaLVwfbWCzWz3jNYvHwaDerxdlT5Q6CHmvmrWH0WPD5CrvHzll32T3uXNvD5rF5Sb1H
	35ZVjB7Hb2xn8vi8Sc5j49zQAM4oLpuU1JzMstQifbsEroyvOz4wF6y1r/j6176BcYthFyMn
	h4SAicSPZzvZIWwxiQv31rN1MXJxCAlMZ5RY33qRCcJpYZLYP/sgC0gVm4CVxMT2VYwgtoiA
	jsTu7VcYQYqYBdYwS1xfNZ0NJCEs4Cxx5elisCIWAVWJWdcfAK3g4OAV0JKY9DgUJCwq4Cmx
	Y/tKsHJOATeJ2/8aGSGWNTJKTDt2DayXV0BQ4sfke2CLmQXkJfbtn8oKYetI7G+dxjaBUWAW
	krJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM42p5J72Bc1WBxiFGAg1GJ
	h3fBg0NBQqyJZcWVuYcYJTiYlUR4g/YDhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJI
	TyxJzU5NLUgtgskycXBKNTBOWv1WMvFow62t0d5hlXZ3zxmr/eF2uLiOzeSs9gEvZcdFH5sb
	ZMXmRUfnaNhYmFq8KI0WiQiT4BZX7fzzTc25MDT5hXsR/6+DQY4Fl/4kON/uistKXL+0s8kx
	h0f0x/qvZ0KUFqwoE+NurS2dI5ouIvN2uurZLT82JOnE7Ppzzmh903GG00osxRmJhlrMRcWJ
	AFFUOHmyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-ide ML to Cc: ]

On Monday, December 30, 2013 06:37:03 PM Yuvaraj Kumar C D wrote:
> This patch adds dt entry for ahci sata controller and its
> corresponding phy controller.phy node has been added w.r.t
> new generic phy framework.
> 
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> ---
> 
> Changes since V3:
> 	1.Moved the binding info to the /bindings/phy/
> 
> Changes since V2:
> 	1.Used syscon interface to PMU handling.
> 	2.Changed "sata-phy-i2c" to "exynos-sataphy-i2c".
> 
> Changes since V1:
> 	1.Minor changes to node name convention.
> 	2.Updated binding document.
> 
>  .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 -------
>  .../devicetree/bindings/ata/exynos-sata.txt        |   25 +++++++-----
>  .../devicetree/bindings/phy/samsung-phy.txt        |   40 ++++++++++++++++++++
>  arch/arm/boot/dts/exynos5250-arndale.dts           |   11 ++++++
>  arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 +---
>  arch/arm/boot/dts/exynos5250.dtsi                  |   16 ++++++--
>  6 files changed, 81 insertions(+), 33 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
> deleted file mode 100644
> index 37824fa..0000000
> --- a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -* Samsung SATA PHY Controller
> -
> -SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
> -Each SATA PHY controller should have its own node.
> -
> -Required properties:
> -- compatible        : compatible list, contains "samsung,exynos5-sata-phy"
> -- reg               : <registers mapping>
> -
> -Example:
> -        sata@ffe07000 {
> -                compatible = "samsung,exynos5-sata-phy";
> -                reg = <0xffe07000 0x1000>;
> -        };
> diff --git a/Documentation/devicetree/bindings/ata/exynos-sata.txt b/Documentation/devicetree/bindings/ata/exynos-sata.txt
> index 0849f10..b2adb1f 100644
> --- a/Documentation/devicetree/bindings/ata/exynos-sata.txt
> +++ b/Documentation/devicetree/bindings/ata/exynos-sata.txt
> @@ -4,14 +4,21 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
>  Each SATA controller should have its own node.
>  
>  Required properties:
> -- compatible        : compatible list, contains "samsung,exynos5-sata"
> -- interrupts        : <interrupt mapping for SATA IRQ>
> -- reg               : <registers mapping>
> -- samsung,sata-freq : <frequency in MHz>
> +- compatible		: compatible list, contains "samsung,exynos5-sata"
> +- interrupts		: <interrupt mapping for SATA IRQ>
> +- reg			: <registers mapping>
> +- samsung,sata-freq	: <frequency in MHz>
> +- phys			: as mentioned in phy-bindings.txt
> +- phy-names		: as mentioned in phy-bindings.txt
>  
>  Example:
> -        sata@ffe08000 {
> -                compatible = "samsung,exynos5-sata";
> -                reg = <0xffe08000 0x1000>;
> -                interrupts = <115>;
> -        };
> +	sata@122f0000 {
> +		compatible = "snps,dwc-ahci";
> +		samsung,sata-freq = <66>;
> +		reg = <0x122f0000 0x1ff>;
> +		interrupts = <0 115 0>;
> +		clocks = <&clock 277>, <&clock 143>;
> +		clock-names = "sata", "sclk_sata";
> +		phys = <&sata_phy>;
> +		phy-names = "sata-phy";
> +	};
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index c0fccaa..876fe9b 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -20,3 +20,43 @@ Required properties:
>  - compatible : should be "samsung,exynos5250-dp-video-phy";
>  - reg : offset and length of the Display Port PHY register set;
>  - #phy-cells : from the generic PHY bindings, must be 0;
> +
> +Samsung SATA PHY Controller
> +---------------------------
> +
> +SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
> +Each SATA PHY controller should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "samsung,exynos5250-sata-phy"
> +- reg : offset and length of the SATA PHY register set;
> +- #phy-cells : from the generic phy bindings;
> +
> +Example:
> +	sata_phy: sata-phy@12170000 {
> +		compatible = "samsung,exynos5250-sata-phy";
> +		reg = <0x12170000 0x1ff>;
> +		clocks = <&clock 287>;
> +		clock-names = "sata_phyctrl";
> +		#phy-cells = <0>;

This example needs to be updated as the code below evolved to be just:

samsung,syscon-phandle = <&pmu_syscon>;

> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +		sataphy-pmu {
> +			reg = <0x10040724 0x4>;
> +		};

Otherwise the patch looks good.

> +	};
> +
> +Device-Tree bindings for sataphy i2c client driver
> +--------------------------------------------------
> +
> +Required properties:
> +compatible: Should be "samsung,exynos-sataphy-i2c"
> +- reg: I2C address of the sataphy i2c device.
> +
> +Example:
> +
> +	sata-phy@38 {
> +		compatible = "samsung,exynos-sataphy-i2c";
> +		reg = <0x38>;
> +	};
> diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
> index b42e658..25fe5a3 100644
> --- a/arch/arm/boot/dts/exynos5250-arndale.dts
> +++ b/arch/arm/boot/dts/exynos5250-arndale.dts
> @@ -370,6 +370,17 @@
>  		};
>  	};
>  
> +	i2c@121D0000 {
> +		samsung,i2c-sda-delay = <100>;
> +		samsung,i2c-max-bus-freq = <40000>;
> +		samsung,i2c-slave-addr = <0x38>;
> +
> +		sata-phy@38 {
> +			compatible = "samsung,exynos-sataphy-i2c";
> +			reg = <0x38>;
> +		};
> +	};
> +
>  	mmc_0: mmc@12200000 {
>  		status = "okay";
>  		num-slots = <1>;
> diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> index 3e69837..9e449e6 100644
> --- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
> +++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
> @@ -96,16 +96,12 @@
>  		samsung,i2c-slave-addr = <0x38>;
>  		status = "okay";
>  
> -		sata-phy {
> -			compatible = "samsung,sata-phy";
> +		sata-phy@38 {
> +			compatible = "samsung,exynos-sataphy-i2c";
>  			reg = <0x38>;
>  		};
>  	};
>  
> -	sata@122F0000 {
> -		samsung,sata-freq = <66>;
> -	};
> -
>  	i2c@12C80000 {
>  		samsung,i2c-sda-delay = <100>;
>  		samsung,i2c-max-bus-freq = <66000>;
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index dbb4a47..626a7d1 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -46,6 +46,7 @@
>  		i2c6 = &i2c_6;
>  		i2c7 = &i2c_7;
>  		i2c8 = &i2c_8;
> +		i2c9 = &i2c_9;
>  		pinctrl0 = &pinctrl_0;
>  		pinctrl1 = &pinctrl_1;
>  		pinctrl2 = &pinctrl_2;
> @@ -231,16 +232,23 @@
>  	};
>  
>  	sata@122F0000 {
> -		compatible = "samsung,exynos5-sata-ahci";
> +		compatible = "snps,dwc-ahci";
> +		samsung,sata-freq = <66>;
>  		reg = <0x122F0000 0x1ff>;
>  		interrupts = <0 115 0>;
>  		clocks = <&clock 277>, <&clock 143>;
>  		clock-names = "sata", "sclk_sata";
> +		phys = <&sata_phy>;
> +		phy-names = "sata-phy";
>  	};
>  
> -	sata-phy@12170000 {
> -		compatible = "samsung,exynos5-sata-phy";
> +	sata_phy: sata-phy@12170000 {
> +		compatible = "samsung,exynos5250-sata-phy";
>  		reg = <0x12170000 0x1ff>;
> +		clocks = <&clock 287>;
> +		clock-names = "sata_phyctrl";
> +		#phy-cells = <0>;
> +		samsung,syscon-phandle = <&pmu_syscon>;
>  	};
>  
>  	i2c_0: i2c@12C60000 {
> @@ -358,7 +366,7 @@
>  		status = "disabled";
>  	};
>  
> -	i2c@121D0000 {
> +	i2c_9: i2c@121D0000 {
>                  compatible = "samsung,exynos5-sata-phy-i2c";
>                  reg = <0x121D0000 0x100>;
>                  #address-cells = <1>;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

