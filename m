Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaE0O12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:27:28 -0400
Received: from [198.137.202.9] ([198.137.202.9]:60871 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbaE0O10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:27:26 -0400
Date: Tue, 27 May 2014 16:26:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140527142637.GB19143@laptop.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
 <20140516162945.GZ11096@twins.programming.kicks-ass.net>
 <53849EB7.9090302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53849EB7.9090302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 10:18:31AM -0400, Jason J. Herne wrote:
> On 05/16/2014 12:29 PM, Peter Zijlstra wrote:
> >On Sat, May 17, 2014 at 12:18:06AM +0800, Lai Jiangshan wrote:
> >>so the scheduler/set_cpus_allowed_ptr()/cpu_active_mask should be the first
> >>place to fix.
> >
> >I'm not arguing about that, not to mention that this is userspace
> >exposed and nobody protects that.
> >
> >But I was expecting kernel stuff that calls it on hotplug to be
> >serialized thusly, but apparently not so.
> >
> 
> Was a final patch posted for this issue? The discussion made it sound like
> there were still a few things to figure out before we could resolve this
> bug. I can recreate this as needed and I'm happy to test any patches.


https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=sched/urgent&id=6acbfb96976fc3350e30d964acb1dbbdf876d55e

which should make its way to Linus soonish I suppose.
