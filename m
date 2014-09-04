Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaIDGo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:44:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:44518 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbaIDGoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:44:20 -0400
Date: Thu, 4 Sep 2014 08:39:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140904063914.GF3190@worktop.ger.corp.intel.com>
References: <20140603141659.GO30445@twins.programming.kicks-ass.net>
 <538E840D.2040300@cn.fujitsu.com>
 <20140604064946.GF30445@twins.programming.kicks-ass.net>
 <538ED7EB.5050303@cn.fujitsu.com>
 <20140604093907.GC11096@twins.programming.kicks-ass.net>
 <53904C6B.90001@cn.fujitsu.com>
 <20140606133629.GP13930@laptop.programming.kicks-ass.net>
 <5403E237.2000708@cn.fujitsu.com>
 <20140903151531.GP4783@worktop.ger.corp.intel.com>
 <5407CCD0.2090907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5407CCD0.2090907@cn.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 10:22:08AM +0800, Lai Jiangshan wrote:
> >  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
> > -	if (task_on_rq_queued(p)) {
> > +	if (task_on_rq_queued(p) || p->state == TASK_WAKING) {
> 
> unrelated question: why we have to stop the cpu even the task is
> not running?

Strictly speaking not needed I suppose; I suppose this was done to
reduce complexity. Setting affinity is a rare operation after all.

Maybe Ingo can remember, this is certainly from before I started poking
at things.. :-)
