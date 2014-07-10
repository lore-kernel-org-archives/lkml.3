Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaGJNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:16:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33671 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaGJNQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:16:57 -0400
Date: Thu, 10 Jul 2014 15:16:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140710131646.GB3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 06:05:40PM +0200, Vincent Guittot wrote:
> This reverts commit f5f9739d7a0ccbdcf913a0b3604b134129d14f7e.
> 
> We are going to use runnable_avg_sum and runnable_avg_period in order to get
> the utilization of the CPU. This statistic includes all tasks that run the CPU
> and not only CFS tasks.

But this rq->avg is not the one that is migration aware, right? So why
use this?

We already compensate cpu_capacity for !fair tasks, so I don't see why
we can't use the migration aware one (and kill this one as Yuyang keeps
proposing) and compensate with the capacity factor.
