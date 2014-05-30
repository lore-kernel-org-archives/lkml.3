Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaE3IJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:09:01 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:46418 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaE3IIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:08:54 -0400
Date: Fri, 30 May 2014 09:08:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 1/3] mfd: intel_soc_pmic: Core driver
Message-ID: <20140530080848.GB2619@lee--X1>
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401347968-24410-2-git-send-email-lejun.zhu@linux.intel.com>
 <20140529114052.GI1954@lee--X1>
 <53880FF5.8070500@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53880FF5.8070500@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +static int intel_soc_pmic_find_gpio_irq(struct device *dev)
> >> +{
> >> +	struct gpio_desc *desc;
> >> +	int irq;
> >> +
> >> +	desc = devm_gpiod_get_index(dev, KBUILD_MODNAME, 0);
> > 
> > What does "KBUILD_MODNAME" translate to?
> 
> It translates into "intel_soc_pmic".

Can you just put that instead?

> >> +	if (IS_ERR(desc)) {
> >> +		dev_dbg(dev, "Not using GPIO as interrupt.\n");
> > 
> > You can't have a debug print, then return an err - use dev_err().
> 
> Actually returning ENOENT here is just a hardware difference. On some
> boards the PMIC interrupt is from a GPIO line exposed by the CPU, on the
> rest (e.g. Asus T100TA) it's not. When -ENOENT is returned, probe() will
> simply use the IRQ provided by the I2C.
> 
> I will remove this line completely, and put a comment before the function.

That'll do, thanks.

> >> +static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
> >> +	{"INT33FD:00", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> >> +	{ }
> >> +};
> >> +MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
> >> +
> >> +static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
> >> +	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> >> +	{ },
> >> +};
> >> +MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);
> > 
> > Does ACPI have a match function to extact it's .driver_data attribute?
> > 
> > If so, are you using it here? If not, why not?
> > 
> 
> The ACPI table is used in i2c_device_match(), and the i2c table is used
> in i2c_device_probe(), so the id in the i2c table is actually fed to
> intel_soc_pmic_probe(). But I only found out now that having the i2c
> table alone is enough, because i2c_device_match will fallback to the i2c
> table if there's no ACPI table. So to keep it simple, I'll remove the
> ACPI table completely.

Actually, can you do it the other way round?  Minimise the i2c table
and populate the ACPI one.  I'm just about to work on a separate
patch-set which deprecates the use of the i2c table on DT and/or ACPI
only registered devices.

> By the way, the GPIO child driver got reviewed-by from Linus Walleij,
> but can't be merged because it depends on intel_soc_pmic.h. May I
> include it in next version of the patch set and have it merged along
> with the MFD driver?

Yes, if it's okay with Linus and you aapply his Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
