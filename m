Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3IKKI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:08:29 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:60442 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3IKKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <522FE369.3030106@intel.com>
References: <1378824287-7696-1-git-send-email-tianyu.lan@intel.com>
	<CAKohponpX9AedBrsASojK7fKS-rRN-AQwJT42=mrOJcNpGqE+w@mail.gmail.com>
	<522FE369.3030106@intel.com>
Date: Wed, 11 Sep 2013 15:38:25 +0530
Message-ID: <CAKohponyaogXLr5sJzQbb6ZhswMWfwhFTm-b=4Ztzg=UmKx_ig@mail.gmail.com>
Subject: Re: [PATCH 1/1] Cpufreq: Remove fossil comment of cpufreq_set_policy
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2013 08:58, Lan Tianyu <tianyu.lan@intel.com> wrote:
> From 668e1b6fd94b5c0e56a651b4c60cbbc7a6868b46 Mon Sep 17 00:00:00 2001
> From: Lan Tianyu <tianyu.lan@intel.com>
> Date: Wed, 11 Sep 2013 11:31:15 +0800
> Subject: [PATCH] Cpufreq/governor: Remove fossil comment
>
> cpufreq_set_policy() has been changed to origin __cpufreq_set_policy()
> and policy->lock has been converted to rewrite lock by commit 5a01f2.
> So remove it.
>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/cpufreq/cpufreq_userspace.c | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_userspace.c
> b/drivers/cpufreq/cpufreq_userspace.c
> index 0307809..4dbf1db 100644
> --- a/drivers/cpufreq/cpufreq_userspace.c
> +++ b/drivers/cpufreq/cpufreq_userspace.c
> @@ -38,18 +38,7 @@ static int cpufreq_set(struct cpufreq_policy *policy,
> unsigned int freq)
>         if (!per_cpu(cpu_is_managed, policy->cpu))
>                 goto err;
>
> -       /*
> -        * We're safe from concurrent calls to ->target() here
> -        * as we hold the userspace_mutex lock. If we were calling
> -        * cpufreq_driver_target, a deadlock situation might occur:
> -        * A: cpufreq_set (lock userspace_mutex) ->
> -        *      cpufreq_driver_target(lock policy->lock)
> -        * B: cpufreq_set_policy(lock policy->lock) ->
> -        *      __cpufreq_governor ->
> -        *         cpufreq_governor_userspace (lock userspace_mutex)
> -        */
>         ret = __cpufreq_driver_target(policy, freq, CPUFREQ_RELATION_L);
> -
>   err:
>         mutex_unlock(&userspace_mutex);
>         return ret;

Looks fine:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
