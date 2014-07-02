Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaGBLyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:54:17 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:52059 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaGBLyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <1401789598-14967-1-git-send-email-punit.agrawal@arm.com>
References: <1401789598-14967-1-git-send-email-punit.agrawal@arm.com>
Date: Wed, 2 Jul 2014 07:54:14 -0400
Message-ID: <CAC-25o8UV36ZXdBVtHvrahi58m-MB42v9d7oFkKxHOwAxA5L8w@mail.gmail.com>
Subject: Re: [PATCH] thermal: Bind cooling devices with the correct arguments
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Punit,

On Tue, Jun 3, 2014 at 5:59 AM, Punit Agrawal <punit.agrawal@arm.com> wrote:
> When binding cooling devices to thermal zones created from the device
> tree the minimum and maximum cooling states are in the wrong order
> leading to failure to bind.
>
> Fix the order of cooling states in the call to
> thermal_zone_bind_cooling_device to fix this.
>
> Cc:Zhang Rui <rui.zhang@intel.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>

Rui, to avoid further delays, can you please pick this one directly?

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
>                         ret = thermal_zone_bind_cooling_device(thermal,
>                                                 tbp->trip_id, cdev,
> -                                               tbp->min,
> -                                               tbp->max);
> +                                               tbp->max,
> +                                               tbp->min);
>                         if (ret)
>                                 return ret;
>                 }
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
