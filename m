Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaDCCm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:42:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:22401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656AbaDCCm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,783,1389772800"; 
   d="scan'208";a="513795923"
Message-ID: <1396492931.2357.22.camel@rzhang1-mobl4>
Subject: Re: [PATCH] linux/thermal.h: Rename KELVIN_TO_CELSIUS to
 DECI_KELVIN_TO_CELSIUS
From: Zhang Rui <rui.zhang@intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Sujith Thomas <sujith.thomas@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-pm@vger.kernel.org
Date: Thu, 03 Apr 2014 10:42:11 +0800
In-Reply-To: <1395682149-16563-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1395682149-16563-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-24 at 18:29 +0100, Rasmus Villemoes wrote:
> The macros KELVIN_TO_CELSIUS and CELSIUS_TO_KELVIN actually work on
> decikelvins, so rename them to reflect their actual semantics.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

applied on top of Guenter' "Fix KELVIN_TO_CELSIUS macro" patch.

thanks,
rui
> ---
>  drivers/acpi/thermal.c              | 12 ++++++------
>  drivers/platform/x86/asus-wmi.c     |  2 +-
>  drivers/platform/x86/intel_menlow.c |  8 ++++----
>  include/linux/thermal.h             |  6 +++---
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index 08626c8..3742e64 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -313,7 +313,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
>  			if (crt == -1) {
>  				tz->trips.critical.flags.valid = 0;
>  			} else if (crt > 0) {
> -				unsigned long crt_k = CELSIUS_TO_KELVIN(crt);
> +				unsigned long crt_k = CELSIUS_TO_DECI_KELVIN(crt);
>  				/*
>  				 * Allow override critical threshold
>  				 */
> @@ -349,7 +349,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
>  		if (psv == -1) {
>  			status = AE_SUPPORT;
>  		} else if (psv > 0) {
> -			tmp = CELSIUS_TO_KELVIN(psv);
> +			tmp = CELSIUS_TO_DECI_KELVIN(psv);
>  			status = AE_OK;
>  		} else {
>  			status = acpi_evaluate_integer(tz->device->handle,
> @@ -429,7 +429,7 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
>  					break;
>  				if (i == 1)
>  					tz->trips.active[0].temperature =
> -						CELSIUS_TO_KELVIN(act);
> +						CELSIUS_TO_DECI_KELVIN(act);
>  				else
>  					/*
>  					 * Don't allow override higher than
> @@ -437,9 +437,9 @@ static int acpi_thermal_trips_update(struct acpi_thermal *tz, int flag)
>  					 */
>  					tz->trips.active[i - 1].temperature =
>  						(tz->trips.active[i - 2].temperature <
> -						CELSIUS_TO_KELVIN(act) ?
> +						CELSIUS_TO_DECI_KELVIN(act) ?
>  						tz->trips.active[i - 2].temperature :
> -						CELSIUS_TO_KELVIN(act));
> +						CELSIUS_TO_DECI_KELVIN(act));
>  				break;
>  			} else {
>  				tz->trips.active[i].temperature = tmp;
> @@ -1094,7 +1094,7 @@ static int acpi_thermal_add(struct acpi_device *device)
>  		goto free_memory;
>  
>  	pr_info(PREFIX "%s [%s] (%ld C)\n", acpi_device_name(device),
> -		acpi_device_bid(device), KELVIN_TO_CELSIUS(tz->temperature));
> +		acpi_device_bid(device), DECI_KELVIN_TO_CELSIUS(tz->temperature));
>  	goto end;
>  
>  free_memory:
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index c5e082f..2d81d5a 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1066,7 +1066,7 @@ static ssize_t asus_hwmon_temp1(struct device *dev,
>  	if (err < 0)
>  		return err;
>  
> -	value = KELVIN_TO_CELSIUS((value & 0xFFFF)) * 1000;
> +	value = DECI_KELVIN_TO_CELSIUS((value & 0xFFFF)) * 1000;
>  
>  	return sprintf(buf, "%d\n", value);
>  }
> diff --git a/drivers/platform/x86/intel_menlow.c b/drivers/platform/x86/intel_menlow.c
> index e8b46d2..0a919d8 100644
> --- a/drivers/platform/x86/intel_menlow.c
> +++ b/drivers/platform/x86/intel_menlow.c
> @@ -315,7 +315,7 @@ static ssize_t aux0_show(struct device *dev,
>  
>  	result = sensor_get_auxtrip(attr->handle, 0, &value);
>  
> -	return result ? result : sprintf(buf, "%lu", KELVIN_TO_CELSIUS(value));
> +	return result ? result : sprintf(buf, "%lu", DECI_KELVIN_TO_CELSIUS(value));
>  }
>  
>  static ssize_t aux1_show(struct device *dev,
> @@ -327,7 +327,7 @@ static ssize_t aux1_show(struct device *dev,
>  
>  	result = sensor_get_auxtrip(attr->handle, 1, &value);
>  
> -	return result ? result : sprintf(buf, "%lu", KELVIN_TO_CELSIUS(value));
> +	return result ? result : sprintf(buf, "%lu", DECI_KELVIN_TO_CELSIUS(value));
>  }
>  
>  static ssize_t aux0_store(struct device *dev,
> @@ -345,7 +345,7 @@ static ssize_t aux0_store(struct device *dev,
>  	if (value < 0)
>  		return -EINVAL;
>  
> -	result = sensor_set_auxtrip(attr->handle, 0, CELSIUS_TO_KELVIN(value));
> +	result = sensor_set_auxtrip(attr->handle, 0, CELSIUS_TO_DECI_KELVIN(value));
>  	return result ? result : count;
>  }
>  
> @@ -364,7 +364,7 @@ static ssize_t aux1_store(struct device *dev,
>  	if (value < 0)
>  		return -EINVAL;
>  
> -	result = sensor_set_auxtrip(attr->handle, 1, CELSIUS_TO_KELVIN(value));
> +	result = sensor_set_auxtrip(attr->handle, 1, CELSIUS_TO_DECI_KELVIN(value));
>  	return result ? result : count;
>  }
>  
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7..c978aa3 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -41,9 +41,9 @@
>  #define THERMAL_NO_LIMIT	THERMAL_CSTATE_INVALID
>  
>  /* Unit conversion macros */
> -#define KELVIN_TO_CELSIUS(t)	(long)(((long)t-2732 >= 0) ?	\
> -				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
> -#define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
> +#define DECI_KELVIN_TO_CELSIUS(t)	(long)(((long)t-2732 >= 0) ?	\
> +					((long)t-2732+5)/10 : ((long)t-2732-5)/10)
> +#define CELSIUS_TO_DECI_KELVIN(t)	((t)*10+2732)
>  
>  /* Adding event notification support elements */
>  #define THERMAL_GENL_FAMILY_NAME                "thermal_event"


