Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbaFSLVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:21:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43043 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444AbaFSLVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:21:05 -0400
Message-ID: <53A2C787.5060905@ti.com>
Date: Thu, 19 Jun 2014 14:20:39 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        Rajendra Nayak <rnayak@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH v2 13/18] ARM: dts: dra7xx-clocks: Add missing clocks
 for second PCIe PHY instance
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-14-git-send-email-kishon@ti.com>
In-Reply-To: <1401345500-20188-14-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 09:38 AM, Kishon Vijay Abraham I wrote:
> Added missing clocks used by second instance of PCIe PHY.
> The documention for this nodes can be found @ ../bindings/clock/ti/gate.txt.

Drop the ref to the binding doc and rather add a ref to TRM about the 
clock layout. Also, is the register offset wrong on these? Should be 
0x13b8, no, or is my TRM version wrong?

-Tero

>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/dra7xx-clocks.dtsi |   24 ++++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> index 3d8c9c2..a9ff0dc 100644
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -1173,6 +1173,14 @@
>   		ti,bit-shift = <8>;
>   	};
>
> +	optfclk_pciephy2_32khz: optfclk_pciephy_32khz@4a0093b4 {
> +		compatible = "ti,gate-clock";
> +		clocks = <&sys_32k_ck>;
> +		#clock-cells = <0>;
> +		reg = <0x13b4>;
> +		ti,bit-shift = <8>;
> +	};
> +
>   	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
>   		compatible = "ti,divider-clock";
>   		clocks = <&apll_pcie_ck>;
> @@ -1191,6 +1199,14 @@
>   		ti,bit-shift = <9>;
>   	};
>
> +	optfclk_pciephy2_clk: optfclk_pciephy_clk@4a0093b4 {
> +		compatible = "ti,gate-clock";
> +		clocks = <&apll_pcie_ck>;
> +		#clock-cells = <0>;
> +		reg = <0x13b4>;
> +		ti,bit-shift = <9>;
> +	};
> +
>   	optfclk_pciephy1_div_clk: optfclk_pciephy_div_clk@4a0093b0 {
>   		compatible = "ti,gate-clock";
>   		clocks = <&optfclk_pciephy_div>;
> @@ -1199,6 +1215,14 @@
>   		ti,bit-shift = <10>;
>   	};
>
> +	optfclk_pciephy2_div_clk: optfclk_pciephy_div_clk@4a0093b4 {
> +		compatible = "ti,gate-clock";
> +		clocks = <&optfclk_pciephy_div>;
> +		#clock-cells = <0>;
> +		reg = <0x13b4>;
> +		ti,bit-shift = <10>;
> +	};
> +
>   	apll_pcie_clkvcoldo: apll_pcie_clkvcoldo {
>   		#clock-cells = <0>;
>   		compatible = "fixed-factor-clock";
>

