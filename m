Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3BICBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 21:01:04 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39055 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3BICBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 21:01:02 -0500
Date: Fri, 8 Feb 2013 17:57:18 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bq27x00_battery: Fix reporting battery temperature
Message-ID: <20130209015718.GA13561@lizard.sbx05663.mountca.wayport.net>
References: <1359799569-5322-1-git-send-email-pali.rohar@gmail.com>
 <201302032101.54487@pali>
 <20130203200557.GA15430@lizard.gateway.2wire.net>
 <201302061856.35366@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201302061856.35366@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 06:56:34PM +0100, Pali Rohár wrote:
[...]
> >  * All voltages, currents, charges, energies, time and
> > temperatures in uV, * µA, µAh, µWh, seconds and tenths of
> > degree Celsius unless otherwise * stated. It's driver's job
[...]
> bq27x00_battery reporting "POWER_SUPPLY_TEMP=2700"
> and rx51_battery reporting "POWER_SUPPLY_TEMP=3590"
[...]
> Subject: [PATCH] bq27x00_battery: Report temperature in 1/100 degree Celsius

Hm. The documentation says tenth (1/10) degrees, and you even restate it
in the commit message. But the subject, and your example seem to prove
that you still report it in 1/100 of Celsius.

Unless your phone was on fire during the time you took the values, I tend
to think the patch needs to be fixed. :-)

Thanks,
Anton

> * Documentation/power/power_supply_class.txt say that temperature must be reported in tenths of degree 
> Celsius
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 5b077af..482755f 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -312,8 +312,10 @@ static int bq27x00_battery_read_temperature(struct bq27x00_device_info *di)
>  		return temp;
>  	}
>  
> -	if (!bq27xxx_is_chip_version_higher(di))
> -		temp = 5 * temp / 2;
> +	if (bq27xxx_is_chip_version_higher(di))
> +		temp *= 10;
> +	else
> +		temp *= 25;
>  
>  	return temp;
>  }
> @@ -640,7 +642,7 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
>  	case POWER_SUPPLY_PROP_TEMP:
>  		ret = bq27x00_simple_value(di->cache.temperature, val);
>  		if (ret == 0)
> -			val->intval -= 2731;
> +			val->intval -= 27310;
>  		break;
>  	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
>  		ret = bq27x00_simple_value(di->cache.time_to_empty, val);
> -- 
> 1.7.10.4
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com
