Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbaCYE2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 00:28:49 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:35464 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCYE2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 00:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <1395672089-19336-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1395672089-19336-1-git-send-email-dirk.j.brandewie@intel.com>
Date: Tue, 25 Mar 2014 09:58:46 +0530
X-Google-Sender-Auth: VKl771Gs-TIc0RBB6hQFLJr-pV8
Message-ID: <CAOh2x=m9C77gYFbxQ1fn-ebQdL58OhY60rXq6WHyTR4Wau7_QA@mail.gmail.com>
Subject: Re: [PATCH] intel_pstate: Use del_timer_sync in intel_pstate_cpu_stop
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 8:11 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> Ensure that no timer callback is running since we are about to free
> the timer structure.  We cannot guarantee that the call back is called
> on the CPU where the timer is running.
>
> Reported-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: cpufreq <cpufreq@vger.kernel.org>
> ---
>  drivers/cpufreq/intel_pstate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index e9092fd..a4a9ba5 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -780,7 +780,7 @@ static int intel_pstate_cpu_stop(struct cpufreq_policy *policy)
>
>         pr_info("intel_pstate CPU %d exiting\n", cpu_num);
>
> -       del_timer(&all_cpu_data[cpu_num]->timer);
> +       del_timer_sync(&all_cpu_data[cpu_num]->timer);
>         intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
>         kfree(all_cpu_data[cpu_num]);
>         all_cpu_data[cpu_num] = NULL;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
