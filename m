Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbbA1U5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:57:06 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:34865 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbbA1U5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:57:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Jan 2015 10:08:38 +0100
From: Stefan Agner <stefan@agner.ch>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Cc: mark.rutland@arm.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, broonie@kernel.org,
        B44548@freescale.com, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH 1/7] ARM: vf610: add second DSPI instance
In-Reply-To: <1422356244-15629-2-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
 <1422356244-15629-2-git-send-email-bhuvanchandra.dv@toradex.com>
Message-ID: <8e7c50f79165374935f42c15aeff42a8@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-27 11:57, Bhuvanchandra DV wrote:
> Acked-by: Stefan Agner <stefan@agner.ch>
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf500.dtsi |  4 ++++
>  arch/arm/boot/dts/vfxxx.dtsi | 11 +++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
> index 1dbf8d2..f5f807c 100644
> --- a/arch/arm/boot/dts/vf500.dtsi
> +++ b/arch/arm/boot/dts/vf500.dtsi
> @@ -66,6 +66,10 @@
>  	interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
>  };
>  
> +&dspi1 {
> +	interrupts = <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>;
> +};
> +
>  &edma0 {
>  	interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
>  			<GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
> diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
> index a29c7ce..789744b 100644
> --- a/arch/arm/boot/dts/vfxxx.dtsi
> +++ b/arch/arm/boot/dts/vfxxx.dtsi
> @@ -139,6 +139,17 @@
>  				status = "disabled";
>  			};
>  
> +			dspi1: dspi1@4002d000 {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +				compatible = "fsl,vf610-dspi";
> +				reg = <0x4002d000 0x1000>;
> +				clocks = <&clks VF610_CLK_DSPI1>;
> +				clock-names = "dspi";
> +				spi-num-chipselects = <5>;
> +				status = "disabled";
> +			};
> +
>  			sai2: sai@40031000 {
>  				compatible = "fsl,vf610-sai";
>  				reg = <0x40031000 0x1000>;


Acked-by: Stefan Agner <stefan@agner.ch>

Shawn, this will conflict with the pending MSCM driver patchset. I
probably have to resend the MSCM patchset anyway, also, the fix would be
trivial anyway.

--
Stefan
