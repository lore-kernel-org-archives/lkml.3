Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab3GLO4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 10:56:24 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50513 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab3GLO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 10:56:23 -0400
Message-ID: <51E01914.50704@cogentembedded.com>
Date: Fri, 12 Jul 2013 18:56:20 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH 8/8] ARM: shmobile: r8a7740: add DT nodes and clock aliases
 for three DMAC instances
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de> <1373636638-18496-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1373636638-18496-9-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/12/2013 05:43 PM, Guennadi Liakhovetski wrote:

> This patch adds Device Tree support for the three generic DMA controller
> instances on r8a7740 in a DMA multiplexer node.

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> ---
>   arch/arm/boot/dts/r8a7740.dtsi         |   61 ++++++++++++++++++++++++++++++++
>   arch/arm/mach-shmobile/clock-r8a7740.c |    3 ++
>   2 files changed, 64 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> index 25dc930..39b596f 100644
> --- a/arch/arm/boot/dts/r8a7740.dtsi
> +++ b/arch/arm/boot/dts/r8a7740.dtsi
> @@ -112,6 +112,67 @@
>   			      0 149 0x4>;
>   	};
>
> +	dmac: dma-mux0 {
> +		compatible = "renesas,shdma-mux";
> +		#dma-cells = <1>;
> +		dma-channels = <6>;
> +		dma-requests = <256>;
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		dma0: shdma@fe008020 {
> +			compatible = "renesas,shdma-r8a7740";
> +			reg = <0xfe008020 0x270>,
> +				<0xfe009000 0xc>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <0 34 4
> +					0 28 4
> +					0 29 4
> +					0 30 4
> +					0 31 4
> +					0 32 4
> +					0 33 4>;
> +			interrupt-names = "error",
> +					"ch0", "ch1", "ch2", "ch3",
> +					"ch4", "ch5";
> +		};
> +
> +		dma1: shdma@fe018020 {
> +			compatible = "renesas,shdma-r8a7740";
> +			reg = <0xfe018020 0x270>,
> +				<0xfe019000 0xc>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <0 41 4
> +					0 35 4
> +					0 36 4
> +					0 37 4
> +					0 38 4
> +					0 39 4
> +					0 40 4>;
> +			interrupt-names = "error",
> +					"ch0", "ch1", "ch2", "ch3",
> +					"ch4", "ch5";
> +		};
> +
> +		dma2: shdma@fe028020 {
> +			compatible = "renesas,shdma-r8a7740";
> +			reg = <0xfe028020 0x270>,
> +				<0xfe029000 0xc>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <0 48 4
> +					0 42 4
> +					0 43 4
> +					0 44 4
> +					0 45 4
> +					0 46 4
> +					0 47 4>;
> +			interrupt-names = "error",
> +					"ch0", "ch1", "ch2", "ch3",
> +					"ch4", "ch5";
> +		};
> +	};
> +

    According to ePAPR [1] section 2.2.2, "the name of the node should 
be somewhat generic, reflecting the function of the device and not its
precise programming model. If appropriate, the name should be one of the 
following choices:
[...]
- dma-controller;
[...]"

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf
  	
WBR, Sergei

