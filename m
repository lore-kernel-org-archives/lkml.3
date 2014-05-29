Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbaE2Nz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:55:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaE2NzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:55:22 -0400
Date: Thu, 29 May 2014 15:55:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
Message-ID: <20140529135510.GG11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
> The scheduler tries to compute how many tasks a group of CPUs can handle by
> assuming that a task's load is SCHED_LOAD_SCALE and a CPU capacity is
> SCHED_POWER_SCALE.
> We can now have a better idea of the utilization of a group fo CPUs thanks to
> group_actitvity and deduct how many capacity is still available.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---

Right, so as Preeti already mentioned, this wrecks SMT. It also seems to
loose the aggressive spread, where we want to run 1 task on each 'core'
before we start 'balancing'.

So I think we should be able to fix this by setting PREFER_SIBLING on
the SMT domain, that way we'll get single tasks running on each SMT
domain before filling them up until capacity.

Now, its been a while since I looked at PREFER_SIBLING, and I've not yet
looked at what your patch does to it, but it seems to me that that is
the first direction we should look for an answer to this.
