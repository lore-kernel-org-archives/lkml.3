Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab3HSSWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:22:14 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59585 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3HSSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:22:09 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-13-5212624e8ebd
Message-id: <5212624D.5090708@samsung.com>
Date: Mon, 19 Aug 2013 20:22:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND] i2c: move of helpers into the core
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de>
 <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
In-reply-to: <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xy7p+SUJBBovX2Ficu9XAajH/yDlW
	i+X7+hktNj2+xmqxsG0Ji0XH3y+MFpd3zWGz6NmwldVi9pJ+FosZ5/cxWXR+mcVm8fv7P1aL
	lSdmMTvwesyZ1sTisXlJvcf5GQsZPU6eesLi8XmTXABrFJdNSmpOZllqkb5dAldG44mXrAV9
	mhU3F55laWA8r9DFyMkhIWAicf3+AXYIW0ziwr31bF2MXBxCAksZJQ6t3c8M4XxilLh3eTEr
	SBWvgJbEym3/mUFsFgFViTmvDrGA2GwChhK9R/sYQWxRgQCJxUvOsUPUC0r8mHwPrEZEQEWi
	c/1/FpChzAJtzBLH+o8zgSSEBewkFn3/ADZUSKBC4sCehWA2p4CTxJb2s2DNzAI6Evtbp7FB
	2PISm9e8ZZ7AKDALyY5ZSMpmISlbwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkRr7u
	YFx6zOoQowAHoxIPb4eSUJAQa2JZcWXuIUYJDmYlEd6v7EAh3pTEyqrUovz4otKc1OJDjEwc
	nFINjKoqeTyZqdX3ljyZxna8e/5f1iPb9Nw+5Hic1t91+abmNwGX6uzUwoZHyxqdU7ftCr6w
	YMWntXJTg+Ys2/r1aMlfU9bPp3/yHY0JbIhzMpy3LLROrXpfg3VAo8jDXzenJX++VG36x7P8
	H+e9Zyl+837pxMe7uTf8D+CyEm51+Siz98apb8uqJJRYijMSDbWYi4oTAQw5jolvAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 07:59 PM, Wolfram Sang wrote:
> I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
> that it is much cleaner to have this in the core. This also removes a
> circular dependency between the helpers and the core, and so we can
> finally register child nodes in the core instead of doing this manually
> in each driver. So, fix the drivers and documentation, too.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> 
> Sigh, hitting the CC threshold on vger again. So resending to the lists only.
> BTW this patch is based on -rc4 and was tested on an AT91 board. More tests
> very welcome. Thanks!
> 
> 
>  drivers/i2c/busses/i2c-s3c2410.c                |    2 -
>  drivers/media/platform/exynos4-is/fimc-is-i2c.c |    3 -

For these:

Acked-by: Sylwester Nawrocki <s.nawrocki@amsung.com>

However this patch fails to apply onto either v3.11-rc4 or v3.11-rc6:

Applying: i2c: move of helpers into the core
fatal: sha1 information is lacking or useless (drivers/i2c/busses/i2c-powermac.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 i2c: move of helpers into the core


One nitpick below..

[...]
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index f32ca29..321b7ca 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -23,7 +23,11 @@
>     SMBus 2.0 support by Mark Studebaker <mdsxyz123@yahoo.com> and
>     Jean Delvare <khali@linux-fr.org>
>     Mux support by Rodolfo Giometti <giometti@enneenne.com> and
> -   Michael Lawnick <michael.lawnick.ext@nsn.com> */
> +   Michael Lawnick <michael.lawnick.ext@nsn.com>
> +   OF support is copyright (c) 2008 Jochen Friedrich <jochen@scram.de>
> +   (based on a previous patch from Jon Smirl <jonsmirl@gmail.com>) and
> +   (c) 2013  Wolfram Sang <wsa@the-dreams.de>
> + */
>  
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> @@ -35,7 +39,9 @@
>  #include <linux/init.h>
>  #include <linux/idr.h>
>  #include <linux/mutex.h>
> +#include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/of_irq.h>
>  #include <linux/completion.h>
>  #include <linux/hardirq.h>
>  #include <linux/irqflags.h>
> @@ -954,6 +960,102 @@ static void i2c_scan_static_board_info(struct i2c_adapter *adapter)
>  	up_read(&__i2c_board_lock);
>  }
>  
> +/* of support code */

/* OF support code */

or

/*
 * Device Tree support code.
 */

?
> +#if IS_ENABLED(CONFIG_OF)
> +static void of_i2c_register_devices(struct i2c_adapter *adap)
> +{
> +	void *result;
> +	struct device_node *node;
> +
> +	/* Only register child devices if the adapter has a node pointer set */
> +	if (!adap->dev.of_node)
> +		return;
> +
> +	dev_dbg(&adap->dev, "of_i2c: walking child nodes\n");
> +
> +	for_each_available_child_of_node(adap->dev.of_node, node) {
> +		struct i2c_board_info info = {};
> +		struct dev_archdata dev_ad = {};
> +		const __be32 *addr;
> +		int len;
> +
> +		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
> +
> +		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
> +			dev_err(&adap->dev, "of_i2c: modalias failure on %s\n",
> +				node->full_name);
> +			continue;
> +		}
> +
> +		addr = of_get_property(node, "reg", &len);
> +		if (!addr || (len < sizeof(int))) {
> +			dev_err(&adap->dev, "of_i2c: invalid reg on %s\n",
> +				node->full_name);
> +			continue;
> +		}
> +
> +		info.addr = be32_to_cpup(addr);
> +		if (info.addr > (1 << 10) - 1) {
> +			dev_err(&adap->dev, "of_i2c: invalid addr=%x on %s\n",
> +				info.addr, node->full_name);
> +			continue;
> +		}
> +
> +		info.irq = irq_of_parse_and_map(node, 0);
> +		info.of_node = of_node_get(node);
> +		info.archdata = &dev_ad;
> +
> +		if (of_get_property(node, "wakeup-source", NULL))
> +			info.flags |= I2C_CLIENT_WAKE;
> +
> +		request_module("%s%s", I2C_MODULE_PREFIX, info.type);
> +
> +		result = i2c_new_device(adap, &info);
> +		if (result == NULL) {
> +			dev_err(&adap->dev, "of_i2c: Failure registering %s\n",
> +				node->full_name);
> +			of_node_put(node);
> +			irq_dispose_mapping(info.irq);
> +			continue;
> +		}
> +	}
> +}
> +
> +static int of_dev_node_match(struct device *dev, void *data)
> +{
> +	return dev->of_node == data;
> +}
> +
> +/* must call put_device() when done with returned i2c_client device */
> +struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
> +{
> +	struct device *dev;
> +
> +	dev = bus_find_device(&i2c_bus_type, NULL, node,
> +					 of_dev_node_match);
> +	if (!dev)
> +		return NULL;
> +
> +	return i2c_verify_client(dev);
> +}
> +EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
> +
> +/* must call put_device() when done with returned i2c_adapter device */
> +struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
> +{
> +	struct device *dev;
> +
> +	dev = bus_find_device(&i2c_bus_type, NULL, node,
> +					 of_dev_node_match);
> +	if (!dev)
> +		return NULL;
> +
> +	return i2c_verify_adapter(dev);
> +}
> +EXPORT_SYMBOL(of_find_i2c_device_by_node);
> +#endif /* CONFIG_OF */

Thanks,
Sylwester
