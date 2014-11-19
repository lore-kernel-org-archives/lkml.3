Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaKSPmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:42:22 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:52804 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSPmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:42:20 -0500
Message-ID: <546CBA3C.9020709@kapsi.fi>
Date: Wed, 19 Nov 2014 17:41:48 +0200
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eduardo Valentin <edubezval@gmail.com>,
        Linux PM <linux-pm@vger.kernel.org>
CC: Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCHv4 1/1] thermal: of: improve of-thermal sensor registration
 API
References: <1416321575-18348-1-git-send-email-edubezval@gmail.com> <1416321575-18348-2-git-send-email-edubezval@gmail.com>
In-Reply-To: <1416321575-18348-2-git-send-email-edubezval@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 04:39 PM, Eduardo Valentin wrote:
> Different drivers request API extensions in of-thermal. For this reason,
> additional callbacks are required to fit the new drivers needs.
>
> The current API implementation expects the registering sensor driver
> to provide a get_temp and get_trend callbacks as function parameters.
> As the amount of callbacks is growing, this patch changes the existing
> implementation to use a .ops field to hold all the of thermal callbacks
> to sensor drivers.
>
> This patch also changes the existing of-thermal users to fit the new
> API design. No functional change is introduced in this patch.
>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: devicetree@vger.kernel.org
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jean Delvare <jdelvare@suse.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: lm-sensors@lm-sensors.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Reviewed-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> ---
>   drivers/hwmon/lm75.c                               |  9 +++--
>   drivers/hwmon/ntc_thermistor.c                     |  6 +++-
>   drivers/hwmon/tmp102.c                             |  6 +++-
>   drivers/thermal/of-thermal.c                       | 40 ++++++++++------------
>   drivers/thermal/tegra_soctherm.c                   |  7 ++--
>   drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  8 +++--
>   include/linux/thermal.h                            | 24 +++++++++----
>   7 files changed, 63 insertions(+), 37 deletions(-)
> ---
> Difference from V3:
>    - Keep the same behavior regarding callback checks.
>      Change in behavior may be sent in a separate patch.
> Difference from V2:
>    - Fix wrong assignment in tegra driver.
> Difference from V1:
>    - Fix error handling when .get_trend is not provided.
>
> @@ -356,8 +356,8 @@ thermal_zone_of_add_sensor(struct device_node *zone,
>    *             than one sensors
>    * @data: a private pointer (owned by the caller) that will be passed
>    *        back, when a temperature reading is needed.
> - * @get_temp: a pointer to a function that reads the sensor temperature.
> - * @get_trend: a pointer to a function that reads the sensor temperature trend.
> + * @ops: struct thermal_zone_of_device *. Must contain at least .get_trend and
> + *       .get_temp.

This comment seems to be incorrect, as .get_trend is optional.

>    *
>    * This function will search the list of thermal zones described in device
>    * tree and look for the zone that refer to the sensor device pointed by

With that minor one fixed,

Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Reviewed-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>

Cheers,
Mikko
