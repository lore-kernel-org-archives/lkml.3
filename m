Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaCMKf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:35:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35716 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbaCMKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:35:24 -0400
Message-ID: <532189DB.9080807@ti.com>
Date: Thu, 13 Mar 2014 12:35:07 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <anatol.pomozov@gmail.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH v3 2/5] ARM: dts: am43xx clock data
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com> <1394193422-18242-3-git-send-email-george.cherian@ti.com>
In-Reply-To: <1394193422-18242-3-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On 03/07/2014 01:56 PM, George Cherian wrote:
> Add USB reference clock data
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  arch/arm/boot/dts/am43xx-clocks.dtsi | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/am43xx-clocks.dtsi b/arch/arm/boot/dts/am43xx-clocks.dtsi
> index 142009c..506d036 100644
> --- a/arch/arm/boot/dts/am43xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
> @@ -653,4 +653,21 @@
>  		clocks = <&clk_32768_ck>, <&clk_32k_tpm_ck>;
>  		reg = <0x4260>;
>  	};
> +
> +	usb_otg_ss0_refclk960m: usb_otg_ss0_refclk960m {
> +		#clock-cells = <0>;
> +	        compatible = "ti,gate-clock";
> +		clocks = <&dpll_per_clkdcoldo>;
> +	        ti,bit-shift = <8>;
> +	        reg = <0x8a60>;
> +	};
> +
> +	usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
> +		#clock-cells = <0>;
> +	        compatible = "ti,gate-clock";
> +		clocks = <&dpll_per_clkdcoldo>;
> +	        ti,bit-shift = <8>;
> +		reg = <0x8a68>;
> +	};
> +
>  };
> 

I was reviewing am43xx usb clock information recently and found out that
PHY clock is missing here. e.g. usb_phy0_always_on_clk32k and usb_phy1_always_on_clk32k.

Can you please add these clocks?

cheers,
-roger
