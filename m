Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaC0RUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:20:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8206 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaC0RUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:20:14 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-c7-53345dcc40c2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 2/2] clk: Add handling of clk parent and rate
 assigned from DT
Date: Thu, 27 Mar 2014 18:19:51 +0100
Message-id: <2035207.RtdvCosQOa@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1395922579-28547-3-git-send-email-s.nawrocki@samsung.com>
References: <1395922579-28547-1-git-send-email-s.nawrocki@samsung.com>
 <1395922579-28547-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsVy+t9jAd0zsSbBBldmy1jMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu8Wmx9dYLS7vmsNmcfsyr8XaI3fZLZZev8hk8XTCRTaL1r1H2C0O
	v2lntZgx+SWbxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8lj06pONo871/aweeyfu4bdY/OSeo++
	LasYPT5vkgvgjOKySUnNySxLLdK3S+DK6Fp2n7FgnnfF0/Vf2RsY91l1MXJySAiYSNxYN5sF
	whaTuHBvPVsXIxeHkMAiRomurgZWCKeFSWLRh7tgVWwCVhIT21cxgtgiAvoSS1ZdBOtgFvjI
	JHHlxjNmkISwQLTEyoNf2EFsFgFViXtzloLZvAKaEtNX7gIbJCrgKbFj+0o2EJtTwF3iTe8+
	ZohtzYwS6w6/ZoNoEJT4MfkeWAOzgLzEvv1TWSFsHYn9rdPYJjAKzEJSNgtJ2SwkZQsYmVcx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfXM+kdjKsaLA4xCnAwKvHwzrAyCRZiTSwrrsw9
	xCjBwawkwnsyCijEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomD
	U6qBUTTQpr903pHyX3e7DHpzJK+baMqyxW2YtWla2tqzMW4z/py9WJXkuaxzZt6GlL2/DzSU
	Svc2SW+LDD10pUV9e4Jytu2sRdv7w7173++ufKXNxL9u1YmsfQpbdMs1ay1u8H4uu3r/wfN5
	r6epSt7ce2NZxxSltlOfzr27pWe1/11WmfvX6+djTJVYijMSDbWYi4oTAcE1snGrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sylwester,

On Thursday, March 27, 2014 01:16:19 PM Sylwester Nawrocki wrote:
> This function adds a helper function to configure clock parents and rates
> as specified in clock-parents, clock-rates DT properties for a consumer
> device and a call to it before driver is bound to a device.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
> Changes since v2:
>  - edited in clock-bindings.txt, added note about 'assigned-clocks'
>    subnode which may be used to specify "global" clocks configuration
>    at a clock provider node,
>  - moved of_clk_device_setup() function declaration from clk-provider.h
>    to clk-conf.h so required function stubs are available when
>    CONFIG_COMMON_CLK is not enabled,
> 
> Changes since v1:
>  - the helper function to parse and set assigned clock parents and
>    rates made public so it is available to clock providers to call
>    directly;
>  - dropped the platform bus notification and call of_clk_device_setup()
>    is is now called from the driver core, rather than from the
>    notification callback;
>  - s/of_clk_get_list_entry/of_clk_get_by_property.
> ---
>  .../devicetree/bindings/clock/clock-bindings.txt   |   26 ++++++
>  drivers/base/dd.c                                  |    7 ++
>  drivers/clk/Makefile                               |    1 +
>  drivers/clk/clk-conf.c                             |   87 ++++++++++++++++++++
>  drivers/clk/clk.c                                  |   10 ++-
>  include/linux/clk/clk-conf.h                       |   19 +++++
>  6 files changed, 149 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/clk-conf.c
>  create mode 100644 include/linux/clk/clk-conf.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> index 7c52c29..b452f80 100644
> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -115,3 +115,29 @@ clock signal, and a UART.
>    ("pll" and "pll-switched").
>  * The UART has its baud clock connected the external oscillator and its
>    register clock connected to the PLL clock (the "pll-switched" signal)
> +
> +==Assigned clock parents and rates==
> +
> +Some platforms require static initial configuration of parts of the clocks
> +controller. Such a configuration can be specified in a clock consumer node
> +through clock-parents and clock-rates DT properties. The former should contain
> +a list of parent clocks in form of phandle and clock specifier pairs, the
> +latter the list of assigned clock frequency values (one cell each).
> +
> +    uart@a000 {
> +        compatible = "fsl,imx-uart";
> +        reg = <0xa000 0x1000>;
> +        ...
> +        clocks = <&clkcon 0>, <&clkcon 3>;
> +        clock-names = "baud", "mux";
> +
> +        clock-parents = <0>, <&pll 1>;
> +        clock-rates = <460800>;
> +    };
> +
> +In this example the pll is set as parent of "mux" clock and frequency of "baud"
> +clock is specified as 460800 Hz.
> +
> +For clocks which are not directly connected to any consumer device similarly
> +clocks, clock-parents and/or clock-rates properties should be specified in
> +assigned-clocks subnode of a clock controller DT node.
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 0605176..4c633e7 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -25,6 +25,7 @@
>  #include <linux/async.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pinctrl/devinfo.h>
> +#include <linux/clk/clk-conf.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -278,6 +279,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
>  	if (ret)
>  		goto probe_failed;
>  
> +	if (dev->of_node) {
> +		ret = of_clk_device_init(dev->of_node);
> +		if (ret)
> +			goto probe_failed;
> +	}
> +
>  	if (driver_sysfs_add(dev)) {
>  		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
>  			__func__, dev_name(dev));
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index a367a98..c720e4b 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
>  obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
>  obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
>  obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
> +obj-$(CONFIG_COMMON_CLK)	+= clk-conf.o
>  
>  # hardware specific clock types
>  # please keep this section sorted lexicographically by file/directory path name
> diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
> new file mode 100644
> index 0000000..a2e992e
> --- /dev/null
> +++ b/drivers/clk/clk-conf.c
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
> + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/device.h>
> +#include <linux/of.h>
> +#include <linux/printk.h>
> +
> +/**
> + * of_clk_device_init() - parse and set clk configuration assigned to a device
> + * @node: device node to apply the configuration for
> + *
> + * This function parses 'clock-parents' and 'clock-rates' properties and sets
> + * any specified clock parents and rates.
> + */
> +int of_clk_device_init(struct device_node *node)
> +{
> +	struct property	*prop;
> +	const __be32 *cur;
> +	int rc, index, num_parents;
> +	struct clk *clk, *pclk;
> +	u32 rate;
> +
> +	num_parents = of_count_phandle_with_args(node, "clock-parents",
> +						 "#clock-cells");
> +	if (num_parents == -EINVAL)
> +		pr_err("clk: Invalid value of clock-parents property at %s\n",
> +		       node->full_name);
> +
> +	for (index = 0; index < num_parents; index++) {
> +		pclk = of_clk_get_by_property(node, "clock-parents", index);
> +		if (IS_ERR(pclk)) {
> +			/* skip empty (null) phandles */
> +			if (PTR_ERR(pclk) == -ENOENT)
> +				continue;
> +
> +			pr_warn("clk: couldn't get parent clock %d for %s\n",
> +				index, node->full_name);
> +			return PTR_ERR(pclk);
> +		}
> +
> +		clk = of_clk_get(node, index);
> +		if (IS_ERR(clk)) {
> +			pr_warn("clk: couldn't get clock %d for %s\n",
> +				index, node->full_name);
> +			return PTR_ERR(clk);
> +		}
> +
> +		rc = clk_set_parent(clk, pclk);
> +		if (rc < 0)
> +			pr_err("clk: failed to reparent %s to %s: %d\n",
> +			       __clk_get_name(clk), __clk_get_name(pclk), rc);
> +		else
> +			pr_debug("clk: set %s as parent of %s\n",
> +				 __clk_get_name(pclk), __clk_get_name(clk));
> +	}
> +
> +	index = 0;
> +	of_property_for_each_u32(node, "clock-rates", prop, cur, rate) {
> +		if (rate) {
> +			clk = of_clk_get(node, index);
> +			if (IS_ERR(clk)) {
> +				pr_warn("clk: couldn't get clock %d for %s\n",
> +					index, node->full_name);
> +				return PTR_ERR(clk);
> +			}
> +
> +			rc = clk_set_rate(clk, rate);
> +			if (rc < 0)
> +				pr_err("clk: couldn't set %s clock rate: %d\n",
> +				       __clk_get_name(clk), rc);
> +			else
> +				pr_debug("clk: set rate of clock %s to %lu\n",
> +					 __clk_get_name(clk), clk_get_rate(clk));
> +		}
> +		index++;
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 29dc1e7..240d776 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include <linux/clk-private.h>
> +#include <linux/clk/clk-conf.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> @@ -2604,7 +2605,15 @@ void __init of_clk_init(const struct of_device_id *matches)
>  		list_for_each_entry_safe(clk_provider, next,
>  					&clk_provider_list, node) {
>  			if (force || parent_ready(clk_provider->np)) {
> +
>  				clk_provider->clk_init_cb(clk_provider->np);
> +
> +				/* Set any assigned clock parents and rates */
> +				np = of_get_child_by_name(clk_provider->np,
> +							  "assigned-clocks");
> +				if (np)
> +					of_clk_device_init(np);
> +
>  				list_del(&clk_provider->node);
>  				kfree(clk_provider);
>  				is_init_done = true;
> @@ -2619,7 +2628,6 @@ void __init of_clk_init(const struct of_device_id *matches)
>  		 */
>  		if (!is_init_done)
>  			force = true;
> -
>  	}
>  }
>  #endif
> diff --git a/include/linux/clk/clk-conf.h b/include/linux/clk/clk-conf.h
> new file mode 100644
> index 0000000..f06b1c2
> --- /dev/null
> +++ b/include/linux/clk/clk-conf.h
> @@ -0,0 +1,19 @@
> +/*
> + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
> + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +struct device_node;
> +
> +#if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
> +int of_clk_device_init(struct device_node *node);
> +#else
> +int of_clk_device_init(struct device_node *node)

It causes build brake with s3c6400_defconfig.

It should be marked with 'static inline' and clk-conf.c should be build
only for CONFIG_OF=y.

> +{
> +	return 0;
> +}
> +#endif

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

