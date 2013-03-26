Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3CZM0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:26:32 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34867
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148Ab3CZM0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:26:31 -0400
Message-ID: <1364300782.5053.6.camel@laptop>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Date: Tue, 26 Mar 2013 13:26:22 +0100
In-Reply-To: <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
> +static bool is_buddy_busy(int cpu)
> +{
> +       struct rq *rq = cpu_rq(cpu);
> +
> +       /*
> +        * A busy buddy is a CPU with a high load or a small load with
> a lot of
> +        * running tasks.
> +        */
> +       return (rq->avg.runnable_avg_sum >
> +                       (rq->avg.runnable_avg_period / (rq->nr_running
> + 2)));
> +}

Why does the comment talk about load but we don't see it in the
equation. Also, why does nr_running matter at all? I thought we'd
simply bother with utilization, if fully utilized we're done etc..

