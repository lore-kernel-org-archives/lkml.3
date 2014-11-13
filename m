Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaKMCiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:38:15 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58308 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbaKMCiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:38:13 -0500
Message-ID: <5464198D.9030608@samsung.com>
Date: Thu, 13 Nov 2014 11:38:05 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: dts: Configure regulators for suspend on exynos
 Peach boards
References: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk> <1415707485-28563-4-git-send-email-javier.martinez@collabora.co.uk>
In-Reply-To: <1415707485-28563-4-git-send-email-javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 21:04, Javier Martinez Canillas wrote:
> The regulator core now has support to choose if a regulator
> has to be enabled or disabled during system suspend and also
> supports changing the regulator operating mode during runtime
> and when the system enters into sleep mode.
>
> To lower power during suspend, configure the regulators state
> using the same configuration found in the ChromeOS 3.8 kernel.
>
Basically I'm fine on this dt changes but this should be queued after 
confirming 1st and 2nd on this series from regulator maintainer...

Once they are landing into regulator tree, I will apply this.

Thanks,
Kukjin


> Signed-off-by: Javier Martinez Canillas<javier.martinez@collabora.co.uk>
> ---
>   arch/arm/boot/dts/exynos5420-peach-pit.dts | 81 ++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/exynos5800-peach-pi.dts  | 81 ++++++++++++++++++++++++++++++
>   2 files changed, 162 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index 9a050e1..8b744c7 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -13,6 +13,7 @@
>   #include<dt-bindings/gpio/gpio.h>
>   #include<dt-bindings/interrupt-controller/irq.h>
>   #include<dt-bindings/clock/maxim,max77802.h>
> +#include<dt-bindings/regulator/maxim,max77802.h>
>   #include "exynos5420.dtsi"
>
>   / {
> @@ -192,6 +193,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck2_reg: BUCK2 {
> @@ -201,6 +205,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck3_reg: BUCK3 {
> @@ -210,6 +217,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck4_reg: BUCK4 {
> @@ -219,6 +229,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck5_reg: BUCK5 {
> @@ -227,6 +240,9 @@
>   				regulator-max-microvolt =<1200000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck6_reg: BUCK6 {
> @@ -236,6 +252,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck7_reg: BUCK7 {
> @@ -244,6 +263,9 @@
>   				regulator-max-microvolt =<1350000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>   			};
>
>   			buck8_reg: BUCK8 {
> @@ -252,6 +274,9 @@
>   				regulator-max-microvolt =<2850000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck9_reg: BUCK9 {
> @@ -260,6 +285,9 @@
>   				regulator-max-microvolt =<2000000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>   			};
>
>   			buck10_reg: BUCK10 {
> @@ -268,6 +296,9 @@
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>   			};
>
>   			ldo1_reg: LDO1 {
> @@ -275,6 +306,10 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo2_reg: LDO2 {
> @@ -288,6 +323,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			vqmmc_sdcard: ldo4_reg: LDO4 {
> @@ -295,6 +334,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<2800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo5_reg: LDO5 {
> @@ -302,6 +344,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo6_reg: LDO6 {
> @@ -309,6 +354,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo7_reg: LDO7 {
> @@ -322,6 +370,9 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo9_reg: LDO9 {
> @@ -329,6 +380,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo10_reg: LDO10 {
> @@ -336,6 +391,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo11_reg: LDO11 {
> @@ -343,6 +401,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo12_reg: LDO12 {
> @@ -350,6 +412,9 @@
>   				regulator-min-microvolt =<3000000>;
>   				regulator-max-microvolt =<3000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo13_reg: LDO13 {
> @@ -357,6 +422,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo14_reg: LDO14 {
> @@ -364,6 +433,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo15_reg: LDO15 {
> @@ -371,6 +443,9 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo17_reg: LDO17 {
> @@ -378,6 +453,9 @@
>   				regulator-min-microvolt =<900000>;
>   				regulator-max-microvolt =<1400000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo18_reg: LDO18 {
> @@ -451,6 +529,9 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo32_reg: LDO32 {
> diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> index e8fdda8..df7fbde 100644
> --- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
> +++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
> @@ -13,6 +13,7 @@
>   #include<dt-bindings/gpio/gpio.h>
>   #include<dt-bindings/interrupt-controller/irq.h>
>   #include<dt-bindings/clock/maxim,max77802.h>
> +#include<dt-bindings/regulator/maxim,max77802.h>
>   #include "exynos5800.dtsi"
>
>   / {
> @@ -191,6 +192,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck2_reg: BUCK2 {
> @@ -200,6 +204,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck3_reg: BUCK3 {
> @@ -209,6 +216,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck4_reg: BUCK4 {
> @@ -218,6 +228,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck5_reg: BUCK5 {
> @@ -226,6 +239,9 @@
>   				regulator-max-microvolt =<1200000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck6_reg: BUCK6 {
> @@ -235,6 +251,9 @@
>   				regulator-always-on;
>   				regulator-boot-on;
>   				regulator-ramp-delay =<12500>;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck7_reg: BUCK7 {
> @@ -243,6 +262,9 @@
>   				regulator-max-microvolt =<1350000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>   			};
>
>   			buck8_reg: BUCK8 {
> @@ -251,6 +273,9 @@
>   				regulator-max-microvolt =<2850000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			buck9_reg: BUCK9 {
> @@ -259,6 +284,9 @@
>   				regulator-max-microvolt =<2000000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>   			};
>
>   			buck10_reg: BUCK10 {
> @@ -267,6 +295,9 @@
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
>   				regulator-boot-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +				};
>   			};
>
>   			ldo1_reg: LDO1 {
> @@ -274,6 +305,10 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo2_reg: LDO2 {
> @@ -287,6 +322,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			vqmmc_sdcard: ldo4_reg: LDO4 {
> @@ -294,6 +333,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<2800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo5_reg: LDO5 {
> @@ -301,6 +343,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo6_reg: LDO6 {
> @@ -308,6 +353,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo7_reg: LDO7 {
> @@ -321,6 +369,9 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo9_reg: LDO9 {
> @@ -328,6 +379,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo10_reg: LDO10 {
> @@ -335,6 +390,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo11_reg: LDO11 {
> @@ -342,6 +400,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo12_reg: LDO12 {
> @@ -349,6 +411,9 @@
>   				regulator-min-microvolt =<3000000>;
>   				regulator-max-microvolt =<3000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo13_reg: LDO13 {
> @@ -356,6 +421,10 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-on-in-suspend;
> +					regulator-mode =<MAX77802_OPMODE_LP>;
> +				};
>   			};
>
>   			ldo14_reg: LDO14 {
> @@ -363,6 +432,9 @@
>   				regulator-min-microvolt =<1800000>;
>   				regulator-max-microvolt =<1800000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo15_reg: LDO15 {
> @@ -370,6 +442,9 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo17_reg: LDO17 {
> @@ -377,6 +452,9 @@
>   				regulator-min-microvolt =<900000>;
>   				regulator-max-microvolt =<1400000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo18_reg: LDO18 {
> @@ -450,6 +528,9 @@
>   				regulator-min-microvolt =<1000000>;
>   				regulator-max-microvolt =<1000000>;
>   				regulator-always-on;
> +				regulator-state-mem {
> +					regulator-off-in-suspend;
> +				};
>   			};
>
>   			ldo32_reg: LDO32 {
