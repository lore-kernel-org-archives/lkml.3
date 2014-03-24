Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaCXD13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 23:27:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51967 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaCXD11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 23:27:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <532FA61C.7070601@roeck-us.net>
Date: Sun, 23 Mar 2014 20:27:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        Jean Delvare <jdelvare@suse.de>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC V1 1/3] hwmon: da9063: HWMON driver
References: <cover.1395607051.git.stwiss.opensource@diasemi.com> <420d4f5c8436a66b511693531cfeda131258ce69.1395607051.git.stwiss.opensource@diasemi.com>
In-Reply-To: <420d4f5c8436a66b511693531cfeda131258ce69.1395607051.git.stwiss.opensource@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2014 01:37 PM, Opensource [Steve Twiss] wrote:
> From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
>
> Add the HWMON driver for DA9063
>
> Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
> ---

> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &da9063_attr_group);
> +	if (ret)
> +		return ret;
> +
> +	hwmon->classdev = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(hwmon->classdev)) {
> +		sysfs_remove_group(&pdev->dev.kobj, &da9063_attr_group);
> +		return PTR_ERR(hwmon->classdev);
> +	}
> +

Hi Steve,

This looks like an ideal candidate for devm_hwmon_device_register_with_groups().
Can you use that API, please ?

Thanks,
Guenter

