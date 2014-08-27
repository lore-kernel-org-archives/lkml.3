Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935667AbaH0Sit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:38:49 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36573 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaH0Sir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:38:47 -0400
Date: Wed, 27 Aug 2014 11:38:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lee.jones@linaro.org,
        lm-sensors@lm-sensors.org, wim@iguana.be,
        linux-watchdog@vger.kernel.org, cooloney@gmail.com, rpurdie@rpsys.net,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v6 4/4] drivers/hwmon/menf21bmc_hwmon: introduce
 MEN14F021P00 BMC HWMON driver
Message-ID: <20140827183843.GC2198@roeck-us.net>
References: <cover.1409161615.git.andreas.werner@men.de>
 <65074740dfc6363134384b45fcd3acf5f2b4254f.1409161615.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65074740dfc6363134384b45fcd3acf5f2b4254f.1409161615.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 07:53:06PM +0200, Andreas Werner wrote:
> Added driver to support the 14F021P00 BMC Hardware Monitoring.
> The BMC is a Board Management Controller including monitoring of the
> board voltages.
> 
> Signed-off-by: Andreas Werner <andreas.werner@men.de>

Looks good, though I do have one comment ...

> +
> +	hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
> +						   "menf21bmc", drv_data,
> +						   menf21bmc_hwmon_groups);
> +	if (IS_ERR(hwmon_dev))
> +		return PTR_ERR(hwmon_dev);
> +
> +	dev_info(&pdev->dev, "MEN 14F021P00 BMC hwmon device enabled");
> +
You removed the dev_info from the mfd driver but left it in the client
drivers.  If you'd drop it here as well, you could use
'return PTR_ERR_OR_ZERO(hwmon_dev);'.  Just a suggestion, not mandatory.

Either case,

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

I assume this will go in through the mfd tree.

Thanks,
Guenter
