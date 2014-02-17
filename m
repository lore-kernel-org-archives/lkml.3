Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaBQAHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:07:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51711 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752378AbaBQAHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:07:01 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pierre-list@ossman.eu
Subject: Re: [PATCH 2/2] cpufreq: don't call cpufreq_update_policy() on CPU addition
Date: Mon, 17 Feb 2014 01:21:47 +0100
Message-ID: <1725957.nHPERWcMfN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <8f2fc4d6240b567fdb69a0b47f073d174b7ef9b2.1392375504.git.viresh.kumar@linaro.org>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org> <8f2fc4d6240b567fdb69a0b47f073d174b7ef9b2.1392375504.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 14, 2014 04:30:41 PM Viresh Kumar wrote:
> cpufreq_update_policy() is called from two places currently. From a workqueue
> handled queued from cpufreq_bp_resume() for boot CPU and from
> cpufreq_cpu_callback() whenever a CPU is added.
> 
> The first one makes sure that boot CPU is running on the frequency present in
> policy->cpu. But we don't really need a call from cpufreq_cpu_callback(),
> because we always call cpufreq_driver->init() (which will set policy->cur
> correctly) whenever first CPU of any policy is added back. And so every policy
> structure is guaranteed to have the right frequency in policy->cur.

That sounds good, but doing the extra cpufreq_update_policy() shouldn't actually
hurt, should it?

So, that would be a cleanup rather than a fix, right?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 383362b..b6eb4ed 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2194,7 +2194,6 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
>  		switch (action & ~CPU_TASKS_FROZEN) {
>  		case CPU_ONLINE:
>  			__cpufreq_add_dev(dev, NULL, frozen);
> -			cpufreq_update_policy(cpu);
>  			break;
>  
>  		case CPU_DOWN_PREPARE:
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
