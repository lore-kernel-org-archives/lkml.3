Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaKKOt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:49:26 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34866 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKKOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:49:25 -0500
Date: Tue, 11 Nov 2014 22:49:15 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: rtc-linux@googlegroups.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        stefan@agner.ch, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 1/3] ARM: imx: clk-vf610: Add clock for SNVS
Message-ID: <20141111144911.GH2704@dragon>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <bbe86ff8ff7461451be5c53242842e966bfd3966.1415364391.git.maitysanchayan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbe86ff8ff7461451be5c53242842e966bfd3966.1415364391.git.maitysanchayan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 06:34:26PM +0530, Sanchayan Maity wrote:
> This patch adds support for clock gating of
> the SNVS peripheral.
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> ---
>  arch/arm/mach-imx/clk-vf610.c           |    1 +
>  include/dt-bindings/clock/vf610-clock.h |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
> index 5937dde..bbf4785 100644
> --- a/arch/arm/mach-imx/clk-vf610.c
> +++ b/arch/arm/mach-imx/clk-vf610.c
> @@ -379,6 +379,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
>  	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
>  	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(1));
>  	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(2));
> +	clk[VF610_CLK_SNVS] = imx_clk_gate2("snvs-rtc", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(7));

Stefan,

Would you confirm this register bits is the gating for SNVS clock?  I
cannot find it in my Vybrid Reference Manual.

Shawn

>  
>  	imx_check_clocks(clk, ARRAY_SIZE(clk));
>  
> diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
> index 801c0ac..979d24a 100644
> --- a/include/dt-bindings/clock/vf610-clock.h
> +++ b/include/dt-bindings/clock/vf610-clock.h
> @@ -192,6 +192,7 @@
>  #define VF610_PLL5_BYPASS		179
>  #define VF610_PLL6_BYPASS		180
>  #define VF610_PLL7_BYPASS		181
> -#define VF610_CLK_END			182
> +#define VF610_CLK_SNVS			182
> +#define VF610_CLK_END			183
>  
>  #endif /* __DT_BINDINGS_CLOCK_VF610_H */
> -- 
> 1.7.9.5
> 
