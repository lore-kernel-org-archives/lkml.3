Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaKEPgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:36:12 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43413 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbaKEPfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:35:55 -0500
Message-ID: <545A43D8.6050202@kernel.org>
Date: Wed, 05 Nov 2014 15:35:52 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: Re: [PATCH v2 3/3] ARM: dts: exynos: Add sysreg phandle to ADC node
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com> <1410857931-4980-4-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1410857931-4980-4-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/14 09:58, Naveen Krishna Chatradhi wrote:
> Instead of using the ADC_PHY register base address, use sysreg phandle
> in ADC node to control ADC_PHY configuration register.
> 
> This patch adds syscon node for Exynos3250, Exynos4x12, Exynos5250,
> and Exynos5420, Exynos5800.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> To: linux-samsung-soc@vger.kernel.org
Applied to the togreg branch of iio.git - initially pushed out as testing.

As this is very closely tied with the driver changes I've applied it through
the IIO tree.  If it turns up in the samsung tree as well, we can let git
work it's magic to drop one of the copies!

Jonathan
> ---
>  arch/arm/boot/dts/exynos3250.dtsi |    3 ++-
>  arch/arm/boot/dts/exynos4x12.dtsi |    3 ++-
>  arch/arm/boot/dts/exynos5250.dtsi |    3 ++-
>  arch/arm/boot/dts/exynos5420.dtsi |    3 ++-
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
> index 1d52de6..b997a4c 100644
> --- a/arch/arm/boot/dts/exynos3250.dtsi
> +++ b/arch/arm/boot/dts/exynos3250.dtsi
> @@ -272,12 +272,13 @@
>  		adc: adc@126C0000 {
>  			compatible = "samsung,exynos3250-adc",
>  				     "samsung,exynos-adc-v2";
> -			reg = <0x126C0000 0x100>, <0x10020718 0x4>;
> +			reg = <0x126C0000 0x100>;
>  			interrupts = <0 137 0>;
>  			clock-names = "adc", "sclk";
>  			clocks = <&cmu CLK_TSADC>, <&cmu CLK_SCLK_TSADC>;
>  			#io-channel-cells = <1>;
>  			io-channel-ranges;
> +			samsung,syscon-phandle = <&pmu_system_controller>;
>  			status = "disabled";
>  		};
>  
> diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
> index 861bb91..9ee77d3 100644
> --- a/arch/arm/boot/dts/exynos4x12.dtsi
> +++ b/arch/arm/boot/dts/exynos4x12.dtsi
> @@ -108,13 +108,14 @@
>  
>  	adc: adc@126C0000 {
>  		compatible = "samsung,exynos-adc-v1";
> -		reg = <0x126C0000 0x100>, <0x10020718 0x4>;
> +		reg = <0x126C0000 0x100>;
>  		interrupt-parent = <&combiner>;
>  		interrupts = <10 3>;
>  		clocks = <&clock CLK_TSADC>;
>  		clock-names = "adc";
>  		#io-channel-cells = <1>;
>  		io-channel-ranges;
> +		samsung,syscon-phandle = <&pmu_system_controller>;
>  		status = "disabled";
>  	};
>  
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 492e1ef..108adc5 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -765,12 +765,13 @@
>  
>  	adc: adc@12D10000 {
>  		compatible = "samsung,exynos-adc-v1";
> -		reg = <0x12D10000 0x100>, <0x10040718 0x4>;
> +		reg = <0x12D10000 0x100>;
>  		interrupts = <0 106 0>;
>  		clocks = <&clock CLK_ADC>;
>  		clock-names = "adc";
>  		#io-channel-cells = <1>;
>  		io-channel-ranges;
> +		samsung,syscon-phandle = <&pmu_system_controller>;
>  		status = "disabled";
>  	};
>  
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index bfe056d..5fd587a 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -541,12 +541,13 @@
>  
>  	adc: adc@12D10000 {
>  		compatible = "samsung,exynos-adc-v2";
> -		reg = <0x12D10000 0x100>, <0x10040720 0x4>;
> +		reg = <0x12D10000 0x100>;
>  		interrupts = <0 106 0>;
>  		clocks = <&clock CLK_TSADC>;
>  		clock-names = "adc";
>  		#io-channel-cells = <1>;
>  		io-channel-ranges;
> +		samsung,syscon-phandle = <&pmu_system_controller>;
>  		status = "disabled";
>  	};
>  
> 
