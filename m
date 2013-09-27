Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3I0L5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 07:57:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49719 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3I0L52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 07:57:28 -0400
Date: Fri, 27 Sep 2013 13:57:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [tip:sched/core] sched: Add NEED_RESCHED to the preempt_count
Message-ID: <20130927115722.GM3657@laptop.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
 <20130927091427.GE24743@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927091427.GE24743@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:14:27PM +0800, Yuanhan Liu wrote:
> On Wed, Sep 25, 2013 at 09:38:38AM -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  f27dde8deef33c9e58027df11ceab2198601d6a6
> > Gitweb:     http://git.kernel.org/tip/f27dde8deef33c9e58027df11ceab2198601d6a6
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Wed, 14 Aug 2013 14:55:31 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Wed, 25 Sep 2013 14:07:49 +0200
> > 
> > sched: Add NEED_RESCHED to the preempt_count
> 
> Hi Peter,
> 
> FYI, here we found a pigz regression by this commit.

I just can't help myself; but pigs aren't supposed to fly anyway! :-)

> Here is a list all of changed stats by this commit and it's parent 4a2b4b222743bb07fedf985b884550f2ca067ea9:
> 
> time.involuntary_context_switches                                          [ 3184       - 4753       ]     [ 5.536e+05  - 5.9042e+05 ]
> time.voluntary_context_switches                                            [ 84559      - 1.2223e+05 ]     [ 1.1008e+07 - 1.1092e+07 ]

Gah, that looks like it completely wrecked preemptions.

What kind of PREEMPT Kconfig options do you use? Or rather; could you
attach your .config?
