Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaFQKUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:20:48 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53205 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752704AbaFQKUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:20:46 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] thermal: Bind cooling devices with the correct arguments
References: <1401789598-14967-1-git-send-email-punit.agrawal@arm.com>
Date: Tue, 17 Jun 2014 11:20:38 +0100
In-Reply-To: <1401789598-14967-1-git-send-email-punit.agrawal@arm.com> (Punit
	Agrawal's message of "Tue, 3 Jun 2014 10:59:58 +0100")
Message-ID: <9hh61jzsuq1.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ping?

Punit Agrawal <punit.agrawal@arm.com> writes:

> When binding cooling devices to thermal zones created from the device
> tree the minimum and maximum cooling states are in the wrong order
> leading to failure to bind.
>
> Fix the order of cooling states in the call to
> thermal_zone_bind_cooling_device to fix this.
>
> Cc:Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> ---
> Hi Eduardo,
>
> I am hoping this can be picked up for 3.16 as a bug fix.
>
> Thanks,
> Punit
>
>  drivers/thermal/of-thermal.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 04b1be7..97d312f 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -156,8 +156,8 @@ static int of_thermal_bind(struct thermal_zone_device *thermal,
>  
>  			ret = thermal_zone_bind_cooling_device(thermal,
>  						tbp->trip_id, cdev,
> -						tbp->min,
> -						tbp->max);
> +						tbp->max,
> +						tbp->min);
>  			if (ret)
>  				return ret;
>  		}
