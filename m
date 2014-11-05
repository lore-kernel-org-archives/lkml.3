Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaKEPfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:35:00 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43392 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaKEPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:34:58 -0500
Message-ID: <545A439F.6080404@kernel.org>
Date: Wed, 05 Nov 2014 15:34:55 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: Re: [PATCH v2 2/3] Documentation: dt-bindings: update exynos-adc.txt
 with syscon handle
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com> <1410857931-4980-3-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1410857931-4980-3-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/14 09:58, Naveen Krishna Chatradhi wrote:
> This patch updates the DT bindings for ADC in exynos-adc.txt with the
> syscon phandle to the ADC nodes.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> To: devicetree@vger.kernel.org
Applied to the togreg branch of iio.git - initially pushed out as testing.

Thanks,
> ---
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 709efaa..c368210 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -43,13 +43,16 @@ Required properties:
>  				   compatible ADC block)
>  - vdd-supply		VDD input supply.
>  
> +- samsung,syscon-phandle Contains the PMU system controller node
> +			(To access the ADC_PHY register on Exynos5250/5420/5800/3250)
> +
>  Note: child nodes can be added for auto probing from device tree.
>  
>  Example: adding device info in dtsi file
>  
>  adc: adc@12D10000 {
>  	compatible = "samsung,exynos-adc-v1";
> -	reg = <0x12D10000 0x100>, <0x10040718 0x4>;
> +	reg = <0x12D10000 0x100>;
>  	interrupts = <0 106 0>;
>  	#io-channel-cells = <1>;
>  	io-channel-ranges;
> @@ -58,13 +61,14 @@ adc: adc@12D10000 {
>  	clock-names = "adc";
>  
>  	vdd-supply = <&buck5_reg>;
> +	samsung,syscon-phandle = <&pmu_system_controller>;
>  };
>  
>  Example: adding device info in dtsi file for Exynos3250 with additional sclk
>  
>  adc: adc@126C0000 {
>  	compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2;
> -	reg = <0x126C0000 0x100>, <0x10020718 0x4>;
> +	reg = <0x126C0000 0x100>;
>  	interrupts = <0 137 0>;
>  	#io-channel-cells = <1>;
>  	io-channel-ranges;
> @@ -73,6 +77,7 @@ adc: adc@126C0000 {
>  	clock-names = "adc", "sclk";
>  
>  	vdd-supply = <&buck5_reg>;
> +	samsung,syscon-phandle = <&pmu_system_controller>;
>  };
>  
>  Example: Adding child nodes in dts file
> 
