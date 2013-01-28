Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3A1JwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:52:19 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41842 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3A1JwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:52:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130128094957.GA6109@pd.tnic>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
	<1358677470-17394-5-git-send-email-bp@alien8.de>
	<CAOh2x==qf057z2vmADd6+thaXXVxEh1GZO-sKHRDyosqTfMdng@mail.gmail.com>
	<20130128094957.GA6109@pd.tnic>
Date: Mon, 28 Jan 2013 15:22:13 +0530
Message-ID: <CAKohpo=F5R7oG_xEopChLMqGo6umH0zqnknv_NJKA_TKDaSgjw@mail.gmail.com>
Subject: Re: [PATCH 4/6] cpufreq: Add a get_current_driver helper
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Andr=E9_Przywara?= <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2013 15:19, Borislav Petkov <bp@alien8.de> wrote:
> Which one would you suggest: CPUFREQ DRIVER INTERFACE?

Yes.

> Btw, this function type splitting looks kinda silly to me. In that same
> section there are two which clearly don't belong there:
>
> struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
> void   cpufreq_cpu_put(struct cpufreq_policy *data);
>
> since they don't have anything to do with freq_table. And since they
> return cpufreq_policy, they should be maybe called:
>
> cpufreq_get_cpu_policy
> cpufreq_put_cpu_policy
>
> or something more expressive, pertaining to what they actually do. But
> they actually get/put the module (inc/dec the module's refcount) *and*
> return the cpufreq_policy... whatever, I don't care that much so see
> below.

Agree.

> --
> From 830eb9ebc715d329229772d11332c50dfd1d9330 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bp@suse.de>
> Date: Mon, 28 Jan 2013 10:38:33 +0100
> Subject: [PATCH] cpufreq: Sort function prototypes properly
>
> Move function prototypes to a place where they logically fit better.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  include/linux/cpufreq.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index a018da2d2a7c..f33ace57adb6 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -308,6 +308,9 @@ __ATTR(_name, 0444, show_##_name, NULL)
>  static struct global_attr _name =              \
>  __ATTR(_name, 0644, show_##_name, store_##_name)
>
> +struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
> +void   cpufreq_cpu_put(struct cpufreq_policy *data);
> +const char *cpufreq_get_current_driver(void);
>
>  /*********************************************************************
>   *                        CPUFREQ 2.6. INTERFACE                     *
> @@ -397,8 +400,6 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>
>  /* the following 3 funtions are for cpufreq core use only */
>  struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
> -struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
> -void   cpufreq_cpu_put(struct cpufreq_policy *data);
>
>  /* the following are really really optional */
>  extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
> @@ -407,5 +408,4 @@ void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
>                                       unsigned int cpu);
>
>  void cpufreq_frequency_table_put_attr(unsigned int cpu);
> -extern const char *cpufreq_get_current_driver(void);
>  #endif /* _LINUX_CPUFREQ_H */

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
