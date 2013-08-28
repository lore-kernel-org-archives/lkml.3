Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3H1RyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:54:25 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:51758 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab3H1RyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:54:22 -0400
Message-ID: <521E394C.3040402@cogentembedded.com>
Date: Wed, 28 Aug 2013 21:54:20 +0400
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
Subject: Re: [PATCH v3 3/3] ARM: dts: dra7-evm: Add extcon nodes for USB ID
 pin detection
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1377711185-31238-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:33 PM, George Cherian wrote:

> Add
> 	-extcon nodes for USB ID pin detection.
> 	-i2c nodes.
> 	-pcf nodes to which USB ID pin is connected.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   arch/arm/boot/dts/dra7-evm.dts | 50 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 49 insertions(+), 1 deletion(-)

> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
> index acd3c09..8b0738a 100644
> --- a/arch/arm/boot/dts/dra7-evm.dts
> +++ b/arch/arm/boot/dts/dra7-evm.dts
[...]
> @@ -33,10 +44,47 @@
>           };
>   };
>
> +&i2c1 {
> +	clock-frequency = <400000>;
> +
> +	gpio20: pcf8575@20 {

     ePAPR was talking about the node naming, not about labelling. Back to the 
drawing board. ;-)

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
> +	gpio21: pcf8575@21 {
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

WBR, Sergei

