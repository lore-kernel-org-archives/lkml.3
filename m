Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3JIQ42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 12:56:28 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38842 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3JIQ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 12:56:26 -0400
MIME-Version: 1.0
In-Reply-To: <1381328067-1593-5-git-send-email-treding@nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
	<1381328067-1593-5-git-send-email-treding@nvidia.com>
Date: Wed, 9 Oct 2013 13:56:25 -0300
Message-ID: <CAOMZO5CVZHNWcash5cb4MiMCU0K2R+X4Jio3vpaMA4VwE81QkQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the imx-mxs tree
From: Fabio Estevam <festevam@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Wed, Oct 9, 2013 at 11:14 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> Today's linux-next merge of the imx-mxs tree got conflicts in
>
>         arch/arm/mach-imx/clk-imx51-imx53.c
>         arch/arm/mach-imx/mach-imx6q.c
>
> caused by commits 0efe995 (ARM: mach-imx: clk-imx51-imx53: Retrieve base
> address and irq from dt), d2b36f6 (ARM: imx: replace imx6q_restart()
> with mxc_restart()) and 4d9d18a (ARM: imx: remove custom .init_time
> hook).
>
> I fixed them up (see below). Please verify that the resolution looks
> good.
...

>  +static void __init mx53_clocks_init(struct device_node *np)
>   {
> -       int i;
> +       int i, irq;
>         unsigned long r;
>  -      struct device_node *np;
> +       void __iomem *base;
>
>         clk[pll1_sw] = imx_clk_pllv2("pll1_sw", "osc", MX53_DPLL1_BASE);
>         clk[pll2_sw] = imx_clk_pllv2("pll2_sw", "osc", MX53_DPLL2_BASE);
> @@@ -568,5 -567,22 +569,13 @@@
>
>         r = clk_round_rate(clk[usboh3_per_gate], 54000000);
>         clk_set_rate(clk[usboh3_per_gate], r);
> +
> +       np = of_find_compatible_node(NULL, NULL, "fsl,imx53-gpt");
> +       base = of_iomap(np, 0);
> +       WARN_ON(!base);
> +       irq = irq_of_parse_and_map(np, 0);
> +       mxc_timer_init(base, irq);
> +
> +       return 0;

This 'return 0' should be removed as the  function now changed to void.

I have sent a patch fixing it.

Regards,

Fabio Estevam
