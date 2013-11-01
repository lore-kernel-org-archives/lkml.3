Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3KAQ6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:58:38 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:48106 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3KAQ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:58:36 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: Re: [PATCH v2 2/4] clk: exynos5410: register clocks using common clock framework
Date: Fri, 01 Nov 2013 17:58:34 +0100
Message-ID: <1421095.b3lQaz2kV9@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1381763305-7085-3-git-send-email-v.tyrtov@samsung.com>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com> <1381763305-7085-3-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 14 of October 2013 19:08:23 Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> The EXYNOS5410 clocks are statically listed and registered
> using the Samsung specific common clock helper functions.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  .../devicetree/bindings/clock/exynos5410-clock.txt |  37 +++
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos5410.c               | 251
> +++++++++++++++++++++ include/dt-bindings/clock/exynos5410.h           
>  | 175 ++++++++++++++ 4 files changed, 464 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/clock/exynos5410-clock.txt create
> mode 100644 drivers/clk/samsung/clk-exynos5410.c
>  create mode 100644 include/dt-bindings/clock/exynos5410.h

The driver looks pretty good now, thanks for addressing my comments to 
previous version. There are still few issues remaining, though. Please see 
my comments inline.

[snip]
> diff --git a/drivers/clk/samsung/clk-exynos5410.c
> b/drivers/clk/samsung/clk-exynos5410.c new file mode 100644
> index 0000000..c5eba08
> --- /dev/null
> +++ b/drivers/clk/samsung/clk-exynos5410.c
[snip]
> +static struct of_device_id ext_clk_match[] __initdata = {
> +	{ .compatible = "samsung,clock-oscclk", .data = (void *)0, },
> +	{ },
> +};

I don't see anything in binding documentation mentioning this compatible 
value. Anyway, since there is already a generic binding for fixed rate 
clocks, this shouldn't be needed at all.

> +
> +/* register exynos5410 clocks */
> +static void __init exynos5410_clk_init(struct device_node *np)
> +{
> +	void __iomem *reg_base;
> +
> +	reg_base = of_iomap(np, 0);
> +	if (!reg_base)
> +		panic("%s: failed to map registers\n", __func__);
> +
> +	samsung_clk_init(np, reg_base, CLK_NR_CLKS,
> +			exynos5410_clk_regs, 
ARRAY_SIZE(exynos5410_clk_regs),
> +			NULL, 0);
> +	samsung_clk_of_register_fixed_ext(exynos5410_frt_ext_clks,
> +			ARRAY_SIZE(exynos5410_frt_ext_clks),
> +			ext_clk_match);

This call could be dropped after moving to generic fixed rate clock 
bindings.

Best regards,
Tomasz

