Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaKDIcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:32:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:35069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaKDIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:32:28 -0500
Date: Tue, 4 Nov 2014 09:32:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Juri Lelli <juri.lelli@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] sched/deadline: support dl task migrate during cpu
 hotplug
Message-ID: <20141104083225.GG10501@worktop.programming.kicks-ass.net>
References: <1414740497-7232-1-git-send-email-wanpeng.li@linux.intel.com>
 <20141103104111.GA23531@worktop.programming.kicks-ass.net>
 <20141103235747.GA26702@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103235747.GA26702@kernel>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 07:57:48AM +0800, Wanpeng Li wrote:
> On Mon, Nov 03, 2014 at 11:41:11AM +0100, Peter Zijlstra wrote:

> >On Fri, Oct 31, 2014 at 03:28:17PM +0800, Wanpeng Li wrote:
> >So what is wrong with making dl_task_timer() deal with it? The timer
> >will still fire on the correct time, canceling it and or otherwise
> >messing with the CBS is wrong. Once it fires, all we need to do is
> >migrate it to another cpu (preferably one that is still online of course
> >:-).

> Do you mean what I need to do is push the task to another cpu in dl_task_timer() 
> if rq is offline?

That does indeed appear to be the sensible fix to me.

> In addition, what will happen if dl task can't preempt on 
> another cpu?

So if we find that the rq the task was on is no longer available, we
need to select a new rq, the 'right' rq would be the one running the
latest deadline.

If it cannot preempt the latest (running) deadline, it was not eligible
for running in the first place so no worries, right?
