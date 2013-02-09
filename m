Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947477Ab3BIAPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:15:34 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35622 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046Ab3BIAPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:15:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, valdis.kletnieks@vt.edu,
        artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
Date: Sat, 09 Feb 2013 01:21:53 +0100
Message-ID: <2798090.LbSjbE5OCO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51159391.2020002@gmail.com>
References: <cover.1360232293.git.viresh.kumar@linaro.org> <2792362.JXCag4GJsR@vostro.rjw.lan> <51159391.2020002@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 08, 2013 04:08:49 PM Dirk Brandewie wrote:
> On 02/08/2013 03:56 PM, Rafael J. Wysocki wrote:
> > On Friday, February 08, 2013 09:02:37 PM Rafael J. Wysocki wrote:
> >> On Friday, February 08, 2013 08:06:52 PM Viresh Kumar wrote:
> >>> On 8 February 2013 18:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>>> So as I said, please rework the fixes on top of linux-pm.git/pm-cpufreq.
> >>>
> >>> I already did. Please check for-rafael branch
> >>
> >> Cool.  This is the one I'm supposed to apply, then?
> >
> > OK, applied to bleeding-edge.  Hopefully it will be build-tested over the
> > weekend and I can move it to linux-next.
> >
> > I dropped the rwlock/RCU patches from Nathan, though, because I had some
> > doubts about the correctness of the RCU one and the rwlock one alone would
> > conflict with your further changes.
> 
> One piece of fallout from dropping Nathan patches I had rebased mine on top of 
> them.
> 
> This fixes the breakage do you want me to spin my patches or send this separately?:

No need to, I'll try to fix that in my tree.

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 0ebdf8c..a008b8e 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1024,7 +1024,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct
>                  __cpufreq_governor(data, CPUFREQ_GOV_STOP);
> 
>   #ifdef CONFIG_HOTPLUG_CPU
> -       if (!driver->setpolicy)
> +       if (!cpufreq_driver->setpolicy)
>                  strncpy(per_cpu(cpufreq_cpu_governor, cpu),
>                          data->governor->name, CPUFREQ_NAME_LEN);
>   #endif
> @@ -1771,7 +1771,7 @@ int cpufreq_update_policy(unsigned int cpu)
>                          pr_debug("Driver did not initialize current freq");
>                          data->cur = policy.cur;
>                  } else {
> -                       if (data->cur != policy.cur && driver->target)
> +                       if (data->cur != policy.cur && cpufreq_driver->target)
>                                  cpufreq_out_of_sync(cpu, data->cur,
>                                                                  policy.cur);
>                  }
> 

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
