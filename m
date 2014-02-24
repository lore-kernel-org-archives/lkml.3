Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaBXHOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:14:22 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17169 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBXHOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:14:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 23 Feb 2014 23:11:49 -0800
Message-ID: <530AF134.4000505@nvidia.com>
Date: Mon, 24 Feb 2014 15:13:56 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "rui.zhang@intel.com" <rui.zhang@intel.com>
CC: "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Thermal: Allow first update of cooling device state
References: <1392606175-19635-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1392606175-19635-1-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rui
Do you have any comment for it ?

Thanks.
Wei.

On 02/17/2014 11:02 AM, Wei Ni wrote:
> In initialization, if the cooling device is initialized at
> max cooling state, and the thermal zone temperature is below
> the first trip point, then the cooling state can't be updated
> to the right state, untill the first trip point be triggered.
> 
> To fix this issue, allow first update of cooling device state
> during registration, initialized "updated" device field as
> "false" (instead of "true").
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/thermal/thermal_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 338a88b..02f57af 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1107,7 +1107,7 @@ __thermal_cooling_device_register(struct device_node *np,
>  	INIT_LIST_HEAD(&cdev->thermal_instances);
>  	cdev->np = np;
>  	cdev->ops = ops;
> -	cdev->updated = true;
> +	cdev->updated = false;
>  	cdev->device.class = &thermal_class;
>  	cdev->devdata = devdata;
>  	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
> 

