Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3LISqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:46:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33081 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab3LISqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:46:11 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-95-52a60ff036e2
From: Tomasz Figa <t.figa@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rjw@rjwysocki.net, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        yadi.brar01@gmail.com, myungjoo.ham@samsung.com,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Andrew Bresticker <abrestic@google.com>,
        Doug Anderson <dianders@google.com>
Subject: Re: [RFC v2 1/4] power: asv: Add common ASV support for Samsung SoCs
Date: Mon, 09 Dec 2013 19:45:57 +0100
Message-id: <4229773.U5JovcREjb@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384515691-26299-2-git-send-email-sachin.kamat@linaro.org>
References: <1384515691-26299-1-git-send-email-sachin.kamat@linaro.org>
 <1384515691-26299-2-git-send-email-sachin.kamat@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xy7of+JcFGTy4KG3x8OhnNosF21cy
	WfQuuMpmsenxNVaLy7vmsFl87j3CaDHj/D4mi9uNK9gszpy+xGpx8k8vo8WqXX8YLeb+bmS1
	mDP9HZMDr8fOWXfZPRZsKvW4c20Pm8fmJfUeW662s3j0bVnF6PF5k1wAexSXTUpqTmZZapG+
	XQJXRtfBtWwFa0wqXh7cytzAuFSzi5GTQ0LAROLmnceMELaYxIV769lAbCGBpYwSLa0eXYxc
	QHYXk8TJ7g3sIAk2ATWJzw2PwIpEBLQkXnYvZwIpYhb4zSSx48lPsCJhAV+JBc/OgdksAqoS
	R1ZNZwaxeQU0Je5/ns8KYvMLqEu82/aUCcQWFXCTeLFvC1g9p4CHxJo5pxkhNrcySrz8s48V
	ollQ4sfkeywgNrOAvMS+/VNZIWwtifU7jzNNYBSchaRsFpKyWUjKFjAyr2IUTS1NLihOSs81
	1CtOzC0uzUvXS87P3cQIiaYvOxgXH7M6xCjAwajEw1vAsCxIiDWxrLgy9xCjBAezkggvFztQ
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA6Pm4UcRHLEmbpWLzlmZ/fpd5MGy89GTtSds0uZcrr14
	9vNn3veTVZW+RAWnhdyem2Dw6g+3iXytwIGDHD4vr5U2FfjPMzuc9v/JlDvKh+dx77Q0sX+V
	svX76lOJi1gYJm8/s2372ZD7ZyaLqwo9+KN6r0Bit/ZNuxrVzeI9KrcVBMuV3QwvC51VYinO
	SDTUYi4qTgQAThJP24QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder, Sachin,

On Friday 15 of November 2013 17:11:28 Sachin Kamat wrote:
> From: Yadwinder Singh Brar <yadi.brar@samsung.com>
> 
> This patch introduces a common ASV (Adaptive Supply Voltage) basic framework
> for samsung SoCs. It provides common APIs (to be called by users to get ASV
> values or init opp_table) and an interface for SoC specific drivers to
> register ASV members (instances).
[snip]
> diff --git a/drivers/power/asv/asv.c b/drivers/power/asv/asv.c
> new file mode 100644
> index 000000000000..3f2c31a0d3a9
> --- /dev/null
> +++ b/drivers/power/asv/asv.c
> @@ -0,0 +1,176 @@
> +/*
> + * ASV(Adaptive Supply Voltage) common core
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include <linux/io.h>
> +#include <linux/pm_opp.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/power/asv-driver.h>
> +
> +static LIST_HEAD(asv_list);
> +static DEFINE_MUTEX(asv_mutex);
> +
> +struct asv_member {
> +	struct list_head		node;
> +	struct asv_info *asv_info;

nit: Inconsistent indentation of member names. In general I would
recommend dropping the tabs between types and names and using a single
space instead, since this is more future proof - you will never have to
change other lines to add new ones.

> +};
> +
> +static void add_asv_member(struct asv_member *asv_mem)
> +{
> +	mutex_lock(&asv_mutex);
> +	list_add_tail(&asv_mem->node, &asv_list);
> +	mutex_unlock(&asv_mutex);
> +}
> +
> +static struct asv_member *asv_get_mem(enum asv_type_id asv_type)

I don't really like this enum based look-up. It's hard to define an enum
that covers any possible existing and future platforms that would not be
bloated with single platform specific entries. IMHO something string based
could be more scalable.

> +{
> +	struct asv_member *asv_mem;
> +	struct asv_info *asv_info;
> +
> +	list_for_each_entry(asv_mem, &asv_list, node) {
> +		asv_info = asv_mem->asv_info;
> +		if (asv_type == asv_info->type)
> +			return asv_mem;
> +	}

Don't you need any kind of locking here? A mutex in add_asv_member()
suggests that read access to the list should be protected as well.

> +
> +	return NULL;
> +}
> +
> +unsigned int asv_get_volt(enum asv_type_id target_type,
> +						unsigned int target_freq)

Do you need this function at all? I believe this is all about populating
device's OPP array with frequencies and voltages according to its ASV
level. Users will be able to query for required voltage using standard OPP
calls then, without a need for ASV specific functions like this one.

> +{
> +	struct asv_member *asv_mem = asv_get_mem(target_type);
> +	struct asv_freq_table *dvfs_table;
> +	struct asv_info *asv_info;
> +	unsigned int i;
> +
> +	if (!asv_mem)
> +		return 0;
> +
> +	asv_info = asv_mem->asv_info;
> +	dvfs_table = asv_info->dvfs_table;
> +
> +	for (i = 0; i < asv_info->nr_dvfs_level; i++) {
> +		if (dvfs_table[i].freq == target_freq)
> +			return dvfs_table[i].volt;
> +	}
> +
> +	return 0;
> +}
> +
> +int asv_init_opp_table(struct device *dev, enum asv_type_id target_type)
> +{
> +	struct asv_member *asv_mem = asv_get_mem(target_type);
> +	struct asv_info *asv_info;
> +	struct asv_freq_table *dvfs_table;
> +	unsigned int i;
> +
> +	if (!asv_mem)
> +		return -EINVAL;
> +
> +	asv_info = asv_mem->asv_info;
> +	dvfs_table = asv_info->dvfs_table;
> +
> +	for (i = 0; i < asv_info->nr_dvfs_level; i++) {
> +		if (dev_pm_opp_add(dev, dvfs_table[i].freq * 1000,
> +			dvfs_table[i].volt)) {
> +			dev_warn(dev, "Failed to add OPP %d\n",
> +				 dvfs_table[i].freq);

Hmm, shouldn't it be considered a failure instead?

> +			continue;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct asv_member *asv_init_member(struct asv_info *asv_info)
> +{
> +	struct asv_member *asv_mem;
> +	int ret = 0;
> +
> +	if (!asv_info) {
> +		pr_err("No ASV info provided\n");
> +		return NULL;

I'd suggest adopting the ERR_PTR() convention, which allows returning more
information about the error.

> +	}
> +
> +	asv_mem = kzalloc(sizeof(*asv_mem), GFP_KERNEL);
> +	if (!asv_mem) {
> +		pr_err("Allocation failed for member: %s\n", asv_info->name);
> +		return NULL;
> +	}
> +
> +	asv_mem->asv_info = kmemdup(asv_info, sizeof(*asv_info), GFP_KERNEL);
> +	if (!asv_mem->asv_info) {
> +		pr_err("Copying asv_info failed for member: %s\n",
> +			asv_info->name);
> +		kfree(asv_mem);
> +		return NULL;

For consistency, the error here should be handled as below, by using the
error path.

> +	}
> +	asv_info = asv_mem->asv_info;
> +
> +	if (asv_info->ops->get_asv_group) {
> +		ret = asv_info->ops->get_asv_group(asv_info);
> +		if (ret) {
> +			pr_err("get_asv_group failed for %s : %d\n",
> +				asv_info->name, ret);
> +			goto err;
> +		}
> +	}
> +
> +	if (asv_info->ops->init_asv)
> +		ret = asv_info->ops->init_asv(asv_info);
> +		if (ret) {
> +			pr_err("asv_init failed for %s : %d\n",
> +				asv_info->name, ret);
> +			goto err;
> +		}
> +
> +	/* In case of parsing table from DT, we may need to add flag to identify
> +	DT supporting members and call init_asv_table from asv_init_opp_table(
> +	after getting dev_node from dev,if required), instead of calling here.
> +	*/

coding style: Wrong multi-line comment style.

/*
 * This is a valid multi-line comment.
 */

> +
> +	if (asv_info->ops->init_asv_table) {
> +		ret = asv_info->ops->init_asv_table(asv_info);
> +		if (ret) {
> +			pr_err("init_asv_table failed for %s : %d\n",
> +				asv_info->name, ret);
> +			goto err;
> +		}
> +	}

Hmm, I don't see a point of these three separate callbacks above.

In general, I'd suggest a different architecture. I'd see this more as:

1) Platform code registers static platform device to instantiate SoC ASV
   driver.
2) SoC specific ASV driver probes, reads group ID from hardware register,
   calls register_asv_member() with appropriate DVFS table for detected
   group.
3) Driver using ASV calls asv_init_opp_table() with its struct device and
   ASV member name, which causes the ASV code to fill device's operating
   point using OPP calls.

Now client driver has all the information it needs and the work of ASV
subsystem is done. The control flow between drivers would be much simpler
and no callbacks would have to be called.

Best regards,
Tomasz

