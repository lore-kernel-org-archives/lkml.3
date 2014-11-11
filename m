Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaKKRa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:30:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaKKRa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:30:26 -0500
Date: Tue, 11 Nov 2014 18:30:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Shilpasri G Bhat <shilpa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        mturquette@linaro.org, amit.kucheria@linaro.org,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        mingo@kernel.org, linaro-kernel@lists.linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [RFC 1/2] sched/fair: Add cumulative average of load_avg_contrib
 to a task
Message-ID: <20141111173023.GP10501@worktop.programming.kicks-ass.net>
References: <1415598358-26505-1-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <1415598358-26505-2-git-send-email-shilpa.bhat@linux.vnet.ibm.com>
 <20141110134911.GG29390@twins.programming.kicks-ass.net>
 <546222C7.2030000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546222C7.2030000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 08:22:55PM +0530, Shilpasri G Bhat wrote:
> On 11/10/2014 07:19 PM, Peter Zijlstra wrote:
> > It it broken because who says rq->prev still exists?
> 
> 'task_cumulative_load()' is handled by the cpufreq governor's kworker.
> And the kworker is queued only if there is task running on cpu which
> guarantees the existence of rq->prev in a running state.

Not so, there is no guarantee it will still be running by the time the
kworker actually comes around to running.
