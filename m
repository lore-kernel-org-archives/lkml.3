Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3IYHN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:13:29 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:38086
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457Ab3IYHN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:13:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <52428D13.7080007@freescale.com>
Date: Wed, 25 Sep 2013 15:13:23 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <joe@perches.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCHv6 02/16] drivers: thermal: introduce device tree parser
References: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com> <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1379540136-28378-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 05:35 AM, Eduardo Valentin wrote:
>   
> [...]
> +
> +/***   sensor API   ***/
> +

You are introducing new concept here, the original framework and drivers 
cannot use this, right? any further plan to update original framework 
for this new feature?

> +static struct thermal_zone_device *
> +thermal_zone_of_add_sensor(struct device_node *zone,
> +			   struct device_node *sensor, void *data,
> +			   int (*get_temp)(void *, long *),
> +			   int (*get_trend)(void *, long *))
> +{
> +	struct thermal_zone_device *tzd;
> +	struct __thermal_zone *tz;
> +
> +	tzd = thermal_zone_get_zone_by_name(zone->name);
> +	if (IS_ERR(tzd))
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> [...]
> +
> +/*
> + * Here are the thermal trip types. This must
> + * match with enum thermal_trip_type at
> + * include/linux/thermal.h
> + */
> +#define THERMAL_TRIP_ACTIVE		0
> +#define THERMAL_TRIP_PASSIVE		1
> +#define THERMAL_TRIP_HOT		2
> +#define THERMAL_TRIP_CRITICAL		3
> +

These macros seem duplicated with enum thermal_trip_type in thermal.h, 
do you have further plan to merge them?
Or by using string "active",  "passive" etc in the dts, then you can 
reuse the original enum definition.

> +/* On cooling devices upper and lower limits */
> +#define THERMAL_NO_LIMIT		(-1UL)
> +
> +#endif
> [...]


