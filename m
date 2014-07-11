Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaGKN5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:57:02 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbaGKN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:56:59 -0400
Date: Fri, 11 Jul 2014 15:56:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [tip:sched/core] sched/numa: Use effective_load() to balance
 NUMA loads
Message-ID: <20140711135653.GI20603@laptop.programming.kicks-ass.net>
References: <1403538378-31571-3-git-send-email-riel@redhat.com>
 <tip-6dc1a672ab15604947361dcd02e459effa09bad5@git.kernel.org>
 <53BD677B.9050907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD677B.9050907@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:02:03PM -0400, Rik van Riel wrote:
> On 07/05/2014 06:44 AM, tip-bot for Rik van Riel wrote:
> > Commit-ID:  6dc1a672ab15604947361dcd02e459effa09bad5
> > Gitweb:     http://git.kernel.org/tip/6dc1a672ab15604947361dcd02e459effa09bad5
> > Author:     Rik van Riel <riel@redhat.com>
> > AuthorDate: Mon, 23 Jun 2014 11:46:14 -0400
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sat, 5 Jul 2014 11:17:35 +0200
> > 
> > sched/numa: Use effective_load() to balance NUMA loads
> > 
> > When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
> > on a CPU is determined by the group the task is in. The active groups
> > on the source and destination CPU can be different, resulting in a
> > different load contribution by the same task at its source and at its
> > destination. As a result, the load needs to be calculated separately
> > for each CPU, instead of estimated once with task_h_load().
> > 
> > Getting this calculation right allows some workloads to converge,
> > where previously the last thread could get stuck on another node,
> > without being able to migrate to its final destination.
> 
> Self-NAK
> 
> This patch should be reverted.
> 
> It turns out that the tree I am working on was missing
> changeset a003a25b227d59ded9197ced109517f037d01c27,
> which makes weighted_cpuload and update_numa_stats use
> p->se.avg.load_avg_contrib instead of p->se.load.weight.
> 
> This means using effective_load, which operates on the
> load.weight is inappropriate.
> 
> Sorry for the noise.

n/p I'll take it out. Thanks!
