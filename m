Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3CKXVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:21:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52891 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab3CKXVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:21:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] workqueue: define mod_scheduled_delayed_work[_on]() helpers
Date: Tue, 12 Mar 2013 00:28:18 +0100
Message-ID: <1725153.RTNj7Pf8GC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
References: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 27, 2013 04:59:10 PM Viresh Kumar wrote:
> The only difference between schedule_delayed_work[_on]() and
> queue_delayed_work[_on]() is the workqueue, work is scheduled on. We may need to
> modify the delay for works queued with schedule_delayed_work[_on]() calls and
> thus adding these helpers.
> 
> First users of these new helpers is cpufreq governors which need to modify the
> delay for its works.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Do I assume correctly that you have withdrawn this patch?

Rafael


> ---
>  include/linux/workqueue.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 2b58905..864c2b3 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -412,6 +412,7 @@ extern bool schedule_delayed_work_on(int cpu, struct delayed_work *work,
>  extern bool schedule_delayed_work(struct delayed_work *work,
>  				  unsigned long delay);
>  extern int schedule_on_each_cpu(work_func_t func);
> +
>  extern int keventd_up(void);
>  
>  int execute_in_process_context(work_func_t fn, struct execute_work *);
> @@ -465,6 +466,11 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
>  long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
>  #endif /* CONFIG_SMP */
>  
> +#define mod_scheduled_delayed_work_on(cpu, dwork, delay)	\
> +	mod_delayed_work_on(cpu, system_wq, dwork, delay)
> +#define mod_scheduled_delayed_work(dwork, delay)		\
> +	mod_delayed_work(system_wq, dwork, delay)
> +
>  #ifdef CONFIG_FREEZER
>  extern void freeze_workqueues_begin(void);
>  extern bool freeze_workqueues_busy(void);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
