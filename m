Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaCASoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 13:44:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36236 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaCASoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 13:44:39 -0500
Message-ID: <53122A6E.3070001@ti.com>
Date: Sun, 2 Mar 2014 00:13:58 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.torgue@st.com>, <devicetree@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 3/4] ARM: DT: STi: Add DT node for MiPHY365x
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org> <1392377036-12816-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1392377036-12816-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 14 February 2014 04:53 PM, Lee Jones wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
>
> Cc: devicetree@vger.kernel.org
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

since this uses 'dt-bindings/phy/phy-miphy365x.h' which is used in phy 
driver as well, I need ACK from dt maintainers so that I can queue both 
the driver and dt patches myself.

Thanks
Kishon
> ---
>   arch/arm/boot/dts/stih416-b2020-revE.dts |  6 +++++-
>   arch/arm/boot/dts/stih416-b2020.dts      |  6 ++++++
>   arch/arm/boot/dts/stih416.dtsi           | 13 +++++++++++++
>   3 files changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/stih416-b2020-revE.dts b/arch/arm/boot/dts/stih416-b2020-revE.dts
> index a874570..dbe67fa 100644
> --- a/arch/arm/boot/dts/stih416-b2020-revE.dts
> +++ b/arch/arm/boot/dts/stih416-b2020-revE.dts
> @@ -32,6 +32,10 @@
>   		ethernet1: ethernet@fef08000 {
>   			snps,reset-gpio 	= <&PIO0 7>;
>   		};
> -	};
>
> +		miphy365x_phy: miphy365x@0 {
> +			st,pcie_tx_pol_inv = <1>;
> +			st,sata_gen = "gen3";
> +		};
> +	};
>   };
> diff --git a/arch/arm/boot/dts/stih416-b2020.dts b/arch/arm/boot/dts/stih416-b2020.dts
> index 276f28d..fd9cbad 100644
> --- a/arch/arm/boot/dts/stih416-b2020.dts
> +++ b/arch/arm/boot/dts/stih416-b2020.dts
> @@ -13,4 +13,10 @@
>   	model = "STiH416 B2020";
>   	compatible = "st,stih416", "st,stih416-b2020";
>
> +	soc {
> +		miphy365x_phy: miphy365x@0 {
> +			st,pcie_tx_pol_inv = <1>;
> +			st,sata_gen = "gen3";
> +		};
> +	};
>   };
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 85b8063..9fd8efb 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -9,6 +9,8 @@
>   #include "stih41x.dtsi"
>   #include "stih416-clock.dtsi"
>   #include "stih416-pinctrl.dtsi"
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
>   #include <dt-bindings/interrupt-controller/arm-gic.h>
>   #include <dt-bindings/reset-controller/stih416-resets.h>
>   / {
> @@ -140,5 +142,16 @@
>   			clocks		= <&CLK_S_ICN_REG_0>;
>   		};
>
> +		miphy365x_phy: miphy365x@0 {
> +			compatible      = "st,miphy365x-phy";
> +			reg        	= <0xfe382000 0x100>,
> +					  <0xfe38a000 0x100>,
> +					  <0xfe394000 0x100>,
> +					  <0xfe804000 0x100>;
> +			reg-names  	= "sata0", "sata1", "pcie0", "pcie1";
> +
> +			#phy-cells 	= <2>;
> +			st,syscfg  	= <&syscfg_rear>;
> +		};
>   	};
>   };
>

