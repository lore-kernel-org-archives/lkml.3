Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaKKVTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:19:01 -0500
Received: from mail2.kmu-office.ch ([178.209.48.109]:49185 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaKKVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:19:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2014 22:20:07 +0100
From: Stefan Agner <stefan@agner.ch>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: rtc-linux@googlegroups.com, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 2/3] ARM: dts: vfxxx: Add SNVS node
In-Reply-To: <64244b916de3864b714e829c3adeecec71aea2b3.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <64244b916de3864b714e829c3adeecec71aea2b3.1415364391.git.maitysanchayan@gmail.com>
Message-ID: <38daf99040ba00bd5150e7bc73a2fd76@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Nov 11 22:18:57 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 54627d4112811117587349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-07 14:04, Sanchayan Maity wrote:
> This patch adds a devicetree node for the Secure
> Non-Volatile Storage (SNVS) on the VF610 platform.
> The SNVS block also has a Real Time Counter (RTC).
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  arch/arm/boot/dts/vfxxx.dtsi |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
> index 4e70833..bc131b0 100644
> --- a/arch/arm/boot/dts/vfxxx.dtsi
> +++ b/arch/arm/boot/dts/vfxxx.dtsi
> @@ -338,6 +338,21 @@
>  				status = "disabled";
>  			};
>  
> +			snvs0: snvs@400a7000 {
> +				compatible = "fsl,sec-v4.0-mon", "simple-bus";
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				ranges = <0 0x400a7000 0x2000>;
> +
> +				snvs-rtc-lp@34 {
> +					compatible = "fsl,sec-v4.0-mon-rtc-lp";
> +					reg = <0x34 0x58>;
> +					interrupts = <0 100 IRQ_TYPE_LEVEL_HIGH>;

With the new device tree structure, the interrupt field needs to be part
of the vf500.dtsi now. The vfxxx.dtsi will be the parent also for the
Cortex-M4 device tree, which uses a different interrupt controller.

While at it, use the GIC_SPI macro for the first cell (so this will be
blend into the other interrupt definitions).

> +					clocks = <&clks VF610_CLK_SNVS>;
> +					clock-names = "snvs-rtc";
> +				};
> +			};
> +
>  			uart4: serial@400a9000 {
>  				compatible = "fsl,vf610-lpuart";
>  				reg = <0x400a9000 0x1000>;

