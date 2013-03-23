Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770Ab3CWAHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:07:17 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34767 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422650Ab3CWAHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:07:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Fix calculation of current frequency
Date: Sat, 23 Mar 2013 01:14:35 +0100
Message-ID: <2316804.ObH9JhORys@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363974665-22049-1-git-send-email-dirk.brandewie@gmail.com>
References: <1363974665-22049-1-git-send-email-dirk.brandewie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 10:51:05 AM dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Use the correct pstate value to calculate the effective frequency.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=923942
> Reported-by: Satish Balay <balay@fastmail.fm>
> 
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

Well, another quick fix for v3.9 I suppose?

May I please be sent CCs of such things to at least one of my addresses?

Rafael


> ---
>  drivers/cpufreq/intel_pstate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index e84af66..ad72922 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -454,7 +454,7 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
>  					sample->idletime_us * 100,
>  					sample->duration_us);
>  	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
> -	sample->freq = cpu->pstate.turbo_pstate * core_pct * 1000;
> +	sample->freq = cpu->pstate.max_pstate * core_pct * 1000;
>  
>  	sample->core_pct_busy = div_s64((sample->pstate_pct_busy * core_pct),
>  					100);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
