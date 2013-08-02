Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3HBWna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:43:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48100 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754269Ab3HBWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:43:28 -0400
Message-ID: <1375483407.2034.146.camel@joe-AO722>
Subject: Re: [RFC v01 2/3] PowerCap: Add class driver
From: Joe Perches <joe@perches.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Fri, 02 Aug 2013 15:43:27 -0700
In-Reply-To: <1375466932-11842-3-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1375466932-11842-3-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 11:08 -0700, Srinivas Pandruvada wrote:
> Added power cap class driver, which provides an API for client drivers
> to use and provide a consistant sys-fs interface to user mode.

Just some stylistic notes.

> diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
[]
> +/* Power zone show function */
> +#define define_device_show(_attr)		\
> +static ssize_t show_##_attr(struct device *dev, struct device_attribute *attr,\
> +			char *buf) \

Using _attr and another variable named attr is at least
visually confusing.

Maybe use name or type instead of _attr?

> +{ \
> +	u64 value; \
> +	ssize_t len = -EINVAL; \
> +	struct powercap_zone_device *pcd_dev = dev_get_drvdata(dev); \
> +	\
> +	if (pcd_dev && pcd_dev->ops && pcd_dev->ops->get_##_attr) { \
> +		mutex_lock(&pcd_dev->lock); \
> +		if (!pcd_dev->ops->get_##_attr(pcd_dev, &value)) \
> +			len = sprintf(buf, "%lld\n", value); \
> +		mutex_unlock(&pcd_dev->lock); \
> +	} \
> +	\
> +	return len; \
> +}
> +
> +/* Power zone store function; only reset is possible */
> +#define define_device_store(_attr)		\
> +static ssize_t store_##_attr(struct device *dev,\
> +				struct device_attribute *attr, \
> +				const char *buf, size_t count) \

here too

[]

> +/* Power zone constraint show function */
> +#define define_device_constraint_show(_attr) \
> +static ssize_t show_constraint_##_attr(struct device *dev, \
> +				struct device_attribute *attr,\
> +				char *buf) \

and here

[]

> +/* Power zone constraint store function */
> +#define define_device_constraint_store(_attr) \
> +static ssize_t store_constraint_##_attr(struct device *dev,\
> +				struct device_attribute *attr, \
> +				const char *buf, size_t count) \

etc...

> +struct powercap_zone_constraint *powercap_zone_add_constraint(
> +				struct powercap_zone_device *pcd_dev,
> +				struct powercap_zone_constraint_ops *ops)
> +{
[]
> +	dev_dbg(&pcd_dev->device, "powercap_zone_add_constraint\n");

These logging messages aren't useful.
function tracing works very well.


