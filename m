Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaJ1O2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:28:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaJ1O2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:28:05 -0400
Date: Tue, 28 Oct 2014 15:27:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com, riel@redhat.com,
        efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, patches@linaro.org,
        tuukka.tikkanen@linaro.org, amit.kucheria@linaro.org
Subject: Re: [PATCH RFC 7/7] sched: energy_model: simple cpu frequency
 scaling policy
Message-ID: <20141028142749.GO3219@twins.programming.kicks-ass.net>
References: <1413958051-7103-1-git-send-email-mturquette@linaro.org>
 <1413958051-7103-8-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413958051-7103-8-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:07:31PM -0700, Mike Turquette wrote:
> Unlike legacy CPUfreq governors, this policy does not implement its own
> logic loop (such as a workqueue triggered by a timer), but instead uses
> an event-driven design. Frequency is evaluated by entering
> {en,de}queue_task_fair and then a kthread is woken from
> run_rebalance_domains which scales cpu frequency based on the latest
> evaluation.

Also note that we probably want to extend the governor to include the
other sched classes, deadline for example is a good candidate to include
as it already explicitly provides utilization requirements from which
you can compute a hard minimum frequency, below which the task set is
unschedulable.

fifo/rr are far harder to do, since for them we don't have anything
useful, the best we can do I suppose is some statistical over
provisioning but no guarantees.


