Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3HBX7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:59:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:57525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab3HBX7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,805,1367996400"; 
   d="scan'208";a="356542667"
Message-ID: <51FC49A2.5010901@linux.intel.com>
Date: Fri, 02 Aug 2013 17:06:58 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RFC v01 2/3] PowerCap: Add class driver
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>  <1375466932-11842-3-git-send-email-srinivas.pandruvada@linux.intel.com> <1375483407.2034.146.camel@joe-AO722>
In-Reply-To: <1375483407.2034.146.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:43 PM, Joe Perches wrote:
> On Fri, 2013-08-02 at 11:08 -0700, Srinivas Pandruvada wrote:
>> Added power cap class driver, which provides an API for client drivers
>> to use and provide a consistant sys-fs interface to user mode.
> Just some stylistic notes.
>
>> diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
> []
>> +/* Power zone show function */
>> +#define define_device_show(_attr)		\
>> +static ssize_t show_##_attr(struct device *dev, struct device_attribute *attr,\
>> +			char *buf) \
> Using _attr and another variable named attr is at least
> visually confusing.
>
> Maybe use name or type instead of _attr?
>
>> +{ \
>> +	u64 value; \
>> +	ssize_t len = -EINVAL; \
>> +	struct powercap_zone_device *pcd_dev = dev_get_drvdata(dev); \
>> +	\
>> +	if (pcd_dev && pcd_dev->ops && pcd_dev->ops->get_##_attr) { \
>> +		mutex_lock(&pcd_dev->lock); \
>> +		if (!pcd_dev->ops->get_##_attr(pcd_dev, &value)) \
>> +			len = sprintf(buf, "%lld\n", value); \
>> +		mutex_unlock(&pcd_dev->lock); \
>> +	} \
>> +	\
>> +	return len; \
>> +}
>> +
>> +/* Power zone store function; only reset is possible */
>> +#define define_device_store(_attr)		\
>> +static ssize_t store_##_attr(struct device *dev,\
>> +				struct device_attribute *attr, \
>> +				const char *buf, size_t count) \
> here too
>
> []
>
>> +/* Power zone constraint show function */
>> +#define define_device_constraint_show(_attr) \
>> +static ssize_t show_constraint_##_attr(struct device *dev, \
>> +				struct device_attribute *attr,\
>> +				char *buf) \
> and here
>
> []
>
>> +/* Power zone constraint store function */
>> +#define define_device_constraint_store(_attr) \
>> +static ssize_t store_constraint_##_attr(struct device *dev,\
>> +				struct device_attribute *attr, \
>> +				const char *buf, size_t count) \
> etc...
>
>> +struct powercap_zone_constraint *powercap_zone_add_constraint(
>> +				struct powercap_zone_device *pcd_dev,
>> +				struct powercap_zone_constraint_ops *ops)
>> +{
> []
>> +	dev_dbg(&pcd_dev->device, "powercap_zone_add_constraint\n");
> These logging messages aren't useful.
> function tracing works very well.
>
>
>
Thanks. Will change in the next patchset.

Thanks,
Srinivas
