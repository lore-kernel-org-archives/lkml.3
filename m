Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaJJJQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 05:16:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:45188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaJJJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 05:16:22 -0400
Date: Fri, 10 Oct 2014 11:16:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Yuyang Du <yuyang.du@intel.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20141010091621.GG10832@worktop.programming.kicks-ass.net>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <20141008005007.GA7017@intel.com>
 <54353422.3070002@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54353422.3070002@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 01:54:58PM +0100, Dietmar Eggemann wrote:

> > But this should be very hard. Intel Architecture has limitation to capture all
> > the freq changes in software and also the intel_pstate should have no
> > notification.
> 
> We encountered this missing notification for current frequency with
> Intel systems (e.g. i5-3320M) using the intel_pstate driver while
> testing this patch-set. The arch_scale_set_curr_freq call in
> __cpufreq_notify_transition [[PATCH 2/7] cpufreq: Architecture specific
> callback for frequency changes] will not work on such a system.
> 
> In our internal testing, we placed arch_scale_set_curr_freq(cpu->cpu,
> sample->freq) into intel_pstate_timer_func [intel_pstate.c] to get the
> current frequency for a cpu.
> 
> The arch_scale_set_max_freq call in cpufreq_set_policy
> [drivers/cpufreq/cpufreq.c] still works although the driver exposes the
> max turbo pstate and not the max pstate. That's an additional problem
> because we don't want to use turbo states for frequency scaling.

Right, so when we pull the policy part into the scheduler, intel_pstate
will revert to just another driver without such logic and things should
just work.

But yes, currently it also implements policy, that needs to go away.
