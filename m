Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaJBWYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 18:24:55 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:34714 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaJBWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 18:24:53 -0400
Date: Thu, 2 Oct 2014 18:24:43 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] thermal: core: fix: Check return code of the
 ->get_max_state() callback
Message-ID: <20141002222441.GA11510@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-4-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411547232-21493-4-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:27:12AM +0200, Lukasz Majewski wrote:
> Without this check it was possible to execute cooling device binding code
> even when wrong max cooling state was read.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>

Rui, are you taking these patches? Do you prefer me to collect them?

Cheers

Eduardo

> ---
>  drivers/thermal/thermal_core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 747618a..8a4dc35 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -928,7 +928,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  	struct thermal_zone_device *pos1;
>  	struct thermal_cooling_device *pos2;
>  	unsigned long max_state = 0;
> -	int result;
> +	int result, ret;
>  
>  	if (trip >= tz->trips || (trip < 0 && trip != THERMAL_TRIPS_NONE))
>  		return -EINVAL;
> @@ -945,7 +945,9 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  	if (tz != pos1 || cdev != pos2)
>  		return -EINVAL;
>  
> -	cdev->ops->get_max_state(cdev, &max_state);
> +	ret = cdev->ops->get_max_state(cdev, &max_state);
> +	if (ret)
> +		return ret;
>  
>  	/* lower default 0, upper default max_state */
>  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> -- 
> 2.0.0.rc2
> 
