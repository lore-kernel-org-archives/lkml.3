Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaCXDj3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 23:39:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53873 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaCXDj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 23:39:28 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <532FA8ED.2090201@roeck-us.net>
Date: Sun, 23 Mar 2014 20:39:25 -0700
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
> Checks performed with linux-next/next-20140321/scripts/checkpatch.pl
>   da9063-hwmon.c            total: 0 errors, 0 warnings, 456 lines checked
>   Kconfig                   total: 1 errors, 3 warnings, 1643 lines checked
>   Makefile                  total: 0 errors, 0 warnings, 154 lines checked
>   registers.h               total: 0 errors, 0 warnings, 1066 lines checked
> There are errors and warning in Kconfig, however they are not caused
> by this patch.
>
> This is the hardware monitor driver component for DA9063 PMIC.
>
> The manual measurement allows monitoring of the system voltage
> VSYS, the auxiliary channels ADCIN1, ADCIN2 and ADCIN3, VBBAT
> measures of the backup battery voltage and a Tjunc value for the
> internal junction temperature sensor.
>

At least this part belongs into the summary.

After browsing through patch 2/3, I got suspicious and tried to compile
the driver after applying this patch.

Here is the result:

drivers/hwmon/da9063-hwmon.c: In function 'da9063_adc_manual_read':
drivers/hwmon/da9063-hwmon.c:155:2: warning: suggest parentheses around comparison in operand of '&' [-Wparentheses]
drivers/hwmon/da9063-hwmon.c: In function 'da9063_hwmon_probe':
drivers/hwmon/da9063-hwmon.c:386:14: error: 'struct da9063_pdata' has no member named 'hwmon_pdata'
drivers/hwmon/da9063-hwmon.c:387:14: error: 'struct da9063_pdata' has no member named 'hwmon_pdata'
drivers/hwmon/da9063-hwmon.c:388:14: error: 'struct da9063_pdata' has no member named 'hwmon_pdata'
drivers/hwmon/da9063-hwmon.c:417:50: error: 'struct da9063' has no member named 't_offset'
make[1]: *** [drivers/hwmon/da9063-hwmon.o] Error 1
make: *** [drivers/hwmon/da9063-hwmon.ko] Error 2

Please make sure that each patch, if applied one after another, compiles.
Patch 1/3 must not depend on patch 2/3.

Thanks,
Guenter

