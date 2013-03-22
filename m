Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab3CVNQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:16:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33603 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3CVNQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:16:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-pm] cpufreq: governors: Fix calculation of wall time in get_cpu_idle_time
Date: Fri, 22 Mar 2013 14:24:11 +0100
Message-ID: <1799487.FNztk3vCxS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <514C0555.1010806@semaphore.gr>
References: <514C0555.1010806@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 09:16:37 AM Stratos Karafotis wrote:
> With commit 8755a8ae31ba213db196324011a0da2a85807f25 the wall in
> get_cpu_idle_time is not calculated, when we use ondemand with
> io_is_busy = 1, preventing the CPU to increase to max frequency.
> 
> Properly, calculate wall time when we use io_is_busy.
> 
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>

I folded the change below into the original patch.

Thanks,
Rafael


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
> -	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> +	u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
>  
>  	if (idle_time == -1ULL)
>  		return get_cpu_idle_time_jiffy(cpu, wall);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
