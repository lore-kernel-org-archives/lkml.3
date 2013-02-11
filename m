Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3BKTgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:36:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37258 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281Ab3BKTgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:36:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Artem Savkov <artem.savkov@gmail.com>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: 64bit divide in intel_pstate_calc_busy()
Date: Mon, 11 Feb 2013 20:42:41 +0100
Message-ID: <1987087.S730EjTqbJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1360610648-6952-1-git-send-email-artem.savkov@gmail.com>
References: <1360610648-6952-1-git-send-email-artem.savkov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 11:24:08 PM Artem Savkov wrote:
> intel_pstate.c won't compile on i686 because of a linking error:
> drivers/cpufreq/intel_pstate.c:459: undefined reference to `__udivdi3'
> 
> Signed-off-by: Artem Savkov <artem.savkov@gmail.com>

I've just applied an equivalent patch from Dirk.

Thanks,
Rafael


> ---
>  drivers/cpufreq/intel_pstate.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 86ad482..dc43208 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -456,7 +456,9 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
>  	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
>  	sample->freq = cpu->pstate.turbo_pstate * core_pct * 1000;
>  
> -	sample->core_pct_busy = sample->pstate_pct_busy * core_pct / 100;
> +	sample->core_pct_busy = div64_u64(
> +					sample->pstate_pct_busy * core_pct,
> +					100);
>  }
>  
>  static inline void intel_pstate_sample(struct cpudata *cpu)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
