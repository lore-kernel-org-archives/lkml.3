Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbaFSLRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:17:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58648 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbaFSLQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:16:58 -0400
Message-ID: <53A2C690.1060106@ti.com>
Date: Thu, 19 Jun 2014 14:16:32 +0300
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
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 10/18] ARM: dts: dra7xx-clocks: Add missing 32khz clocks
 used for PHY
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-11-git-send-email-kishon@ti.com>
In-Reply-To: <1401345500-20188-11-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 09:38 AM, Kishon Vijay Abraham I wrote:
> Added missing 32khz clock used by PCIe PHY.
> The documention for this node can be found @ ../bindings/clock/ti/gate.txt.

You can drop the node documentation ref, and rather add a TRM reference 
about hardware details. Other than that, looks good to me.

-Tero

>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/dra7xx-clocks.dtsi |    8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> index 44993ec..e1bd052 100644
> --- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
> @@ -1165,6 +1165,14 @@
>   		reg = <0x021c>, <0x0220>;
>   	};
>
> +	optfclk_pciephy_32khz: optfclk_pciephy_32khz@4a0093b0 {
> +		compatible = "ti,gate-clock";
> +		clocks = <&sys_32k_ck>;
> +		#clock-cells = <0>;
> +		reg = <0x13b0>;
> +		ti,bit-shift = <8>;
> +	};
> +
>   	optfclk_pciephy_div: optfclk_pciephy_div@4a00821c {
>   		compatible = "ti,divider-clock";
>   		clocks = <&apll_pcie_ck>;
>

