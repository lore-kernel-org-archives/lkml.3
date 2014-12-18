Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaLRKbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:31:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45236 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaLRKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:31:51 -0500
Message-ID: <1418898675.4212.10.camel@pengutronix.de>
Subject: Re: [PATCH RFC v2 05/14] ARM: imx6q: clk: Add the video_27m clock
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, thierry.reding@gmail.com, shawn.guo@linaro.org,
        mturquette@linaro.org, airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 11:31:15 +0100
In-Reply-To: <1418886696-11636-6-git-send-email-Ying.Liu@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
	 <1418886696-11636-6-git-send-email-Ying.Liu@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 18.12.2014, 15:11 +0800 schrieb Liu Ying:
> This patch supports the video_27m clock which is a fixed factor
> clock of the pll3_pfd1_540m clock.
> 
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
> v1->v2:
>  * None.
> 
>  arch/arm/mach-imx/clk-imx6q.c             | 1 +
>  include/dt-bindings/clock/imx6qdl-clock.h | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
> index 4e79da7..9470df3 100644
> --- a/arch/arm/mach-imx/clk-imx6q.c
> +++ b/arch/arm/mach-imx/clk-imx6q.c
> @@ -246,6 +246,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	clk[IMX6QDL_CLK_PLL3_60M]  = imx_clk_fixed_factor("pll3_60m",  "pll3_usb_otg",   1, 8);
>  	clk[IMX6QDL_CLK_TWD]       = imx_clk_fixed_factor("twd",       "arm",            1, 2);
>  	clk[IMX6QDL_CLK_GPT_3M]    = imx_clk_fixed_factor("gpt_3m",    "osc",            1, 8);
> +	clk[IMX6QDL_CLK_VIDEO_27M] = imx_clk_fixed_factor("video_27m", "pll3_pfd1_540m", 1, 20);

The HDMI TX isfr clock input is sourced from video_27m, too, according
to Table 33-1 "HDMI clocks".
I think the parent of clk[IMX6QDL_CLK_HDMI_ISFR] should be changed from
"pll3_pfd1_540m" to "video_27m", then.

regards
Philipp

