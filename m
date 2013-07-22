Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab3GVSey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:34:54 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51923 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab3GVSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:34:52 -0400
Message-ID: <51ED7B47.2090104@metafoo.de>
Date: Mon, 22 Jul 2013 20:34:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        fabio.estevam@freescale.com, marex@denx.de,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-3-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374501843-19651-3-git-send-email-hector.palacios@digi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 04:04 PM, Hector Palacios wrote:
> Some LRADC channels have fixed pre-dividers so they can measure
> different voltages at full scale. The reference voltage allows to
> expose a scaling attribute through the IIO sysfs so that a user can
> compute the real voltage out of a measured sample value.

I've said before that I'm not convinced that this is the right way to implement 
this. And considering what Thomas said here 
http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg36691.html I 
guess I'm not alone with that opinion.

- Lars

>
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> Acked-by: Marek Vasut <marex@denx.de>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>   Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt | 9 ++++++++-
>   arch/arm/boot/dts/imx23.dtsi                                    | 4 ++++
>   arch/arm/boot/dts/imx28.dtsi                                    | 4 ++++
>   3 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> index 4688205..6ec485c 100644
> --- a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> +++ b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
> @@ -1,9 +1,12 @@
>   * Freescale i.MX28 LRADC device driver
>
>   Required properties:
> -- compatible: Should be "fsl,imx28-lradc"
> +- compatible: "fsl,imx28-lradc", "fsl,imx23-lradc"
>   - reg: Address and length of the register set for the device
>   - interrupts: Should contain the LRADC interrupts
> +- fsl,vref: Reference voltage (in mV) for each LRADC channel. This is the
> +	    maximum voltage that can be measured at full scale in each channel
> +	    considering fixed pre-dividers.
>
>   Optional properties:
>   - fsl,lradc-touchscreen-wires: Number of wires used to connect the touchscreen
> @@ -18,4 +21,8 @@ Examples:
>   		reg = <0x80050000 0x2000>;
>   		interrupts = <10 14 15 16 17 18 19
>   				20 21 22 23 24 25>;
> +		fsl,vref = <1850 1850 1850 1850
> +			    1850 1850 1850 7400
> +			    1850 1850 3700 1850
> +			    3700 1850 1850 7400>
>   	};
> diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
> index 587ceef..e212902 100644
> --- a/arch/arm/boot/dts/imx23.dtsi
> +++ b/arch/arm/boot/dts/imx23.dtsi
> @@ -430,6 +430,10 @@
>   				compatible = "fsl,imx23-lradc";
>   				reg = <0x80050000 0x2000>;
>   				interrupts = <36 37 38 39 40 41 42 43 44>;
> +				fsl,vref = <1850 1850 1850 1850
> +					    1850 1850 3700 7400
> +					    1850 1850 1850 1850
> +					    1850 1850 1850 7400>;
>   				status = "disabled";
>   			};
>
> diff --git a/arch/arm/boot/dts/imx28.dtsi b/arch/arm/boot/dts/imx28.dtsi
> index 6a8acb0..c1b3724 100644
> --- a/arch/arm/boot/dts/imx28.dtsi
> +++ b/arch/arm/boot/dts/imx28.dtsi
> @@ -865,6 +865,10 @@
>   				reg = <0x80050000 0x2000>;
>   				interrupts = <10 14 15 16 17 18 19
>   						20 21 22 23 24 25>;
> +				fsl,vref = <1850 1850 1850 1850
> +					    1850 1850 1850 7400
> +					    1850 1850 3700 1850
> +					    3700 1850 1850 7400>;
>   				status = "disabled";
>   			};
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

