Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaJVO5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:57:04 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:42855 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaJVO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:57:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add TMU0 and TMU1 device nodes
Date: Wed, 22 Oct 2014 17:57:12 +0300
Message-ID: <1778362.3usrUlJmIK@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413970709-26607-3-git-send-email-geert+renesas@glider.be>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be> <1413970709-26607-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Thank you for the patch.

On Wednesday 22 October 2014 11:38:28 Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Simon has posted a very similar patch as "[PATCH v2 19/30] ARM: shmobile: 
r8a7740: Add TMU nodes", you might want to credit him.

Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

> ---
>  arch/arm/boot/dts/r8a7740.dtsi | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> index 559bd39e778bddaf..aec8da89ef9ac766 100644
> --- a/arch/arm/boot/dts/r8a7740.dtsi
> +++ b/arch/arm/boot/dts/r8a7740.dtsi
> @@ -335,6 +335,34 @@
>  		status = "disabled";
>  	};
> 
> +	tmu0: timer@fff80000 {
> +		compatible = "renesas,tmu-r8a7740", "renesas,tmu";
> +		reg = <0xfff80000 0x2c>;
> +		interrupts = <0 198 IRQ_TYPE_LEVEL_HIGH>,
> +			     <0 199 IRQ_TYPE_LEVEL_HIGH>,
> +			     <0 200 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp1_clks R8A7740_CLK_TMU0>;
> +		clock-names = "fck";
> +
> +		#renesas,channels = <3>;
> +
> +		status = "disabled";
> +	};
> +
> +	tmu1: timer@fff90000 {
> +		compatible = "renesas,tmu-r8a7740", "renesas,tmu";
> +		reg = <0xfff90000 0x2c>;
> +		interrupts = <0 170 IRQ_TYPE_LEVEL_HIGH>,
> +			     <0 171 IRQ_TYPE_LEVEL_HIGH>,
> +			     <0 172 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp1_clks R8A7740_CLK_TMU1>;
> +		clock-names = "fck";
> +
> +		#renesas,channels = <3>;
> +
> +		status = "disabled";
> +	};
> +
>  	clocks {
>  		#address-cells = <1>;
>  		#size-cells = <1>;

-- 
Regards,

Laurent Pinchart

