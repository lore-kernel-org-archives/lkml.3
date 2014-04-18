Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaDRV0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:26:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:65269 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaDRVZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:25:59 -0400
Message-ID: <5351985C.4090308@atmel.com>
Date: Fri, 18 Apr 2014 23:25:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/3] ARM: dts: sama5d3xcm: add the regulator device
 node
References: <1387852421-18033-1-git-send-email-wenyou.yang@atmel.com> <1387852570-18159-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1387852570-18159-1-git-send-email-wenyou.yang@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/12/2013 03:36, Wenyou Yang :
> Reviwed-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Wenyou,

While collecting patches for our next at91-3.16-dt branch I noticed this
patch that should go on top of the SAMA5D3 CMP board.

I would prefer to create another .dtsi file for CMP board and not mix
with the current cpu module usual board that does not contain this
regulator. But well we can do something even more simpler and move this
PMIC example to the newer SAMA5D3 Xplained board.

So, will it be possible for you to re-send a new patch targeted to
SAMA5D3 Xplained?

Thanks, bye.


> ---
>  arch/arm/boot/dts/sama5d3xcm.dtsi |   46 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
> index 726a0f3..3d4e5c2 100644
> --- a/arch/arm/boot/dts/sama5d3xcm.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
> @@ -38,6 +38,52 @@
>  			macb0: ethernet@f0028000 {
>  				phy-mode = "rgmii";
>  			};
> +
> +			i2c1: i2c@f0018000 {
> +				pmic: act8865@5b {
> +					compatible = "active-semi,act8865";
> +					reg = <0x5b>;
> +					status = "disabled";
> +
> +					regulators {
> +						vcc_1v8_reg: DCDC_REG1 {
> +							regulator-name = "VCC_1V8";
> +							regulator-min-microvolt = <1800000>;
> +							regulator-max-microvolt = <1800000>;
> +							regulator-always-on;
> +						};
> +
> +						vcc_1v2_reg: DCDC_REG2 {
> +							regulator-name = "VCC_1V2";
> +							regulator-min-microvolt = <1100000>;
> +							regulator-max-microvolt = <1300000>;
> +							regulator-suspend-mem-microvolt = <1150000>;
> +							regulator-suspend-standby-microvolt = <1150000>;
> +							regulator-always-on;
> +						};
> +
> +						vcc_3v3_reg: DCDC_REG3 {
> +							regulator-name = "VCC_3V3";
> +							regulator-min-microvolt = <3300000>;
> +							regulator-max-microvolt = <3300000>;
> +							regulator-always-on;
> +						};
> +
> +						vddana_reg: LDO_REG1 {
> +							regulator-name = "VDDANA";
> +							regulator-min-microvolt = <3300000>;
> +							regulator-max-microvolt = <3300000>;
> +							regulator-always-on;
> +						};
> +
> +						vddfuse_reg: LDO_REG2 {
> +							regulator-name = "FUSE_2V5";
> +							regulator-min-microvolt = <2500000>;
> +							regulator-max-microvolt = <2500000>;
> +						};
> +					};
> +				};
> +			};
>  		};
>  
>  		nand0: nand@60000000 {
> 


-- 
Nicolas Ferre
