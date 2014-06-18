Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaFRGNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:13:15 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:58528 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbaFRGNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <1403058061-24271-4-git-send-email-cw00.choi@samsung.com>
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com> <1403058061-24271-4-git-send-email-cw00.choi@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Wed, 18 Jun 2014 11:42:51 +0530
Message-ID: <CAHfPSqBepO+73vLyJJox1fP=0-F5KSE3uyjh-HXYXkHRLpw0QA@mail.gmail.com>
Subject: Re: [PATCHv4 3/4] iio: devicetree: Add DT binding documentation for
 Exynos3250 ADC
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, My self <ch.naveen@samsung.com>, t.figa@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chanwoo,

On 18 June 2014 07:51, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch add DT binding documentation for Exynos3250 ADC IP. Exynos3250 has
> special clock ('sclk_tsadc') for ADC which provide clock to internal ADC.
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

Changes look good to me.
Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

> ---
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt   | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 5d49f2b..3a5af82 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -14,6 +14,8 @@ Required properties:
>                                 for exynos4412/5250 controllers.
>                         Must be "samsung,exynos-adc-v2" for
>                                 future controllers.
> +                       Must be "samsung,exynos3250-adc-v2" for
> +                               for exynos3250 controllers.
>  - reg:                 Contains ADC register address range (base address and
>                         length) and the address of the phy enable register.
>  - interrupts:          Contains the interrupt information for the timer. The
> @@ -21,7 +23,11 @@ Required properties:
>                         the Samsung device uses.
>  - #io-channel-cells = <1>; As ADC has multiple outputs
>  - clocks               From common clock binding: handle to adc clock.
> +                       From common clock binding: handle to sclk_tsadc clock
> +                       if using Exynos3250.
>  - clock-names          From common clock binding: Shall be "adc".
> +                       From common clock binding: Shall be "sclk_tsadc"
> +                       if using Exynos3250.
>  - vdd-supply           VDD input supply.
>
>  Note: child nodes can be added for auto probing from device tree.
> @@ -41,6 +47,20 @@ adc: adc@12D10000 {
>         vdd-supply = <&buck5_reg>;
>  };
>
> +Example: adding device info in dtsi file for Exynos3250 with additional sclk
> +
> +adc: adc@126C0000 {
> +       compatible = "samsung,exynos3250-adc-v2";
> +       reg = <0x126C0000 0x100>, <0x10020718 0x4>;
> +       interrupts = <0 137 0>;
> +       #io-channel-cells = <1>;
> +       io-channel-ranges;
> +
> +       clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
> +       clock-names = "adc", "sclk_adc";
> +
> +       vdd-supply = <&buck5_reg>;
> +};
>
>  Example: Adding child nodes in dts file
>
> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
