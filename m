Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3CZWgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:36:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34951 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3CZWgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:36:32 -0400
Message-ID: <515222B7.8060506@ti.com>
Date: Tue, 26 Mar 2013 18:35:35 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.daniel@samsung.com>, <durgadoss.r@intel.com>, <andi@lisas.de>
Subject: Re: [RFC,4/5] Thermal: governor API cleanup
References: <1364315169-15427-5-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1364315169-15427-5-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-03-2013 12:26, Zhang Rui wrote:
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>
> ---
> drivers/thermal/thermal_core.c |    2 --
>   drivers/thermal/thermal_core.h |    2 ++
>   include/linux/thermal.h        |    3 ---

Please also clean Documentation/thermal/sysfs_api.txt

>   3 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index eac9745..f645757 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -99,7 +99,6 @@ int thermal_register_governor(struct thermal_governor *governor)
>
>   	return err;
>   }
> -EXPORT_SYMBOL_GPL(thermal_register_governor);
>
>   void thermal_unregister_governor(struct thermal_governor *governor)
>   {
> @@ -127,7 +126,6 @@ void thermal_unregister_governor(struct thermal_governor *governor)
>   	mutex_unlock(&thermal_governor_lock);
>   	return;
>   }
> -EXPORT_SYMBOL_GPL(thermal_unregister_governor);
>
>   static int get_idr(struct idr *idr, struct mutex *lock, int *id)
>   {
> diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
> index f84ea0f..a1f8278 100644
> --- a/drivers/thermal/thermal_core.h
> +++ b/drivers/thermal/thermal_core.h
> @@ -50,6 +50,8 @@ struct thermal_instance {
>   	struct list_head cdev_node; /* node in cdev->thermal_instances */
>   };
>
> +extern int thermal_register_governor(struct thermal_governor *);
> +extern void thermal_unregister_governor(struct thermal_governor *);

Does this really need to be extern?

>
>   #ifdef CONFIG_THERMAL_GOV_STEP_WISE
>   extern int thermal_gov_step_wise_register(void);
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 2eeec01..af03ea6 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -243,9 +243,6 @@ struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
>   void thermal_cdev_update(struct thermal_cooling_device *);
>   void notify_thermal_framework(struct thermal_zone_device *, int);
>
> -int thermal_register_governor(struct thermal_governor *);
> -void thermal_unregister_governor(struct thermal_governor *);
> -
>   #ifdef CONFIG_NET
>   extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
>   						enum events event);
>

