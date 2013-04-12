Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3DLLnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:43:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56974 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab3DLLne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:43:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Axel Lin <axel.lin@ingics.com>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/3] PM / devfreq: exynos4_bus: Fix missing mutex_unlock if opp_find_freq_floor fails
Date: Fri, 12 Apr 2013 13:51:22 +0200
Message-ID: <1413655.hhUbBAKNUi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1365746058.4025.1.camel@phoenix>
References: <1365746058.4025.1.camel@phoenix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 12, 2013 01:54:18 PM Axel Lin wrote:
> We need to call mutex_unlock() in the error path.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

All three patches applied to linux-pm.git/linux-next.

Exynos maintainers, if you have any objections, please holler.

Thanks,
Rafael

> ---
>  drivers/devfreq/exynos4_bus.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 1deee09..54b9615 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -974,7 +974,8 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
>  			rcu_read_unlock();
>  			dev_err(data->dev, "%s: unable to find a min freq\n",
>  				__func__);
> -			return PTR_ERR(opp);
> +			err = PTR_ERR(opp);
> +			goto unlock;
>  		}
>  		new_oppinfo.rate = opp_get_freq(opp);
>  		new_oppinfo.volt = opp_get_voltage(opp);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
