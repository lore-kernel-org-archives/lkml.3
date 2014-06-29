Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaF2Lfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 07:35:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:53380 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbaF2Lfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 07:35:38 -0400
Message-ID: <53AFFA86.6000403@kernel.org>
Date: Sun, 29 Jun 2014 12:37:42 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, ch.naveen@samsung.com,
        t.figa@samsung.com, kgene.kim@samsung.com
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv5 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com> <1403843406-28229-4-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1403843406-28229-4-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/06/14 05:30, Chanwoo Choi wrote:
> This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
> special clock ('sclk_adc') for ADC which provide clock to internal ADC.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
One trivial inline.  As a fairly obvious extension of the existing bindings
'probably' doesn't really need a dt maintainer ack (or the 3 weeks)
> ---
>   .../devicetree/bindings/arm/samsung/exynos-adc.txt | 26 ++++++++++++++++++++--
>   1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 5d49f2b..b87749a 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -14,14 +14,22 @@ Required properties:
>   				for exynos4412/5250 controllers.
>   			Must be "samsung,exynos-adc-v2" for
>   				future controllers.
> +			Must be "samsung,exynos3250-adc-v2" for
> +				for controllers compatible with ADC of
for for
> +				Exynos3250.
>   - reg:			Contains ADC register address range (base address and
>   			length) and the address of the phy enable register.
>   - interrupts: 		Contains the interrupt information for the timer. The
>   			format is being dependent on which interrupt controller
>   			the Samsung device uses.
>   - #io-channel-cells = <1>; As ADC has multiple outputs
> -- clocks		From common clock binding: handle to adc clock.
> -- clock-names		From common clock binding: Shall be "adc".
> +- clocks		From common clock bindings: handles to clocks specified
> +			in "clock-names" property, in the same order.
> +- clock-names		From common clock bindings: list of clock input names
> +			used by ADC block:
> +			- "adc" : ADC bus clock
> +			- "sclk_adc" : ADC special clock (only for Exynos3250
> +				       and compatible ADC block)
>   - vdd-supply		VDD input supply.
>
>   Note: child nodes can be added for auto probing from device tree.
> @@ -41,6 +49,20 @@ adc: adc@12D10000 {
>   	vdd-supply = <&buck5_reg>;
>   };
>
> +Example: adding device info in dtsi file for Exynos3250 with additional sclk
> +
> +adc: adc@126C0000 {
> +	compatible = "samsung,exynos3250-adc-v2";
> +	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
> +	interrupts = <0 137 0>;
> +	#io-channel-cells = <1>;
> +	io-channel-ranges;
> +
> +	clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
> +	clock-names = "adc", "sclk_adc";
> +
> +	vdd-supply = <&buck5_reg>;
> +};
>
>   Example: Adding child nodes in dts file
>
>

