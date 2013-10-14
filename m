Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3JNNs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:48:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57102 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab3JNNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:48:27 -0400
Date: Mon, 14 Oct 2013 15:48:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: mingo@kernel.org, pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 3/7] sched: power: go_faster/slower power driver
 hints
Message-ID: <20131014134809.GE28601@twins.programming.kicks-ass.net>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 06:19:13PM +0100, Morten Rasmussen wrote:
> +static inline void inc_cpu_capacity(int cpu)
> +{
> +	if (weighted_cpuload(cpu) > power_of(cpu))
> +		go_faster(cpu, 0);
> +}
> +
> +static inline void dec_cpu_capacity(int cpu)
> +{
> +	if (weighted_cpuload(cpu) < power_of(cpu))
> +		go_slower(cpu, 0);
> +}

It seems wrong to me to use weighted_cpuload() here; that contains the
task weight, which is irrelevant to power usage. I would expect a pure
utilization term here.

Something like:

  se->avg.runnable_avg_sum / se->avg.runnable_avg_period


