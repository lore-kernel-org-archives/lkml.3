Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3AXWyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:54:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54363 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab3AXWyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:54:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: shuox.liu@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, pavel@ucw.cz,
        len.brown@intel.com, yanmin_zhang@linux.intel.com,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH] PM / Runtime: Add new helper function: pm_runtime_active()
Date: Fri, 25 Jan 2013 00:00:43 +0100
Message-ID: <45313302.HOtnqx7V8P@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358931241-32375-1-git-send-email-shuox.liu@intel.com>
References: <1358931241-32375-1-git-send-email-shuox.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 23, 2013 04:54:01 PM shuox.liu@intel.com wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> This boolean function simply returns whether or not the runtime
> status of the device is 'active'. The typical scenario is driver
> calls pm_runtime_get firstly, then check pm_runtime_active in
> atomic environment.
> 
> Also add entry to Documentation/power/runtime.txt

Well, why not if that helps.

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
>  Documentation/power/runtime_pm.txt |    4 ++++
>  include/linux/pm_runtime.h         |    7 +++++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index 03591a7..6c9f5d9 100644
> --- a/Documentation/power/runtime_pm.txt
> +++ b/Documentation/power/runtime_pm.txt
> @@ -426,6 +426,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
>        'power.runtime_error' is set or 'power.disable_depth' is greater than
>        zero)
>  
> +  bool pm_runtime_active(struct device *dev);
> +    - return true if the device's runtime PM status is 'active' or its
> +      'power.disable_depth' field is not equal to zero, or false otherwise
> +
>    bool pm_runtime_suspended(struct device *dev);
>      - return true if the device's runtime PM status is 'suspended' and its
>        'power.disable_depth' field is equal to zero, or false otherwise
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index f271860..c785c21 100644
> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -80,6 +80,12 @@ static inline bool pm_runtime_suspended(struct device *dev)
>  		&& !dev->power.disable_depth;
>  }
>  
> +static inline bool pm_runtime_active(struct device *dev)
> +{
> +	return dev->power.runtime_status == RPM_ACTIVE
> +		|| dev->power.disable_depth;
> +}
> +
>  static inline bool pm_runtime_status_suspended(struct device *dev)
>  {
>  	return dev->power.runtime_status == RPM_SUSPENDED;
> @@ -132,6 +138,7 @@ static inline void pm_runtime_put_noidle(struct device *dev) {}
>  static inline bool device_run_wake(struct device *dev) { return false; }
>  static inline void device_set_run_wake(struct device *dev, bool enable) {}
>  static inline bool pm_runtime_suspended(struct device *dev) { return false; }
> +static inline bool pm_runtime_active(struct device *dev) { return true; }
>  static inline bool pm_runtime_status_suspended(struct device *dev) { return false; }
>  static inline bool pm_runtime_enabled(struct device *dev) { return false; }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
