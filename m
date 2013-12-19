Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3LSHzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:55:21 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:51323 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3LSHzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:55:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.5
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Stephen Boyd" <sboyd@codeaurora.org>,
        "Stephen Warren" <swarren@nvidia.com>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "James Hogan" <james.hogan@imgtec.com>,
        "Padmavathi Venna" <padma.v@samsung.com>,
        "Sachin Kamat" <sachin.kamat@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1387274199-470-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1387274199-470-1-git-send-email-k.kozlowski@samsung.com>
Message-ID: <20131219075510.18119.67210@quantum>
Subject: Re: [PATCH] clk: exynos: File scope reg_save array should depend on PM_SLEEP
Date: Wed, 18 Dec 2013 23:55:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Krzysztof Kozlowski (2013-12-17 01:56:39)
> Move reg_save[] into CONFIG_PM_SLEEP dependency block as it is used only
> by suspend and resume functions.
> 
> This fixes the warning on CONFIG_PM_SLEEP=n:
> drivers/clk/samsung/clk-exynos-audss.c:29:22: warning: ‘reg_save’ defined but not used [-Wunused-variable]
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/clk/samsung/clk-exynos-audss.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
> index 39b40aaede2b..68e515d093d8 100644
> --- a/drivers/clk/samsung/clk-exynos-audss.c
> +++ b/drivers/clk/samsung/clk-exynos-audss.c
> @@ -26,17 +26,17 @@ static struct clk_onecell_data clk_data;
>  #define ASS_CLK_DIV 0x4
>  #define ASS_CLK_GATE 0x8
>  
> +/* list of all parent clock list */
> +static const char *mout_audss_p[] = { "fin_pll", "fout_epll" };
> +static const char *mout_i2s_p[] = { "mout_audss", "cdclk0", "sclk_audio0" };
> +
> +#ifdef CONFIG_PM_SLEEP
>  static unsigned long reg_save[][2] = {
>         {ASS_CLK_SRC,  0},
>         {ASS_CLK_DIV,  0},
>         {ASS_CLK_GATE, 0},
>  };
>  
> -/* list of all parent clock list */
> -static const char *mout_audss_p[] = { "fin_pll", "fout_epll" };
> -static const char *mout_i2s_p[] = { "mout_audss", "cdclk0", "sclk_audio0" };
> -
> -#ifdef CONFIG_PM_SLEEP
>  static int exynos_audss_clk_suspend(void)
>  {
>         int i;
> -- 
> 1.7.9.5
> 
