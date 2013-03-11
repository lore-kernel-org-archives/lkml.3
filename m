Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3CKXb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:31:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52932 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab3CKXbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:31:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Subject: Re: [PATCH V3 4/4] cpufreq: Add Kconfig option to enable/disable have_multiple_policies
Date: Tue, 12 Mar 2013 00:38:57 +0100
Message-ID: <1687194.MelaMkNoiM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <b3deff3c75a0ca1b687c92bf81061c3728346494.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org> <b3deff3c75a0ca1b687c92bf81061c3728346494.1362381470.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 04, 2013 03:37:56 PM Viresh Kumar wrote:
> have_multiple_policies is required by platforms having multiple clock-domains
> for cpus, i.e. supporting multiple policies for cpus. This patch adds in a
> Kconfig option for enabling execution of this code.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/Kconfig | 3 +++
>  include/linux/cpufreq.h | 4 ++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index cbcb21e..e6e6939 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -23,6 +23,9 @@ config CPU_FREQ_TABLE
>  config CPU_FREQ_GOV_COMMON
>  	bool
>  
> +config CPU_FREQ_HAVE_MULTIPLE_POLICIES
> +	bool
> +
>  config CPU_FREQ_STAT
>  	tristate "CPU frequency translation statistics"
>  	select CPU_FREQ_TABLE
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 6e1abd2..a092fcb 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -107,11 +107,13 @@ struct cpufreq_policy {
>  	unsigned int		policy; /* see above */
>  	struct cpufreq_governor	*governor; /* see below */
>  	void			*governor_data;
> +#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
>  	/* This should be set by init() of platforms having multiple
>  	 * clock-domains, i.e.  supporting multiple policies. With this sysfs
>  	 * directories of governor would be created in cpu/cpu<num>/cpufreq/
>  	 * directory */
>  	bool			have_multiple_policies;
> +#endif
>  
>  	struct work_struct	update; /* if update_policy() needs to be
>  					 * called, but you're in IRQ context */
> @@ -142,9 +144,11 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
>  static inline struct kobject *
>  get_governor_parent_kobj(struct cpufreq_policy *policy)
>  {
> +#ifdef CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES
>  	if (policy->have_multiple_policies)
>  		return &policy->kobj;
>  	else
> +#endif
>  		return cpufreq_global_kobject;
>  }

One more question before I apply it.

Is there any architecture/platform that will set
CONFIG_CPU_FREQ_HAVE_MULTIPLE_POLICIES and keep have_multiple_policies unset
at the same time?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
