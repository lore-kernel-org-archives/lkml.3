Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaEZGDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:24446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaEZGDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:03:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,910,1392192000"; 
   d="scan'208";a="546497827"
Message-ID: <5382D914.4070603@linux.intel.com>
Date: Mon, 26 May 2014 14:03:00 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH RESEND v2 2/4] mfd: intel_soc_pmic: I2C interface
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com> <1400805629-10322-3-git-send-email-lejun.zhu@linux.intel.com> <20140523175312.GI22111@sirena.org.uk>
In-Reply-To: <20140523175312.GI22111@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/24/2014 1:53 AM, Mark Brown wrote:
> On Fri, May 23, 2014 at 08:40:27AM +0800, Zhu, Lejun wrote:
> 
>> +static int pmic_i2c_lookup_gpio(struct device *dev, int acpi_index)
>> +{
>> +	struct gpio_desc *desc;
>> +	int gpio;
>> +
>> +	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
>> +	if (IS_ERR(desc))
>> +		return PTR_ERR(desc);
>> +
>> +	gpio = desc_to_gpio(desc);
>> +
>> +	gpiod_put(desc);
>> +
>> +	return gpio;
>> +}
> 
> Why not just have the driver work with the gpiod API, is there any real
> need to convert to a GPIO number?

The whole function will be removed since the gpio set code is removed
during probe.

>> +static const struct i2c_device_id pmic_i2c_id[] = {
>> +	{ "crystal_cove", (kernel_ulong_t)&crystal_cove_pmic},
>> +	{ "INT33FD", (kernel_ulong_t)&crystal_cove_pmic},
>> +	{ "INT33FD:00", (kernel_ulong_t)&crystal_cove_pmic},
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, pmic_i2c_id);
> 
> The INT33FD ones here look like they should only be in the ACPI table.

You are right. Only INT33FD:00 should be here.

>> +static int __init pmic_i2c_init(void)
>> +{
>> +	int ret;
>> +
>> +	ret = i2c_add_driver(&pmic_i2c_driver);
>> +	if (ret != 0)
>> +		pr_err("Failed to register pmic I2C driver: %d\n", ret);
>> +
>> +	return ret;
>> +}
>> +subsys_initcall(pmic_i2c_init);
> 
> module_i2c_driver() - you shouldn't need subsys_initcall().

I'll change it to module_init.

Best Regards
Lejun

