Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3KLKln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:41:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3KLKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:41:40 -0500
Date: Tue, 12 Nov 2013 11:41:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        l.majewski@samsung.com
Subject: Re: [RFC][PATCH v5 07/14] sched: get CPU's activity statistic
Message-ID: <20131112104129.GH4971@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-7-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382097147-30088-7-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:52:20PM +0200, Vincent Guittot wrote:
> +static int get_cpu_activity(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	u32 sum = rq->avg.runnable_avg_sum;
> +	u32 period = rq->avg.runnable_avg_period;
> +
> +	sum = min(sum, period);
> +
> +	if (sum == period) {
> +		u32 overload = rq->nr_running > 1 ? 1 : 0;
> +		return available_of(cpu) + overload;
> +	}
> +
> +	return (sum * available_of(cpu)) / period;

I'm thinking this has a fair potential to overflow our u32, no?

> +}
