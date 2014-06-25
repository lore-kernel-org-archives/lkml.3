Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaFYOTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:19:24 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59755 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbaFYOTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:19:22 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-bf-53aada678fb6
Message-id: <1403705957.22107.22.camel@AMDC1943>
Subject: Re: [PATCH v3 05/14] clk: Add generic driver for Maxim PMIC clocks
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 16:19:17 +0200
In-reply-to: <1403202040-12641-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403202040-12641-6-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xy7rpt1YFG9zdrWKx5OJVdoupD5+w
	WWzq38puMf/IOVaLs8sOslkc/V1g0bvgKpvF/a9HGS2+Xelgstj0+BqrxeVdc9gsZpzfx2Tx
	dMJFNotT1z+zWZzuZrWYfvwtq0Xf2ktsDoIesxsusnj8fX6dxWPH3SWMHjtn3WX32LSqk83j
	zrU9bB7zTgZ6bF5S73HlRBOrR9+WVYwe0+f9ZPL4vEkugCeKyyYlNSezLLVI3y6BK2PW/+PM
	Bf3GFW/aLBsYr2h0MXJySAiYSPzYsYgFwhaTuHBvPVsXIxeHkMBSRolTr3exQjifGSUWn3rB
	BFLFK2AgMffIF1YQW1jAW+Lzqc9sIDabgLHE5uVLwGwRATuJG6sfMoM0Mws8YpF4tOUPI0iC
	RUBVYuafm2DrOAUCJG4tugO1biqjxJ3e32DdzALqEpPmLWKGuElZYt7+Y1CbBSV+TL7HAlEj
	L7F5zVvmCYwCs5C0zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIbH4dQfj
	0mNWhxgFOBiVeHgDeFYFC7EmlhVX5h5ilOBgVhLhdd8PFOJNSaysSi3Kjy8qzUktPsTIxMEp
	1cCYmxHVLllzgav4/h2Nz0cPTvu/4U2pOn+MROMBC9sN6t/Vtq+o59jkNjU7YgvvLjuJqu93
	wpQXMbxsfX6vYNNmzV/vtHidJh6QdWiumqVg++OYVebWzM+z834++LfmpZ8vW1OToe/5ORNe
	bauIkZcqdGZqKfu4OmLNi2WuV6d28L8/eObjnLatSizFGYmGWsxFxYkA5rLQEKMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-06-19 at 20:20 +0200, Javier Martinez Canillas wrote:
> Maxim Integrated Power Management ICs are very similar with
> regard to their clock outputs. Most of the clock drivers for
> these chips are duplicating code and are simpler enough that
> can be converted to use a generic driver to consolidate code
> and avoid duplication.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

(...)

> diff --git a/drivers/clk/clk-max-gen.c b/drivers/clk/clk-max-gen.c
> new file mode 100644
> index 0000000..aa9ebbe
> --- /dev/null
> +++ b/drivers/clk/clk-max-gen.c
> @@ -0,0 +1,197 @@
> +/*
> + * clk-max-gen.c - Generic clock driver for Maxim PMICs clocks
> + *
> + * Copyright (C) 2012 Samsung Electornics
> + * Jonghwa Lee <jonghwa3.lee@samsung.com>

You copied this from original file but '2012' and author look a little
strange since this piece of work is actually new stuff. Maybe consider
adding current copyright?

> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * This driver is based on clk-max77686.c
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/regmap.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk-provider.h>
> +#include <linux/mutex.h>
> +#include <linux/clkdev.h>
> +
> +struct max_gen_clk {
> +	struct regmap *regmap;
> +	u32 mask;
> +	u32 reg;
> +	struct clk_hw hw;
> +	struct clk_lookup *lookup;
> +};
> +
> +static struct max_gen_clk *to_max_gen_clk(struct clk_hw *hw)
> +{
> +	return container_of(hw, struct max_gen_clk, hw);
> +}
> +
> +static int max_gen_clk_prepare(struct clk_hw *hw)
> +{
> +	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
> +
> +	return regmap_update_bits(max_gen->regmap, max_gen->reg,
> +				  max_gen->mask, max_gen->mask);
> +}
> +
> +static void max_gen_clk_unprepare(struct clk_hw *hw)
> +{
> +	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
> +
> +	regmap_update_bits(max_gen->regmap, max_gen->reg,
> +			   max_gen->mask, ~max_gen->mask);
> +}
> +
> +static int max_gen_clk_is_prepared(struct clk_hw *hw)
> +{
> +	struct max_gen_clk *max_gen = to_max_gen_clk(hw);
> +	int ret;
> +	u32 val;
> +
> +	ret = regmap_read(max_gen->regmap, max_gen->reg, &val);
> +
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	return val & max_gen->mask;
> +}
> +
> +static unsigned long max_gen_recalc_rate(struct clk_hw *hw,
> +					 unsigned long parent_rate)
> +{
> +	return 32768;
> +}
> +
> +struct clk_ops max_gen_clk_ops = {
> +	.prepare	= max_gen_clk_prepare,
> +	.unprepare	= max_gen_clk_unprepare,
> +	.is_prepared	= max_gen_clk_is_prepared,
> +	.recalc_rate	= max_gen_recalc_rate,
> +};
> +
> +static struct clk *max_gen_clk_register(struct device *dev,
> +					struct max_gen_clk *max_gen)
> +{
> +	struct clk *clk;
> +	struct clk_hw *hw = &max_gen->hw;
> +
> +	clk = clk_register(dev, hw);
> +	if (IS_ERR(clk))
> +		return clk;
> +
> +	max_gen->lookup = kzalloc(sizeof(struct clk_lookup), GFP_KERNEL);
> +	if (!max_gen->lookup)
> +		return ERR_PTR(-ENOMEM);
> +
> +	max_gen->lookup->con_id = hw->init->name;
> +	max_gen->lookup->clk = clk;
> +
> +	clkdev_add(max_gen->lookup);
> +
> +	return clk;
> +}
> +
> +int max_gen_clk_probe(struct platform_device *pdev, struct regmap *regmap,
> +		      u32 reg, struct clk_init_data *clks_init, int num_init)
> +{
> +	int i, ret;
> +	struct max_gen_clk **max_gen_clks;
> +	struct clk **clocks;
> +	struct device *dev = &pdev->dev;
> +
> +	clocks = devm_kzalloc(dev, sizeof(struct clk *) * num_init, GFP_KERNEL);
> +	if (!clocks)
> +		return -ENOMEM;
> +
> +	max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk *)
> +				    * num_init, GFP_KERNEL);
> +	if (!max_gen_clks)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num_init; i++) {
> +		max_gen_clks[i] = devm_kzalloc(dev, sizeof(struct max_gen_clk),
> +					       GFP_KERNEL);
> +		if (!max_gen_clks[i])
> +			return -ENOMEM;
> +	}

Why don't use only one devm_kzalloc() call for struct max_gen_clk?
Something like:
	max_gen_clks = devm_kzalloc(dev, sizeof(struct max_gen_clk)
				    * num_init, GFP_KERNEL);

This will be shorter and still readable.

> +
> +	for (i = 0; i < num_init; i++) {
> +		max_gen_clks[i]->regmap = regmap;
> +		max_gen_clks[i]->mask = 1 << i;
> +		max_gen_clks[i]->reg = reg;
> +		max_gen_clks[i]->hw.init = &clks_init[i];
> +
> +		clocks[i] = max_gen_clk_register(dev, max_gen_clks[i]);
> +		if (IS_ERR(clocks[i])) {
> +			ret = PTR_ERR(clocks[i]);
> +			dev_err(dev, "failed to register %s\n",
> +				max_gen_clks[i]->hw.init->name);
> +			goto err_clocks;
> +		}
> +	}
> +
> +	platform_set_drvdata(pdev, clocks);
> +
> +	if (dev->of_node) {
> +		struct clk_onecell_data *of_data;
> +
> +		of_data = devm_kzalloc(dev, sizeof(*of_data), GFP_KERNEL);
> +		if (!of_data) {
> +			ret = -ENOMEM;
> +			goto err_clocks;
> +		}
> +
> +		of_data->clks = clocks;
> +		of_data->clk_num = num_init;
> +		ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
> +					  of_data);
> +
> +		if (ret) {
> +			dev_err(dev, "failed to register OF clock provider\n");
> +			goto err_clocks;
> +		}
> +	}
> +
> +	return 0;
> +
> +err_clocks:
> +	for (--i; i >= 0; --i) {
> +		clkdev_drop(max_gen_clks[i]->lookup);
> +		clk_unregister(max_gen_clks[i]->hw.clk);
> +	}
> +
> +	return ret;
> +}

Since users of this function may be compiled as modules these should be
exported (EXPORT_SYMBOL(_GPL)):
ERROR: "max_gen_clk_ops" [drivers/clk/clk-max77802.ko] undefined!
ERROR: "max_gen_clk_probe" [drivers/clk/clk-max77802.ko] undefined!
ERROR: "max_gen_clk_remove" [drivers/clk/clk-max77802.ko] undefined!
ERROR: "max_gen_clk_ops" [drivers/clk/clk-max77686.ko] undefined!
ERROR: "max_gen_clk_probe" [drivers/clk/clk-max77686.ko] undefined!
ERROR: "max_gen_clk_remove" [drivers/clk/clk-max77686.ko] undefined!

Best regards,
Krzysztof

