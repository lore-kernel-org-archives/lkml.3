Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657AbaD3McG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:32:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54659 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843AbaD3McD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:32:03 -0400
Message-ID: <5360ED2A.5070605@ti.com>
Date: Wed, 30 Apr 2014 15:31:38 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: DTS: omap54xx-clocks: Correct abe_iclk clock
 node
References: <1398858096-32144-1-git-send-email-peter.ujfalusi@ti.com> <1398858096-32144-2-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1398858096-32144-2-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 02:41 PM, Peter Ujfalusi wrote:
> abe_iclk's parent is aess_fclk and not abe_clk.
> Also correct the parameters for clock rate calculation as used for OMAP4
> since in PRCM level there's no difference between the two platform
> regarding to AESS/ABE clocking.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Tero Kristo <t-kristo@ti.com>

> ---
>   arch/arm/boot/dts/omap54xx-clocks.dtsi | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap54xx-clocks.dtsi b/arch/arm/boot/dts/omap54xx-clocks.dtsi
> index d784ff5d3904..86fc507a0567 100644
> --- a/arch/arm/boot/dts/omap54xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/omap54xx-clocks.dtsi
> @@ -143,10 +143,11 @@
>
>   	abe_iclk: abe_iclk {
>   		#clock-cells = <0>;
> -		compatible = "fixed-factor-clock";
> -		clocks = <&abe_clk>;
> -		clock-mult = <1>;
> -		clock-div = <2>;
> +		compatible = "ti,divider-clock";
> +		clocks = <&aess_fclk>;
> +		ti,bit-shift = <24>;
> +		reg = <0x0528>;
> +		ti,dividers = <2>, <1>;
>   	};
>
>   	abe_lp_clk_div: abe_lp_clk_div {
>

