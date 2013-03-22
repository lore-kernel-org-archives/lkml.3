Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3CVLjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:39:54 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:46196 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3CVLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:39:52 -0400
MIME-Version: 1.0
In-Reply-To: <514C0555.1010806@semaphore.gr>
References: <514C0555.1010806@semaphore.gr>
Date: Fri, 22 Mar 2013 17:09:51 +0530
X-Google-Sender-Auth: Ak2LKoWQ80QvViXu5FyeJSgx9Ak
Message-ID: <CAOh2x=kwt918pdOMDYAVB7qEP2o57cnKH8AR6p_gwHOgc0AywA@mail.gmail.com>
Subject: Re: [PATCH linux-pm] cpufreq: governors: Fix calculation of wall time
 in get_cpu_idle_time
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 12:46 PM, Stratos Karafotis
<stratosk@semaphore.gr> wrote:
> With commit 8755a8ae31ba213db196324011a0da2a85807f25 the wall in
> get_cpu_idle_time is not calculated, when we use ondemand with
> io_is_busy = 1, preventing the CPU to increase to max frequency.
>
> Properly, calculate wall time when we use io_is_busy.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/cpufreq_governor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index b49d45d..41e5e56 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -53,7 +53,7 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
>
>  u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
>  {
> -       u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> +       u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
>
>         if (idle_time == -1ULL)
>                 return get_cpu_idle_time_jiffy(cpu, wall);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
