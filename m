Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3IOXRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 19:17:16 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41415 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3IOXRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 19:17:14 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] arm: zynq: Enable arm_global_timer
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
In-Reply-To: <1379004640-15117-3-git-send-email-soren.brinkmann@xilinx.com>
References: <1379004640-15117-1-git-send-email-soren.brinkmann@xilinx.com> <1379004640-15117-3-git-send-email-soren.brinkmann@xilinx.com>
Date: Sun, 15 Sep 2013 13:40:36 +0100
Message-Id: <20130915124036.A66A8C42C3C@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013 09:50:40 -0700, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> Zynq is based on an ARM Cortex-A9 MPCore, which features the
> arm_global_timer in its SCU. Therefore enable the timer for Zynq.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++++++
>  arch/arm/mach-zynq/Kconfig       | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index e32b92b..eaacb39 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -92,6 +92,14 @@
>  			};
>  		};
>  
> +		global_timer: global_timer@f8f00200 {

Nit: node names and property names use '-' not '_'. Plus the generic
names principle suggests the node should be names 'timer' not
'global_timer'. The following would be fine:

		global_timer: timer@f8f00200 {

(There's a distinction between node names and labels. '_' is fine in
labels since it doesn't get output into the compiled .dtb.

g.

> +			compatible = "arm,cortex-a9-global-timer";
> +			reg = <0xf8f00200 0x20>;
> +			interrupts = <1 11 0x301>;
> +			interrupt-parent = <&intc>;
> +			clocks = <&clkc 4>;
> +		};
> +
>  		ttc0: ttc0@f8001000 {
>  			interrupt-parent = <&intc>;
>  			interrupts = < 0 10 4 0 11 4 0 12 4 >;
> diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
> index 04f8a4a..6b04260 100644
> --- a/arch/arm/mach-zynq/Kconfig
> +++ b/arch/arm/mach-zynq/Kconfig
> @@ -13,5 +13,6 @@ config ARCH_ZYNQ
>  	select HAVE_SMP
>  	select SPARSE_IRQ
>  	select CADENCE_TTC_TIMER
> +	select ARM_GLOBAL_TIMER
>  	help
>  	  Support for Xilinx Zynq ARM Cortex A9 Platform
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

