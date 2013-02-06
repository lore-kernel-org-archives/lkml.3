Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3BFCqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:46:34 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60082 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3BFCqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:46:31 -0500
MIME-Version: 1.0
In-Reply-To: <5111C09D.7020007@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-3-git-send-email-dirk.brandewie@gmail.com>
	<CAOh2x=nYOf32jKqwwikgBS2oRHwmhZdVug=pLzQZWp-N2S9CGw@mail.gmail.com>
	<5111BCDA.1060507@gmail.com>
	<CAOh2x=k8EwdrMzE2qQ+vat47WcmVHzJhZjntPnqNwMqAqibXVQ@mail.gmail.com>
	<5111C09D.7020007@gmail.com>
Date: Wed, 6 Feb 2013 08:16:30 +0530
Message-ID: <CAKohpomYs_qmzHDHLsxE1wN68e71nuL92--UZsk9jqSZDa9pcQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 February 2013 08:01, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2817c3c..7516b7d 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1178,9 +1178,14 @@ static void cpufreq_out_of_sync(unsigned int cpu,
> unsigned int old_freq,
>   */
>
>  unsigned int cpufreq_quick_get(unsigned int cpu)
>  {
> -       struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> +       struct cpufreq_policy *policy;
>
>         unsigned int ret_freq = 0;
>
> +       if (cpufreq_driver && cpufreq_driver->setpolicy &&
> +                       cpufreq_driver->get)
> +                       return cpufreq_driver->get(cpu);
> +
> +       policy = cpufreq_cpu_get(cpu);
>         if (policy) {
>                 ret_freq = policy->cur;
>                 cpufreq_cpu_put(policy);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
