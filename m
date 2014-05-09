Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaEIJta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:49:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:49581 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaEIJt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:49:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1017,1389772800"; 
   d="scan'208";a="536401516"
Date: Fri, 9 May 2014 09:44:23 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, rjw@rjwysocki.net,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 4/5] intel_pstate: Remove C0 tracking
Message-ID: <20140509014422.GA9855@intel.com>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com>
 <1399579047-5792-5-git-send-email-dirk.j.brandewie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399579047-5792-5-git-send-email-dirk.j.brandewie@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

I don't get why you remove the c0 tracking.  This is my understanding wrong.

Suppose it is removed, then the objective of the PID control is:

delta(aperf) / delta(mperf) * max_pstate / current_pstate

But delta(aperf) / delta(mperf) * max_pstate is the average frequency of the last
time frame, and current_pstate is the last requested frequency, then the
objective is:

last_freq_average / last_requested_freq ==> setpoint

What does it mean, SW satisfaction of freq request? Why control that?

Thanks
Yuyang

> @@ -561,46 +559,37 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
>  					struct sample *sample)
>  {
>  	int32_t core_pct;
> -	int32_t c0_pct;
>  
>  	core_pct = div_fp(int_tofp((sample->aperf)),
>  			int_tofp((sample->mperf)));
>  	core_pct = mul_fp(core_pct, int_tofp(100));
>  	FP_ROUNDUP(core_pct);
>  
> -	c0_pct = div_fp(int_tofp(sample->mperf), int_tofp(sample->tsc));
> -
>  	sample->freq = fp_toint(
>  		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
>  
> -	sample->core_pct_busy = mul_fp(core_pct, c0_pct);
> +	sample->core_pct_busy = core_pct;
>  }
