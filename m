Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbaKUMfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:35:04 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36577 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317AbaKUMfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:35:02 -0500
Date: Fri, 21 Nov 2014 12:35:44 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>
Subject: Re: [PATCH v9 04/10] sched: Make sched entity usage tracking
 scale-invariant
Message-ID: <20141121123544.GE23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:41PM +0000, Vincent Guittot wrote:
> From: Morten Rasmussen <morten.rasmussen@arm.com>
> 
> Apply frequency scale-invariance correction factor to usage tracking.

s/usage/utilization/

> Each segment of the running_load_avg geometric series is now scaled by the
> current frequency so the utilization_avg_contrib of each entity will be

s/entity/sched_entity/

> invariant with frequency scaling. As a result, utilization_load_avg which is
> the sum of utilization_avg_contrib, becomes invariant too. So the usage level

s/sum of utilization_avg_contrib/sum of sched_entity
utilization_avg_contribs/

s/usage/utilization/

> that is returned by get_cpu_usage, stays relative to the max frequency as the
> cpu_capacity which is is compared against.

The last bit doesn't parse right. '... Maybe it is better to drop
the reference to get_cpu_usage which hasn't been defined yet and rewrite
the thing to:

Apply frequency scale-invariance correction factor to utilization
tracking. Each segment of the running_load_avg geometric series is now
scaled by the current frequency so the utilization_avg_contrib of each
entity will be invariant with frequency scaling. As a result,
utilization_load_avg which is the sum of sched_entity
utilization_avg_contribs becomes invariant too and is now relative to
the max utilization at the max frequency (=cpu_capacity).

I think we should add:

arch_scale_freq_capacity() is reintroduced to provide the frequency
compensation scaling factor.

> Then, we want the keep the load tracking values in a 32bits type, which implies

s/Then, we/We/

