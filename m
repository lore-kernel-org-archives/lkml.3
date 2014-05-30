Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaE3J2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:28:33 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:60636 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaE3J2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:28:31 -0400
Date: Fri, 30 May 2014 10:28:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 1/3] mfd: intel_soc_pmic: Core driver
Message-ID: <20140530092825.GG2619@lee--X1>
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401347968-24410-2-git-send-email-lejun.zhu@linux.intel.com>
 <20140529114052.GI1954@lee--X1>
 <53880FF5.8070500@linux.intel.com>
 <20140530080848.GB2619@lee--X1>
 <5388497C.3000106@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5388497C.3000106@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>> +static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
> >>>> +	{"INT33FD:00", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> >>>> +	{ }
> >>>> +};
> >>>> +MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
> >>>> +
> >>>> +static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
> >>>> +	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> >>>> +	{ },
> >>>> +};
> >>>> +MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);
> >>>
> >>> Does ACPI have a match function to extact it's .driver_data attribute?
> >>>
> >>> If so, are you using it here? If not, why not?
> >>>
> >>
> >> The ACPI table is used in i2c_device_match(), and the i2c table is used
> >> in i2c_device_probe(), so the id in the i2c table is actually fed to
> >> intel_soc_pmic_probe(). But I only found out now that having the i2c
> >> table alone is enough, because i2c_device_match will fallback to the i2c
> >> table if there's no ACPI table. So to keep it simple, I'll remove the
> >> ACPI table completely.
> > 
> > Actually, can you do it the other way round?  Minimise the i2c table
> > and populate the ACPI one.  I'm just about to work on a separate
> > patch-set which deprecates the use of the i2c table on DT and/or ACPI
> > only registered devices.
> 
> Current i2c_device_probe will only feed driver_data from i2c_device_id
> table to intel_soc_pmic_probe(), because it uses i2c_match_id(). So if I
> remove "&intel_soc_pmic_config_crc" from the i2c table, I will get NULL
> from id->driver_data until your new patch fixes it.

Right, which is why I asked if ACPI has a match function - I just
looked and it does.  So what you need to do is supply a very simple
i2c_device_id struct (just until my patch lands, then there'll be no
reason to supply one at all) and use  acpi_match_device() instead of
using id->driver_data.

> So for the driver to work for the i2c code both today and in the future,
> I think it's best to keep the driver_data populated in both tables. What
> do you think?


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
