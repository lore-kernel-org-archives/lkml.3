Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaLDGAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 01:00:06 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLDGAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 01:00:05 -0500
Date: Wed, 3 Dec 2014 01:08:46 -0800
From: Darren Hart <dvhart@infradead.org>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [RESEND PATCH v5 4/5] acerhdf: added critical trip point
Message-ID: <20141203090846.GD52608@vmdeb7>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1417184452-11884-1-git-send-email-peter@piie.net>
 <1417184452-11884-5-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417184452-11884-5-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 03:20:51PM +0100, Peter Feuerer wrote:
> added critical trip point which represents the temperature limit.

Nitpic, Add ^

> Added return -EINVAL in case wrong trip point is provided.

Add (we are going to add it with this patch, it wasn't added previously). It's a
nitpic. But this is more consistent with typical commit message language.

I might normally just fix that upon commit, but since I had a few questions on
the last one, if that results in a V2, please correct this as well.

> 
> Cc: platform-driver-x86@vger.kernel.org
> Cc: Darren Hart <dvhart@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andreas Mohr <andi@lisas.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Peter Feuerer <peter@piie.net>
> ---
>  drivers/platform/x86/acerhdf.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 7fe7dbf..91b16c8 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -443,6 +443,10 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
>  {
>  	if (trip == 0)
>  		*type = THERMAL_TRIP_ACTIVE;
> +	else if (trip == 1)
> +		*type = THERMAL_TRIP_CRITICAL;
> +	else
> +		return -EINVAL;
>  
>  	return 0;
>  }
> @@ -463,6 +467,10 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>  {
>  	if (trip == 0)
>  		*temp = fanon;
> +	else if (trip == 1)
> +		*temp = ACERHDF_TEMP_CRIT;
> +	else
> +		return -EINVAL;
>  
>  	return 0;
>  }
> @@ -713,7 +721,7 @@ static int acerhdf_register_thermal(void)
>  	if (IS_ERR(cl_dev))
>  		return -EINVAL;
>  
> -	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
> +	thz_dev = thermal_zone_device_register("acerhdf", 2, 0, NULL,
>  					      &acerhdf_dev_ops,
>  					      &acerhdf_zone_params, 0,
>  					      (kernelmode) ? interval*1000 : 0);
> -- 
> 2.1.3
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
