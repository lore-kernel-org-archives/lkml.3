Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbbA1Ur6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:47:58 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38235 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbbA1Ury (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:54 -0500
Message-ID: <54C92847.7010204@kernel.org>
Date: Wed, 28 Jan 2015 18:19:51 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@linaro.org, B38611@freescale.com, maitysanchayan@gmail.com,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 3/3] ARM: dts: add property for maximum ADC clock frequencies
References: <1421769723-28677-1-git-send-email-stefan@agner.ch> <1421769723-28677-4-git-send-email-stefan@agner.ch>
In-Reply-To: <1421769723-28677-4-git-send-email-stefan@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 16:02, Stefan Agner wrote:
> The ADC clock frequency is limited depending on modes used. Add
> device tree property which allow to set the mode used and the
> maximum frequency ratings for the instance. These allows to
> set the ADC clock to a frequency which is within specification
> according to the actual mode used.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
This should have been sent to the devicetree list and maintainers
in the first place.  Now cc'd.
> ---
>  Documentation/devicetree/bindings/iio/adc/vf610-adc.txt | 9 +++++++++
>  arch/arm/boot/dts/vfxxx.dtsi                            | 4 ++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt b/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
> index 1a4a43d..3eb40e2 100644
> --- a/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
> +++ b/Documentation/devicetree/bindings/iio/adc/vf610-adc.txt
> @@ -11,6 +11,13 @@ Required properties:
>  - clock-names: Must contain "adc", matching entry in the clocks property.
>  - vref-supply: The regulator supply ADC reference voltage.
>  
> +Recommended properties:
> +- fsl,adck-max-frequency: Maximum frequencies according to datasheets operating
> +  requirements. Three values are required, depending on conversion mode:
> +  - Frequency in normal mode (ADLPC=0, ADHSC=0)
> +  - Frequency in high-speed mode (ADLPC=0, ADHSC=1)
> +  - Frequency in low-power mode (ADLPC=1, ADHSC=0)
> +
>  Example:
>  adc0: adc@4003b000 {
>  	compatible = "fsl,vf610-adc";
> @@ -18,5 +25,7 @@ adc0: adc@4003b000 {
>  	interrupts = <0 53 0x04>;
>  	clocks = <&clks VF610_CLK_ADC0>;
>  	clock-names = "adc";
> +	fsl,adck-max-frequency = <30000000>, <40000000>,
> +				<20000000>;
>  	vref-supply = <&reg_vcc_3v3_mcu>;
>  };
> diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
> index 505969a..7584e0a 100644
> --- a/arch/arm/boot/dts/vfxxx.dtsi
> +++ b/arch/arm/boot/dts/vfxxx.dtsi
> @@ -182,6 +182,8 @@
>  				clocks = <&clks VF610_CLK_ADC0>;
>  				clock-names = "adc";
>  				status = "disabled";
> +				fsl,adck-max-frequency = <30000000>, <40000000>,
> +							<20000000>;
>  			};
>  
>  			wdog@4003e000 {
> @@ -361,6 +363,8 @@
>  				clocks = <&clks VF610_CLK_ADC1>;
>  				clock-names = "adc";
>  				status = "disabled";
> +				fsl,adck-max-frequency = <30000000>, <40000000>,
> +							<20000000>;
>  			};
>  
>  			esdhc1: esdhc@400b2000 {
> 

