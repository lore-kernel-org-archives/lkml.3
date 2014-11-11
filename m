Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaKKVMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:12:37 -0500
Received: from mail2.kmu-office.ch ([178.209.48.109]:49156 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKVMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:12:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Nov 2014 22:13:44 +0100
From: Stefan Agner <stefan@agner.ch>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: rtc-linux@googlegroups.com, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [[PATCHv2] 1/3] ARM: imx: clk-vf610: Add clock for SNVS
In-Reply-To: <bbe86ff8ff7461451be5c53242842e966bfd3966.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
 <bbe86ff8ff7461451be5c53242842e966bfd3966.1415364391.git.maitysanchayan@gmail.com>
Message-ID: <9a79e6b3c1c62037cef31baa432fd874@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Nov 11 22:12:33 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 54627bc112812836511337
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-07 14:04, Sanchayan Maity wrote:
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
> @@ -379,6 +379,7 @@ static void __init vf610_clocks_init(struct
> device_node *ccm_node)
>  	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus",
> CCM_CCGR0, CCM_CCGRx_CGn(5));
>  	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus",
> CCM_CCGR6, CCM_CCGRx_CGn(1));
>  	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus",
> CCM_CCGR6, CCM_CCGRx_CGn(2));
> +	clk[VF610_CLK_SNVS] = imx_clk_gate2("snvs-rtc", "ipg_bus",
> CCM_CCGR6, CCM_CCGRx_CGn(7));

Just noticed that imx_clk_gate2 always sets both gates. This means, the
RTC will be gated when going into low power modes. We might need to use
a different gating when we want to use the RTC as wakeup source. But
this would be part of the suspend/resume patchset...

>  
>  	imx_check_clocks(clk, ARRAY_SIZE(clk));
>  
> diff --git a/include/dt-bindings/clock/vf610-clock.h
> b/include/dt-bindings/clock/vf610-clock.h
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

Acked-By: Stefan Agner <stefan@agner.ch>

--
Stefan

