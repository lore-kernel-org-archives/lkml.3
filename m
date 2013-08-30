Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab3H3LuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:50:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44628 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3H3LuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:50:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Fu <danifu@nvidia.com>
Cc: daniel.lezcano@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, joqiu@nvidia.com
Subject: Re: [PATCH] cpuidle: Check cpuidle driver before add refcount
Date: Fri, 30 Aug 2013 14:01:02 +0200
Message-ID: <2041584.4YznqfT0Od@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1377863302-22465-1-git-send-email-danifu@nvidia.com>
References: <1377863302-22465-1-git-send-email-danifu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 30, 2013 07:48:22 PM Daniel Fu wrote:
> If the current CPU has no cpuidle driver, drv will be NULL.
> Check if we get drv successfully before add refount
> to prevent Kernel panic.

What is the actual scenario that may lead to this panic?

Rafael


> Signed-off-by: Daniel Fu <danifu@nvidia.com>
> ---
>  drivers/cpuidle/driver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index 3ac499d..6e11701 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -331,7 +331,8 @@ struct cpuidle_driver *cpuidle_driver_ref(void)
>  	spin_lock(&cpuidle_driver_lock);
>  
>  	drv = cpuidle_get_driver();
> -	drv->refcnt++;
> +	if (drv)
> +		drv->refcnt++;
>  
>  	spin_unlock(&cpuidle_driver_lock);
>  	return drv;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
