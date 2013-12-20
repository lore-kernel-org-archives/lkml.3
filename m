Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3LTV1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:27:22 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59401 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3LTV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:27:19 -0500
Message-ID: <52B4B637.4090105@linaro.org>
Date: Fri, 20 Dec 2013 22:27:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, rjw@rjwysocki.net
CC: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH v2 9/9] cpuidle: remove state_count field from struct
 cpuidle_device
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com> <1387565251-7051-10-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1387565251-7051-10-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:47 PM, Bartlomiej Zolnierkiewicz wrote:
> dev->state_count is now always equal to drv->state_count so
> it can be removed.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/cpuidle/cpuidle.c | 3 ---
>   drivers/cpuidle/sysfs.c   | 5 +++--
>   include/linux/cpuidle.h   | 1 -
>   3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index a55e68f..e3d2052 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -252,9 +252,6 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
>   	if (!dev->registered)
>   		return -EINVAL;
>
> -	if (!dev->state_count)
> -		dev->state_count = drv->state_count;
> -
>   	ret = cpuidle_add_device_sysfs(dev);
>   	if (ret)
>   		return ret;
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index e918b6d..dcaae4c 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -398,7 +398,7 @@ static int cpuidle_add_state_sysfs(struct cpuidle_device *device)
>   	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(device);
>
>   	/* state statistics */
> -	for (i = 0; i < device->state_count; i++) {
> +	for (i = 0; i < drv->state_count; i++) {
>   		kobj = kzalloc(sizeof(struct cpuidle_state_kobj), GFP_KERNEL);
>   		if (!kobj)
>   			goto error_state;
> @@ -430,9 +430,10 @@ error_state:
>    */
>   static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
>   {
> +	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(device);
>   	int i;
>
> -	for (i = 0; i < device->state_count; i++)
> +	for (i = 0; i < drv->state_count; i++)
>   		cpuidle_free_state_kobj(device, i);
>   }
>
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 50fcbb0..d133817 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -69,7 +69,6 @@ struct cpuidle_device {
>   	unsigned int		cpu;
>
>   	int			last_residency;
> -	int			state_count;
>   	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
>   	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
>   	struct cpuidle_driver_kobj *kobj_driver;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

