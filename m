Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaICSZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 14:25:36 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49821 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaICSZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 14:25:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Doug Anderson <dianders@chromium.org>, "Heiko Stuebner" <heiko@sntech.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1408726169-25515-1-git-send-email-dianders@chromium.org>
Cc: "Addy Ke" <addy.ke@rock-chips.com>, "Eddie Cai" <eddie.cai@rock-chips.com>,
        "Sonny Rao" <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        "Doug Anderson" <dianders@chromium.org>, linux-kernel@vger.kernel.org
References: <1408726169-25515-1-git-send-email-dianders@chromium.org>
Message-ID: <20140903182518.11368.99877@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: rockchip: Fix the clocks for i2c1 and i2c2
Date: Wed, 03 Sep 2014 11:25:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Doug Anderson (2014-08-22 09:49:29)
> The clocks for i2c1 and i2c2 are flipped.  The clock tree matched the
> Technical Reference Manual (TRM) but the TRM was wrong.  Swap them in
> the clock tree.  This was determined experimentally (by Addy) and
> confirmed by the Rockchip IC team.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reported-by: Addy Ke <addy.ke@rock-chips.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>

Applied to clk-fixes.

Regards,
Mike

> ---
> Changes in v2:
> - Fixed typo in commit message.
> 
>  drivers/clk/rockchip/clk-rk3288.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index 0d8c6c5..b22a2d2 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -545,7 +545,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>         GATE(PCLK_PWM, "pclk_pwm", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 0, GFLAGS),
>         GATE(PCLK_TIMER, "pclk_timer", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 1, GFLAGS),
>         GATE(PCLK_I2C0, "pclk_i2c0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 2, GFLAGS),
> -       GATE(PCLK_I2C1, "pclk_i2c1", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 3, GFLAGS),
> +       GATE(PCLK_I2C2, "pclk_i2c2", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 3, GFLAGS),
>         GATE(0, "pclk_ddrupctl0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 14, GFLAGS),
>         GATE(0, "pclk_publ0", "pclk_cpu", 0, RK3288_CLKGATE_CON(10), 15, GFLAGS),
>         GATE(0, "pclk_ddrupctl1", "pclk_cpu", 0, RK3288_CLKGATE_CON(11), 0, GFLAGS),
> @@ -603,7 +603,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>         GATE(PCLK_I2C4, "pclk_i2c4", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 15, GFLAGS),
>         GATE(PCLK_UART3, "pclk_uart3", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 11, GFLAGS),
>         GATE(PCLK_UART4, "pclk_uart4", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 12, GFLAGS),
> -       GATE(PCLK_I2C2, "pclk_i2c2", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 13, GFLAGS),
> +       GATE(PCLK_I2C1, "pclk_i2c1", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 13, GFLAGS),
>         GATE(PCLK_I2C3, "pclk_i2c3", "pclk_peri", 0, RK3288_CLKGATE_CON(6), 14, GFLAGS),
>         GATE(PCLK_SARADC, "pclk_saradc", "pclk_peri", 0, RK3288_CLKGATE_CON(7), 1, GFLAGS),
>         GATE(PCLK_TSADC, "pclk_tsadc", "pclk_peri", 0, RK3288_CLKGATE_CON(7), 2, GFLAGS),
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
