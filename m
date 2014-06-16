Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaFPOCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:02:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49657 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:02:04 -0400
Message-ID: <539EF8C6.1080207@ti.com>
Date: Mon, 16 Jun 2014 17:01:42 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <mturquette@linaro.org>,
        <grant.likely@linaro.org>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <robh+dt@kernel.org>, <bcousson@baylibre.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/4] ARM: DTS: dra7/dra7xx-clocks: ATL related changes
References: <1399458048-28213-1-git-send-email-peter.ujfalusi@ti.com> <1399458048-28213-5-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1399458048-28213-5-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 01:20 PM, Peter Ujfalusi wrote:
> Modify the clock nodes for the ATL clocks to use the ATL clock driver to
> handle them.
>
> Add the ATL device node at the same time for DRA7.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

This patch missed the merge window due to long dependency chain, however 
Tony promised to pull this with rc-fixes. So, for that purpose:

Acked-by: Tero Kristo <t-kristo@ti.com>

> ---
>   arch/arm/boot/dts/dra7.dtsi          | 11 +++++++++++
>   arch/arm/boot/dts/dra7xx-clocks.dtsi | 16 ++++++++--------
>   2 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 149b55099935..84071423016e 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -789,6 +789,17 @@
>   			dma-names = "tx0", "rx0";
>   			status = "disabled";
>   		};
> +
> +		atl: atl@4843c000 {
> +			compatible = "ti,dra7-atl";
> +			reg = <0x4843c000 0x3ff>;
> +			ti,hwmods = "atl";
> +			ti,provided-clocks = <&atl_clkin0_ck>, <&atl_clkin1_ck>,
> +					     <&atl_clkin2_ck>, <&atl_clkin3_ck>;
> +			clocks = <&atl_gfclk_mux>;
> +			clock-names = "fck";
> +			status = "disabled";
> +		};
>   	};
>   };
>
> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> index 30160348934c..789e92cd5595 100644
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -10,26 +10,26 @@
>   &cm_core_aon_clocks {
>   	atl_clkin0_ck: atl_clkin0_ck {
>   		#clock-cells = <0>;
> -		compatible = "fixed-clock";
> -		clock-frequency = <0>;
> +		compatible = "ti,dra7-atl-clock";
> +		clocks = <&atl_gfclk_mux>;
>   	};
>
>   	atl_clkin1_ck: atl_clkin1_ck {
>   		#clock-cells = <0>;
> -		compatible = "fixed-clock";
> -		clock-frequency = <0>;
> +		compatible = "ti,dra7-atl-clock";
> +		clocks = <&atl_gfclk_mux>;
>   	};
>
>   	atl_clkin2_ck: atl_clkin2_ck {
>   		#clock-cells = <0>;
> -		compatible = "fixed-clock";
> -		clock-frequency = <0>;
> +		compatible = "ti,dra7-atl-clock";
> +		clocks = <&atl_gfclk_mux>;
>   	};
>
>   	atl_clkin3_ck: atl_clkin3_ck {
>   		#clock-cells = <0>;
> -		compatible = "fixed-clock";
> -		clock-frequency = <0>;
> +		compatible = "ti,dra7-atl-clock";
> +		clocks = <&atl_gfclk_mux>;
>   	};
>
>   	hdmi_clkin_ck: hdmi_clkin_ck {
>

