Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbaEDLjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 07:39:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31538 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaEDLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 07:39:42 -0400
Message-ID: <53662673.7000709@hisilicon.com>
Date: Sun, 4 May 2014 19:37:23 +0800
From: Zhou Wang <wangzhou1@hisilicon.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <haojian.zhuang@linaro.org>, <xuwei5@hisilicon.com>
Subject: Re: [PATCH 2/2] ARM: dts: hip04: add gpio pieces
References: <5357A947.2010506@hisilicon.com>
In-Reply-To: <5357A947.2010506@hisilicon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.65.131]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/23 19:51, Zhou Wang wrote:
> Hisilicon Soc hip04 has four gpio controllers, each one has 32
> gpios and can be configured to be an interrupt controller.
> The gpio controllers are compatible with the snps,dw-apb-gpio
> driver. This patch add the corresponding device tree nodes.
> 
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>  arch/arm/boot/dts/hip04.dtsi |   76 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/hip04.dtsi b/arch/arm/boot/dts/hip04.dtsi
> index 7e909ee..c7c1f8c 100644
> --- a/arch/arm/boot/dts/hip04.dtsi
> +++ b/arch/arm/boot/dts/hip04.dtsi
> @@ -235,5 +235,81 @@
>  			reg-shift = <2>;
>  			status = "disabled";
>  		};
> +
> +		gpio@4003000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "snps,dw-apb-gpio";
> +			reg = <0x4003000 0x1000>;
> +
> +			gpio3: gpio-controller@0 {
> +				compatible = "snps,dw-apb-gpio-port";
> +				gpio-controller;
> +				#gpio-cells = <2>;
> +				snps,nr-gpios = <32>;
> +				reg = <0>;
> +				interrupt-parent = <&gic>;
> +				interrupt-controller;
> +				#interrupt-cells = <2>;
> +				interrupts = <0 392 4>;
> +			};
> +		};
> +
> +		gpio@4002000 {
> + 			#address-cells = <1>;
> + 			#size-cells = <0>;
> + 			compatible = "snps,dw-apb-gpio";
> + 			reg = <0x4002000 0x1000>;
> +
> + 			gpio2: gpio-controller@0 {
> + 				compatible = "snps,dw-apb-gpio-port";
> + 				gpio-controller;
> + 				#gpio-cells = <2>;
> + 				snps,nr-gpios = <32>;
> + 				reg = <0>;
> +				interrupt-parent = <&gic>;
> + 				interrupt-controller;
> + 				#interrupt-cells = <2>;
> + 				interrupts = <0 391 4>;
> + 			};
> + 		};
> +
> +		gpio@4001000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "snps,dw-apb-gpio";
> +			reg = <0x4001000 0x1000>;
> +
> +			gpio1: gpio-controller@0 {
> +				compatible = "snps,dw-apb-gpio-port";
> +				gpio-controller;
> +				#gpio-cells = <2>;
> +				snps,nr-gpios = <32>;
> +				reg = <0>;
> +				interrupt-parent = <&gic>;
> +				interrupt-controller;
> +				#interrupt-cells = <2>;
> +				interrupts = <0 390 4>;
> +			};
> +		};
> +
> +		gpio@4000000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "snps,dw-apb-gpio";
> +			reg = <0x4000000 0x1000>;
> +
> +			gpio0: gpio-controller@0 {
> +				compatible = "snps,dw-apb-gpio-port";
> +				gpio-controller;
> +				#gpio-cells = <2>;
> +				snps,nr-gpios = <32>;
> +				reg = <0>;
> +				interrupt-parent = <&gic>;
> +				interrupt-controller;
> +				#interrupt-cells = <2>;
> +				interrupts = <0 389 4>;
> +			};
> +		};
>  	};
>  };
> -- 1.7.9.5
> 
Hi haojian

 Are the gpio nodes OK for hip04.dtsi?

Best regards
Zhou Wang

