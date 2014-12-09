Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaLIM4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 07:56:53 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12528 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaLIM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 07:56:51 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b2-5486f190e862
Message-id: <5486F18F.1000202@samsung.com>
Date: Tue, 09 Dec 2014 13:56:47 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 01/19] leds: Add LED Flash class extension to the
 LED subsystem
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-2-git-send-email-j.anaszewski@samsung.com>
 <20141203165013.GM14746@valkosipuli.retiisi.org.uk>
 <54802966.8060405@samsung.com>
 <20141209123607.GI15559@valkosipuli.retiisi.org.uk>
In-reply-to: <20141209123607.GI15559@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xK7oTPraFGHTct7LYOGM9q8XRnROZ
	LPrfLGS1OPdqJaPF2aY37BaXd81hs9j6Zh2jRc+GrawWS69fZLK4e+oom8WE6WtZLFr3HmG3
	2L3rKavF4TftrBZn9q9kc+D3WDNvDaPH5b5eJo+ds+6ye6xc/oXN4/DXhSwem1Z1snnsmf+D
	1aNvyypGjxWrv7N7fN4kF8AVxWWTkpqTWZZapG+XwJXx6a5HwWnFiqk76hsYX0p3MXJySAiY
	SBy6u5gRwhaTuHBvPVsXIxeHkMBSRoll/1ayQDgfGSWeLZjHAlLFK6Al0dW3nRnEZhFQlbjx
	ZDNYnE3AUOLni9dMILaoQITEn9P7WCHqBSV+TL4HViMioCbxdNNDsKHMAteYJDasPwnUwMEh
	LBAjsWGDG8SyKUwScz5eYQNp4BRwkNgxeRfYUGYBa4mVk7YxQtjyEpvXvGWewCgwC8mOWUjK
	ZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJM6+7GBcfMzqEKMAB6MSD6+5YmuI
	EGtiWXFl7iFGCQ5mJRHeKUfbQoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwTju0VUfqY8ntiHrm
	CMb1N6Vm20lvu5f95M3xjYqfi3I1v17sU7uyVkHUeZ+NT5bpnZuF6qIth1qOZlb8sdT89dzG
	UmpVcWxQBG/Q1rmRfO+65lVPCXfV10y7m2L94k+xZKqYoBLXZ+9LbJX/ss+0drVm75PLnCP3
	6cY8BWHDjtz3ArNOiEgosRRnJBpqMRcVJwIAbdx2sZECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 12/09/2014 01:36 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Dec 04, 2014 at 10:29:10AM +0100, Jacek Anaszewski wrote:
> ...
>>>> +static struct attribute *led_flash_strobe_attrs[] = {
>>>> +	&dev_attr_flash_strobe.attr,
>>>> +	NULL,
>>>> +};
>>>> +
>>>> +static struct attribute *led_flash_timeout_attrs[] = {
>>>> +	&dev_attr_flash_timeout.attr,
>>>> +	&dev_attr_max_flash_timeout.attr,
>>>> +	NULL,
>>>> +};
>>>> +
>>>> +static struct attribute *led_flash_brightness_attrs[] = {
>>>> +	&dev_attr_flash_brightness.attr,
>>>> +	&dev_attr_max_flash_brightness.attr,
>>>> +	NULL,
>>>> +};
>>>> +
>>>> +static struct attribute *led_flash_fault_attrs[] = {
>>>> +	&dev_attr_flash_fault.attr,
>>>> +	NULL,
>>>> +};
>>>> +
>>>> +static struct attribute *led_flash_sync_strobe_attrs[] = {
>>>> +	&dev_attr_flash_sync_strobe.attr,
>>>> +	NULL,
>>>> +};
>>>> +
>>>> +static const struct attribute_group led_flash_strobe_group = {
>>>> +	.attrs = led_flash_strobe_attrs,
>>>> +};
>>>> +
>>>> +static const struct attribute_group led_flash_timeout_group = {
>>>> +	.attrs = led_flash_timeout_attrs,
>>>> +};
>>>> +
>>>> +static const struct attribute_group led_flash_brightness_group = {
>>>> +	.attrs = led_flash_brightness_attrs,
>>>> +};
>>>> +
>>>> +static const struct attribute_group led_flash_fault_group = {
>>>> +	.attrs = led_flash_fault_attrs,
>>>> +};
>>>> +
>>>> +static const struct attribute_group led_flash_sync_strobe_group = {
>>>> +	.attrs = led_flash_sync_strobe_attrs,
>>>> +};
>>>> +
>>>> +static const struct attribute_group *flash_groups[] = {
>>>> +	&led_flash_strobe_group,
>>>> +	NULL,
>>>> +	NULL,
>>>> +	NULL,
>>>> +	NULL,
>>>> +	NULL,
>>>> +	NULL
>>>> +};
>>>> +
>>>> +static void led_flash_resume(struct led_classdev *led_cdev)
>>>> +{
>>>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>>>> +
>>>> +	call_flash_op(flash, flash_brightness_set, flash->brightness.val);
>>>> +	call_flash_op(flash, timeout_set, flash->timeout.val);
>>>> +}
>>>> +
>>>> +static void led_flash_init_sysfs_groups(struct led_classdev_flash *flash)
>>>> +{
>>>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>>>> +	const struct led_flash_ops *ops = flash->ops;
>>>> +	int num_sysfs_groups = 1;
>>>> +
>>>> +	if (ops->flash_brightness_set)
>>>> +		flash_groups[num_sysfs_groups++] = &led_flash_brightness_group;
>>>> +
>>>> +	if (ops->timeout_set)
>>>> +		flash_groups[num_sysfs_groups++] = &led_flash_timeout_group;
>>>> +
>>>> +	if (ops->fault_get)
>>>> +		flash_groups[num_sysfs_groups++] = &led_flash_fault_group;
>>>> +
>>>> +	if (led_cdev->flags & LED_DEV_CAP_COMPOUND)
>>>> +		flash_groups[num_sysfs_groups++] = &led_flash_sync_strobe_group;
>>>> +
>>>> +	led_cdev->groups = flash_groups;
>>>
>>> Shouldn't you have groups local to the device instead? If you register
>>> another flash device bad things will happen if the ops the device supports
>>> are different.
>>
>> The groups are local to the device. A LED class device is registered
>> with device_create_with_groups called from led_classdev_register
>> function. It is passed led_cdev->groups in the fifth argument.
>
> The groups pointer will be stored in struct device. If you have another
> driver using different groups, it will affect the groups for all flash
> devices that use the same groups pointer. I'm not sure what exactly would
> follow from that but I'd rather not change them once the device is created.

I had to take another look at this to understand the problem.
I think that the best option will be making flash_groups array
a member of struct led_classdev_flash.

>>>> +}
>>>> +
>>>> +int led_classdev_flash_register(struct device *parent,
>>>> +				struct led_classdev_flash *flash)
>>>> +{
>>>> +	struct led_classdev *led_cdev;
>>>> +	const struct led_flash_ops *ops;
>>>> +	int ret;
>>>> +
>>>> +	if (!flash)
>>>
>>> Do you have a use case for this?
>>
>> This is just a guard against NULL pointer dereference. Maybe it is
>> indeed redundant, as the driver developer can easily check its
>> origin during implementation.
>
> Fine for me.

Fine regarding my explanation or you agree that it is redundant?

Best Regards,
Jacek Anaszewski

