Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3H1FfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 01:35:23 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45608 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab3H1FfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 01:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <521CE317.20908@semaphore.gr>
References: <521BA068.8030003@semaphore.gr>
	<CAKohpo=xBmpEv=oN1qEnq9RKhfjtc4wZayVYyVzjWOU8BnwVJQ@mail.gmail.com>
	<521CC9B8.2020801@semaphore.gr>
	<CAKohpo=XhHtRfsVrUZr0DQCK5L5zU_6DB4PBOA4QrJBvvcbe0Q@mail.gmail.com>
	<521CE317.20908@semaphore.gr>
Date: Wed, 28 Aug 2013 11:05:19 +0530
Message-ID: <CAKohpokg3xqKRmDgzeL+dZc07x1KUZ=hKdx_YrVoDbi572N_sg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governors: Remove duplicate check of target freq
 in supported range
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 27 August 2013 23:04, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> I'm sorry. Let me try to explain this better.

Don't be :)

> With my patch, dbs_info->requested_freq will not be capped within
> policy->min and policy->max in cs_check_cpu.
> So, temporarily it may have a value greater than policy->max
> or lower that policy->min.
> When we call __cpufreq_driver_target, the correct frequency will be selected
> because __cpufreq_driver_target takes care to adjust the
> target frequency within policy range.
> But, eventually, dbs_cpufreq_notifier will adjust dbs_info->requested
> within policy range, if needed.
>
> If we remove
>
>         if (dbs_info->requested_freq == policy->max)
>                 return;
> and
>
>         if (policy->cur == policy->min)
>                 return;
>
> request_freq will keep increasing or decreasing in each iteration and
> finally will overflow or underflow.
>
> Consider, for example, that in a CPU with policy->max = 1000MHz
> the current frequency is 950MHz. With a constant load above
> up_threshold, the requested_freq in first iteration will be 1000MHz
> and __cpufreq_driver_target will select 1000MHz freq.
>
> In second iteration, requested_freq will be 1050MHz, and
> __cpufreq_driver_target will select 1000MHz. dbs_cpufreq_notifier
> will adjust requested_freq back to 1000MHz.
>
> In next iterations, dbs_cpufreq_notifier will not be called, so we
> need the above check (dbs_info->requested_freq == policy->max) to
> prevent requested_freq to grow arbitrary.
>
> I hope my explanation was better now. :)

Yes, your initial patch is fine.
