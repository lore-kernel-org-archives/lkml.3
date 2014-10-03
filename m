Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbaJCPii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:38:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:34690 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaJCPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:38:30 -0400
Date: Fri, 3 Oct 2014 17:38:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com
Subject: Re: [PATCH v6 5/6] sched: replace capacity_factor by usage
Message-ID: <20141003153826.GM2849@worktop.programming.kicks-ass.net>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411488485-10025-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:08:04PM +0200, Vincent Guittot wrote:

> This implementation of utilization_avg_contrib doesn't solve the scaling
> in-variance problem, so i have to scale the utilization with original
> capacity of the CPU in order to get the CPU usage and compare it with the
> capacity. Once the scaling invariance will have been added in
> utilization_avg_contrib, we will remove the scale of utilization_avg_contrib
> by cpu_capacity_orig in get_cpu_usage. But the scaling invariance will come
> in another patchset.

I would have expected this in the previous patch that introduced that
lot. Including a few words on how/why the cpu_capacity is a 'good'
approximation etc..

> Finally, the sched_group->sched_group_capacity->capacity_orig has been removed
> because it's more used during load balance.

That sentence is a contradiction, I expect there's a negative gone
missing someplace.
