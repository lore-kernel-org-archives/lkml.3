Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3GEAtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:49:43 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35065 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3GEAtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1372951039-10375-2-git-send-email-k.krivyakin@samsung.com>
References: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
	<1372951039-10375-2-git-send-email-k.krivyakin@samsung.com>
Date: Fri, 5 Jul 2013 09:49:41 +0900
X-Google-Sender-Auth: -1hBVTGjf4jfRkNNgNkqkwZacWY
Message-ID: <CAH9JG2X5ABaGG5J_DaynVteqDazQ2CkTMo5JBsWY77nGCR=XOQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] Add interface to receive current cpu power
From: Kyungmin Park <kmpark@infradead.org>
To: Konstantin Krivyakin <k.krivyakin@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, viresh.kumar@linaro.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>
Cc: i.zhbanov@samsung.com, e.voevodin@samsung.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ cpufreq maintainers

On Fri, Jul 5, 2013 at 12:17 AM, Konstantin Krivyakin
<k.krivyakin@samsung.com> wrote:
> Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
> ---
>  drivers/cpufreq/cpufreq.c |   17 +++++++++++++++++
>  include/linux/cpufreq.h   |    6 ++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6a015ad..4180e89 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1538,6 +1538,23 @@ int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list)
>  }
>  EXPORT_SYMBOL(cpufreq_unregister_notifier);
>
> +/**
> + * cpu_power_get - get current CPU power
> + * @cpu: CPU number
> + */
> +u64 cpu_power_get(int cpu)
> +{
> +       struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> +       u64 ret_power = 0;
> +
> +       if (policy) {
> +               ret_power = policy->current_power;
> +               cpufreq_cpu_put(policy);
> +       }
> +
> +       return ret_power;
> +}
> +EXPORT_SYMBOL(cpu_power_get);
>
>  /*********************************************************************
>   *                              GOVERNORS                            *
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4d7390b..67323af 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -107,6 +107,7 @@ struct cpufreq_policy {
>         unsigned int            max;    /* in kHz */
>         unsigned int            cur;    /* in kHz, only needed if cpufreq
>                                          * governors are used */
> +       u64                     current_power;
>         unsigned int            policy; /* see above */
>         struct cpufreq_governor *governor; /* see below */
>         void                    *governor_data;
> @@ -365,6 +366,7 @@ static inline unsigned int cpufreq_get(unsigned int cpu)
>  #ifdef CONFIG_CPU_FREQ
>  unsigned int cpufreq_quick_get(unsigned int cpu);
>  unsigned int cpufreq_quick_get_max(unsigned int cpu);
> +u64 cpu_power_get(int cpu);
>  #else
>  static inline unsigned int cpufreq_quick_get(unsigned int cpu)
>  {
> @@ -374,6 +376,10 @@ static inline unsigned int cpufreq_quick_get_max(unsigned int cpu)
>  {
>         return 0;
>  }
> +static inline u64 cpu_power_get(unsigned int cpu)
> +{
> +       return 0;
> +}
>  #endif
>
>  /*********************************************************************
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
