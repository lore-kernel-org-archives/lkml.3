Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3H1Okn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:40:43 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52950 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3H1Okk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:40:40 -0400
Message-ID: <521E0BE6.3080607@cogentembedded.com>
Date: Wed, 28 Aug 2013 18:40:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: balbi@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        ian.campbell@citrix.com, swarren@wwwdotorg.org, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        bcousson@baylibre.com, davidb@codeaurora.org, arnd@arndb.de,
        swarren@nvidia.com, popcornmix@gmail.com
Subject: Re: [PATCH v2 3/3] ARM: dts: dra7-evm: Add extcon nodes for USB ID
 pin detection
References: <1377698352-27689-1-git-send-email-george.cherian@ti.com> <1377698352-27689-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1377698352-27689-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/28/2013 05:59 PM, George Cherian wrote:

> Add
> 	-extcon nodes for USB ID pin detection.
> 	-i2c nodes.
> 	-pcf nodes to which USB ID pin is connected.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   arch/arm/boot/dts/dra7-evm.dts | 52 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 51 insertions(+), 1 deletion(-)

> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> index acd3c09..9ee97c0 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
> @@ -17,6 +17,17 @@
>   		device_type = "memory";
>   		reg = <0x80000000 0x60000000>; /* 1536 MB */
>   	};
> +
> +	extcon1: gpio_usbvid_extcon1 {
> +		compatible = "ti,gpio-usb-id";
> +		gpios = <&pcf_21 1 0>;
> +	};
> +
> +	extcon2: gpio_usbvid_extcon2 {
> +		compatible = "ti,gpio-usb-id";
> +		gpios = <&pcf_21 2 0>;
> +	};
> +
>   };
>
>   &dra7_pmx_core {
> @@ -33,10 +44,49 @@
>           };
>   };
>
> +&i2c1 {
> +	clock-frequency = <400000>;
> +
> +	pcf_20: pcf8575@20 {

    Acorrding to the ePAPR spec [1], "the name of a node should be somewhat 
generic, reflecting the function of the device and not its precise 
programming model. If appropriate, the name should be one of the following 
choices:

[...]
- gpio
[...]"

> +		compatible = "ti,pcf8575";
> +		reg = <0x20>;
> +		n_latch = <0x4000>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-parent = <&gpio6>;
> +		interrupts = <11 2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +	};
> +
> +	pcf_21: pcf8575@21 {

    Same comment here.

> +		compatible = "ti,pcf8575";
> +		reg = <0x21>;
> +		n_latch = <0x1408>;
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		interrupt-parent = <&pcf_20>;
> +		interrupts = <14 2>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +	};
> +
> +};
> +

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

