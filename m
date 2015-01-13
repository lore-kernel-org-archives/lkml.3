Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbbAMTY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:24:59 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47022 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbAMTY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:24:56 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Andrzej Hajda <a.hajda@samsung.com>,
        "open list" <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1418226513-14105-8-git-send-email-a.hajda@samsung.com>
Cc: "Andrzej Hajda <a.hajda@samsung.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Russell King <linux@arm.linux.org.uk>,
	Linus Walleij <linus.walleij@linaro.org>, Alexandre Courbot
	<gnurou@gmail.com>, Thierry Reding <thierry.reding@gmail.com>, Inki Dae
	<inki.dae@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>, Liam
	Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Grant
	Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	moderated list:ARM/CLKDEV SUPPORT <linux-arm-kernel@lists.infradead.org>
	, open list:GPIO SUBSYSTEM <linux-gpio@vger.kernel.org>, open list:DRM
	PANEL DRIVERS <dri-devel@lists.freedesktop.org>, moderated list:ARM/S5P
	EXYNOS AR... <linux-samsung-soc@vger.kernel.org>, open list:OPEN
	FIRMWARE AND...",
        <devicetree@vger.kernel.org>, boris.brezillon@free-electrons.com,
        sboyd@codeaurora.org
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-8-git-send-email-a.hajda@samsung.com>
Message-ID: <20150113192449.20842.60390@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC 07/15] clk: add DT parsing function
Date: Tue, 13 Jan 2015 11:24:49 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Stephen Boyd

Quoting Andrzej Hajda (2014-12-10 07:48:25)
> The patch adds function for parsing Device Tree to get
> clock specifier. The function could be ultimately used
> by clock core.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
>  drivers/clk/clkdev.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index da4bda8..bd22750 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -120,6 +120,29 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
>         return clk;
>  }
>  EXPORT_SYMBOL(of_clk_get_by_name);
> +
> +static int of_get_clock_spec(struct device *dev, const char *name,
> +               struct of_phandle_args *spec)
> +{
> +       struct device_node *np = dev->of_node;
> +
> +       while (np) {
> +               int idx = 0;
> +
> +               if (name)
> +                       idx = of_property_match_string(np, "clock-names", name);
> +
> +               if (!of_parse_phandle_with_args(np, "clocks", "#clock-cells",
> +                                               idx, spec))
> +                       return 0;
> +
> +               np = np->parent;
> +               if (np && !of_get_property(np, "clock-ranges", NULL))
> +                       break;
> +       }
> +
> +       return -ENOENT;
> +}
>  #endif
>  
>  /*
> -- 
> 1.9.1
> 
