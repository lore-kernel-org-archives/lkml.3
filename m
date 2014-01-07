Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaAGPEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:04:16 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:27733 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaAGPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:04:03 -0500
Date: Tue, 7 Jan 2014 16:03:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, rui.zhang@intel.com,
        rdunlap@infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] thermal: fix compilation issue on CONFIG_THERMAL_OF
  dependencies
Message-ID: <20140107160346.522f3138@endymion.delvare>
In-Reply-To: <52CC104A.6010805@roeck-us.net>
References: <52CBF1CF.2000603@ti.com>
	<1389098667-9826-1-git-send-email-eduardo.valentin@ti.com>
	<52CC104A.6010805@roeck-us.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jan 2014 06:33:46 -0800, Guenter Roeck wrote:
> Alternative would be something like
> 
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index f7e11c7..156bb4d 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -244,7 +244,7 @@ struct thermal_genl_event {
>   };
> 
>   /* Function declarations */
> -#ifdef CONFIG_THERMAL_OF
> +#if defined(CONFIG_THERMAL_OF) && (defined(CONFIG_THERMAL) || (defined(MODULE) && defined(CONFIG_THERMAL_MODULE)))
>   struct thermal_zone_device *
>   thermal_zone_of_sensor_register(struct device *dev, int id,
>                                  void *data, int (*get_temp)(void *, long *),

I don't like it. Using defined(MODULE) in a header file seems quite
risky (although I see there are occurrences of this already.) But more
importantly, this means that you can have all pieces enabled in your
kernel but the code will be silently stubbed out because the
combinations of Y and M happens to be unsupported but this is nowhere
documented. This is wrong.

-- 
Jean Delvare
