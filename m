Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaKXW6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:58:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:58054 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaKXW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:58:09 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 4/4] ARM: dts: add suspend voltage setting for RK808
Date: Tue, 25 Nov 2014 00:01:45 +0100
Message-ID: <3286363.kbAg2FQ61M@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416051910-16730-5-git-send-email-zyw@rock-chips.com>
References: <1416051910-16730-1-git-send-email-zyw@rock-chips.com> <1416051910-16730-5-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

The subject above should reflect the pinctrl settings, something like:

"ARM: dts: rockchip: add suspend settings for rk3288-evb-rk808"

Same for the description:

Add suspend-voltages and necessary pin-states for suspend on
rk3288-evb-rk808 boards. global_pwroff would be pulled high when
RK3288 entering suspend, this pin is a sleep signal for RK808, so
RK808 could goto sleep mode, and some regulators would be disable.



Am Samstag, 15. November 2014, 19:45:10 schrieb Chris Zhong:
> global_pwroff would be pull to high when RK3288 entering suspend,
> this pin is a sleep signal for RK808, so RK808 could goto sleep
> mode, and some regulators would be disable.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> ---
> 
> Changes in v8:
> - keep all except cpu&tp power rail on during suspend
> - add regulator-on-in-suspend before set suspend voltage
> - add a reference of ddrio_pwroff and ddr0_retention
> 
> Changes in v7:
> - add regulator-state-mem sub node for suspend
> 
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  arch/arm/boot/dts/rk3288-evb-rk808.dts | 55
> +++++++++++++++++++++++++++++++++- arch/arm/boot/dts/rk3288-evb.dtsi      |
> 12 ++++++++
>  2 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts
> b/arch/arm/boot/dts/rk3288-evb-rk808.dts index d8c775e6..e4a8884 100644
> --- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
> +++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
> @@ -31,7 +31,7 @@
>  		interrupt-parent = <&gpio0>;
>  		interrupts = <4 IRQ_TYPE_LEVEL_LOW>;
>  		pinctrl-names = "default";
> -		pinctrl-0 = <&pmic_int>;
> +		pinctrl-0 = <&pmic_int &global_pwroff>;
>  		rockchip,system-power-controller;
>  		wakeup-source;
>  		#clock-cells = <1>;
> @@ -50,6 +50,9 @@
>  				regulator-min-microvolt = <750000>;
>  				regulator-max-microvolt = <1350000>;
>  				regulator-name = "vdd_arm";
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>  			};
> 
>  			vdd_gpu: DCDC_REG2 {
> @@ -58,12 +61,20 @@
>  				regulator-min-microvolt = <850000>;
>  				regulator-max-microvolt = <1250000>;
>  				regulator-name = "vdd_gpu";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <1000000>;
> +				};
>  			};
> 
>  			vcc_ddr: DCDC_REG3 {
>  				regulator-always-on;
>  				regulator-boot-on;
>  				regulator-name = "vcc_ddr";
> +				regulator-suspend-mem-enabled;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>  			};
> 
>  			vcc_io: DCDC_REG4 {
> @@ -72,6 +83,10 @@
>  				regulator-min-microvolt = <3300000>;
>  				regulator-max-microvolt = <3300000>;
>  				regulator-name = "vcc_io";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <3300000>;
> +				};
>  			};
> 
>  			vccio_pmu: LDO_REG1 {
> @@ -80,6 +95,10 @@
>  				regulator-min-microvolt = <3300000>;
>  				regulator-max-microvolt = <3300000>;
>  				regulator-name = "vccio_pmu";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <3300000>;
> +				};
>  			};
> 
>  			vcc_tp: LDO_REG2 {
> @@ -88,6 +107,9 @@
>  				regulator-min-microvolt = <3300000>;
>  				regulator-max-microvolt = <3300000>;
>  				regulator-name = "vcc_tp";
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>  			};
> 
>  			vdd_10: LDO_REG3 {
> @@ -96,6 +118,10 @@
>  				regulator-min-microvolt = <1000000>;
>  				regulator-max-microvolt = <1000000>;
>  				regulator-name = "vdd_10";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <1000000>;
> +				};
>  			};
> 
>  			vcc18_lcd: LDO_REG4 {
> @@ -104,6 +130,10 @@
>  				regulator-min-microvolt = <1800000>;
>  				regulator-max-microvolt = <1800000>;
>  				regulator-name = "vcc18_lcd";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <1800000>;
> +				};
>  			};
> 
>  			vccio_sd: LDO_REG5 {
> @@ -112,6 +142,10 @@
>  				regulator-min-microvolt = <1800000>;
>  				regulator-max-microvolt = <3300000>;
>  				regulator-name = "vccio_sd";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <3300000>;
> +				};
>  			};
> 
>  			vdd10_lcd: LDO_REG6 {
> @@ -120,6 +154,10 @@
>  				regulator-min-microvolt = <1000000>;
>  				regulator-max-microvolt = <1000000>;
>  				regulator-name = "vdd10_lcd";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <1000000>;
> +				};
>  			};
> 
>  			vcc_18: LDO_REG7 {
> @@ -128,6 +166,11 @@
>  				regulator-min-microvolt = <1800000>;
>  				regulator-max-microvolt = <1800000>;
>  				regulator-name = "vcc_18";
> +				regulator-suspend-mem-microvolt = <1800000>;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <1800000>;
> +				};
>  			};
> 
>  			vcca_codec: LDO_REG8 {
> @@ -136,18 +179,28 @@
>  				regulator-min-microvolt = <3300000>;
>  				regulator-max-microvolt = <3300000>;
>  				regulator-name = "vcca_codec";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-suspend-microvolt = <3300000>;
> +				};
>  			};
> 
>  			vcc_wl: SWITCH_REG1 {
>  				regulator-always-on;
>  				regulator-boot-on;
>  				regulator-name = "vcc_wl";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>  			};
> 
>  			vcc_lcd: SWITCH_REG2 {
>  				regulator-always-on;
>  				regulator-boot-on;
>  				regulator-name = "vcc_lcd";
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>  			};
>  		};
>  	};
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi
> b/arch/arm/boot/dts/rk3288-evb.dtsi index cb83cea..8d90fab 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -149,6 +149,18 @@
>  };
> 
>  &pinctrl {
> +	pinctrl-names = "default", "sleep";
> +	pinctrl-0 = <
> +		/* Common for sleep and wake, but no owners */
> +		&ddr0_retention
> +		&ddrio_pwroff
> +	>;
> +	pinctrl-1 = <
> +		/* Common for sleep and wake, but no owners */
> +		&ddr0_retention
> +		&ddrio_pwroff
> +	>;
> +
>  	backlight {
>  		bl_en: bl-en {
>  			rockchip,pins = <7 2 RK_FUNC_GPIO &pcfg_pull_none>;

