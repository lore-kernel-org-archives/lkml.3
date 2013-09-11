Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3IKIox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:44:53 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:44349 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3IKIov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <1378883105-1411-1-git-send-email-tianyu.lan@intel.com>
References: <1378883105-1411-1-git-send-email-tianyu.lan@intel.com>
Date: Wed, 11 Sep 2013 14:14:50 +0530
Message-ID: <CAKohponmAkQ2GA22Aaqh1tAfkLJxd873DaEvjmVnFcrLdS3-=g@mail.gmail.com>
Subject: Re: [PATCH] Cpufreq: Acquire read lock in the cpufreq_policy_restore()
 rather than write lock
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2013 12:35,  <tianyu.lan@intel.com> wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
>
> In the cpufreq_policy_restore(), policy before system suspend is read from
> from percpu's cpufreq_cpu_data_fallback. It's read operation rather than
> write operation. So convert write lock to read lock
>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 81ceea6..b762f9b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -912,11 +912,11 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
>         struct cpufreq_policy *policy;
>         unsigned long flags;
>
> -       write_lock_irqsave(&cpufreq_driver_lock, flags);
> +       read_lock_irqsave(&cpufreq_driver_lock, flags);
>
>         policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
>
> -       write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> +       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
>         return policy;
>  }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
