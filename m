Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaKRALu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:11:50 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:59961 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKRALs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:11:48 -0500
Message-ID: <546A8EA9.5070001@kapsi.fi>
Date: Tue, 18 Nov 2014 02:11:21 +0200
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
Subject: Re: [PATCHv2 1/1] thermal: of: improve of-thermal sensor registration
 API
References: <1416263769-6578-2-git-send-email-edubezval@gmail.com> <1416264255-10083-1-git-send-email-edubezval@gmail.com>
In-Reply-To: <1416264255-10083-1-git-send-email-edubezval@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 12:44 AM, Eduardo Valentin wrote:
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
> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> ---
>
> Difference from V1:
>   - Fix error handling when .get_trend is not provided.
>
> ---
>   drivers/hwmon/lm75.c                               |  9 +++--
>   drivers/hwmon/ntc_thermistor.c                     |  6 +++-
>   drivers/hwmon/tmp102.c                             |  6 +++-
>   drivers/thermal/of-thermal.c                       | 41 +++++++++-------------
>   drivers/thermal/tegra_soctherm.c                   |  7 ++--
>   drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  8 +++--
>   include/linux/thermal.h                            | 24 +++++++++----
>   7 files changed, 62 insertions(+), 39 deletions(-)
>
> ...
> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soctherm.c
> index 70f7e9e..893c39c 100644
> --- a/drivers/thermal/tegra_soctherm.c
> +++ b/drivers/thermal/tegra_soctherm.c
> @@ -317,6 +317,10 @@ static int tegra_thermctl_get_temp(void *data, long *out_temp)
>   	return 0;
>   }
>
> +static const struct thermal_zone_of_device_ops tegra_of_thermal_ops = {
> +	.get_trend = tegra_thermctl_get_temp,
> +};

This should probably read ".get_temp = tegra_thermctl_get_temp" instead 
of .get_trend :)

> ...

Cheers,
Mikko

