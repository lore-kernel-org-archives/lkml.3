Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab3CZMus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:50:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34963
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757894Ab3CZMur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:50:47 -0400
Message-ID: <1364302242.5053.19.camel@laptop>
Subject: Re: [RFC PATCH v3 4/6] sched: secure access to other CPU statistics
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
Date: Tue, 26 Mar 2013 13:50:42 +0100
In-Reply-To: <1363955155-18382-5-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-5-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
> @@ -3364,13 +3364,16 @@ done:
>  static bool is_buddy_busy(int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
> +       u32 sum = rq->avg.runnable_avg_sum;
> +       u32 period = rq->avg.runnable_avg_period;
> +
> +       sum = min(sum, period);

OK this makes sense; use a simple sanity constraint instead of going
overboard on serialization -- however, why is this a separate patch?

That is, this could easily be part of the patch that introduces
is_buddy_busy(); also you likely want part of this patch's changelog
to become a comment that goes right above this min() :-)

