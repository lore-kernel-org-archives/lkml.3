Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877Ab3BBFlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:41:10 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61469 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3BBFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:41:08 -0500
MIME-Version: 1.0
In-Reply-To: <1359744343-18690-9-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744343-18690-9-git-send-email-dirk.brandewie@gmail.com>
Date: Sat, 2 Feb 2013 11:11:07 +0530
X-Google-Sender-Auth: sU7U5cLJCSERH_fncWdcjTPuS5o
Message-ID: <CAOh2x=mU8+mJmr=BXjSLaz7Yxg--t2mPpsc_=Xry2ArNroB8Aw@mail.gmail.com>
Subject: Re: [PATCH 5/6] cpufreq: balance out cpufreq_cpu_{get,put} for
 scaling drivers using setpolicy
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 12:15 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> There is an additional reference added to the driver in
> cpufreq_add_dev_policy() that is removed in__cpufreq_governor() if the
> driver implements target().  Remove the last reference when the driver
> implements setpolicy()
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Rebase it on latest work as cpufreq_add_dev_policy() doesn't exist anymore.

> ---
>  drivers/cpufreq/cpufreq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index a4fd51e..ec103bf 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1119,6 +1119,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>         if (cpufreq_driver->target)
>                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>
> +       if (cpufreq_driver->setpolicy)
> +               cpufreq_cpu_put(data);
> +
>         kobj = &data->kobj;
>         cmp = &data->kobj_unregister;
>         unlock_policy_rwsem_write(cpu);
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
