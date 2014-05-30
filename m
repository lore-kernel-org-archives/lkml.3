Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaE3JED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:04:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:14025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbaE3JD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:03:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,940,1392192000"; 
   d="scan'208";a="539951195"
Message-ID: <5388497C.3000106@linux.intel.com>
Date: Fri, 30 May 2014 17:03:56 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 1/3] mfd: intel_soc_pmic: Core driver
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com> <1401347968-24410-2-git-send-email-lejun.zhu@linux.intel.com> <20140529114052.GI1954@lee--X1> <53880FF5.8070500@linux.intel.com> <20140530080848.GB2619@lee--X1>
In-Reply-To: <20140530080848.GB2619@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/5/30 16:08, Lee Jones wrote:
>>>> +static int intel_soc_pmic_find_gpio_irq(struct device *dev)
>>>> +{
>>>> +	struct gpio_desc *desc;
>>>> +	int irq;
>>>> +
>>>> +	desc = devm_gpiod_get_index(dev, KBUILD_MODNAME, 0);
>>>
>>> What does "KBUILD_MODNAME" translate to?
>>
>> It translates into "intel_soc_pmic".
> 
> Can you just put that instead?

Sure. I'll fix it.

(...)

>>>> +static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
>>>> +	{"INT33FD:00", (kernel_ulong_t)&intel_soc_pmic_config_crc},
>>>> +	{ }
>>>> +};
>>>> +MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
>>>> +
>>>> +static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
>>>> +	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
>>>> +	{ },
>>>> +};
>>>> +MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);
>>>
>>> Does ACPI have a match function to extact it's .driver_data attribute?
>>>
>>> If so, are you using it here? If not, why not?
>>>
>>
>> The ACPI table is used in i2c_device_match(), and the i2c table is used
>> in i2c_device_probe(), so the id in the i2c table is actually fed to
>> intel_soc_pmic_probe(). But I only found out now that having the i2c
>> table alone is enough, because i2c_device_match will fallback to the i2c
>> table if there's no ACPI table. So to keep it simple, I'll remove the
>> ACPI table completely.
> 
> Actually, can you do it the other way round?  Minimise the i2c table
> and populate the ACPI one.  I'm just about to work on a separate
> patch-set which deprecates the use of the i2c table on DT and/or ACPI
> only registered devices.

Current i2c_device_probe will only feed driver_data from i2c_device_id
table to intel_soc_pmic_probe(), because it uses i2c_match_id(). So if I
remove "&intel_soc_pmic_config_crc" from the i2c table, I will get NULL
from id->driver_data until your new patch fixes it.

So for the driver to work for the i2c code both today and in the future,
I think it's best to keep the driver_data populated in both tables. What
do you think?

Best Regards
Lejun

