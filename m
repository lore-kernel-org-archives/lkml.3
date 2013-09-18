Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3IRVEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 17:04:54 -0400
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:34990 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753808Ab3IRVEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 17:04:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4321:4605:5007:6119:7652:10004:10400:10848:11026:11232:11233:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:139
X-HE-Tag: sink55_2a46ab1356101
X-Filterd-Recvd-Size: 2225
Message-ID: <1379538289.1787.74.camel@joe-AO722>
Subject: Re: [PATCHv5 02/16] drivers: thermal: introduce device tree parser
From: Joe Perches <joe@perches.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: swarren@wwwdotorg.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob.herring@calxeda.com, linux@roeck-us.net,
        rui.zhang@intel.com, wni@nvidia.com, grant.likely@linaro.org,
        durgadoss.r@intel.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Wed, 18 Sep 2013 14:04:49 -0700
In-Reply-To: <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com>
References: <1379536310-30000-1-git-send-email-eduardo.valentin@ti.com>
	 <1379537849-28425-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 16:57 -0400, Eduardo Valentin wrote:
> This patch introduces a device tree bindings for
> describing the hardware thermal behavior and limits.
> Also a parser to read and interpret the data and feed
> it in the thermal framework is presented.
[]
> +int __init of_parse_thermal_zones(void)
> +{
> +	struct device_node *np, *child;
> +	struct __thermal_zone *tz;
> +	struct thermal_zone_device_ops *ops;
[]
> +		if (!ops)
> +			return -ENOMEM;
> +
> +		tzp = kzalloc(sizeof(*tzp), GFP_KERNEL);
> +		if (!tzp)
> +			return -ENOMEM;

leaking memory when ops && !tpz

> +
> +		/* No hwmon because there might be hwmon drivers registering */
> +		tzp->no_hwmon = true;
> +
> +		zone = thermal_zone_device_register(child->name, tz->ntrips,
> +						    0, tz,
> +						    ops, tzp,
> +						    tz->passive_delay,
> +						    tz->polling_delay);
> +		if (IS_ERR(zone))
> +			pr_err("Failed to build %s zone %ld\n", child->name,
> +			       PTR_ERR(zone));
> +	}

Still leaking memory if !zone no?

> +
> +	return 0;
> +}


