Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaAOLe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:34:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34561 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOLeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:34:25 -0500
Date: Wed, 15 Jan 2014 12:34:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
Message-ID: <20140115113406.GC31570@twins.programming.kicks-ass.net>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
 <20140115103808.GY31570@twins.programming.kicks-ass.net>
 <CAKohpomtNWZTn4zhf3og=Ff8LvBMH_68tLNgYLOyBK5Az6WXuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomtNWZTn4zhf3og=Ff8LvBMH_68tLNgYLOyBK5Az6WXuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 04:17:26PM +0530, Viresh Kumar wrote:
> On 15 January 2014 16:08, Peter Zijlstra <peterz@infradead.org> wrote:
> > Nah, its just ugly and we should fix it. You need to be careful to not
> > place tasks in a cpuset you're going to unplug though, that'll give
> > funny results.
> 
> Okay. So how do you suggest to get rid of cases like a work queued
> on CPU1 initially and because it gets queued again from its work handler,
> it stays on the same CPU forever.

We should have a cpuset.quiesce control or something that moves all
timers out.

> And then there were timer overflow events that occur because hrtimer
> is started by tick-sched stuff for 450 seconds later in time.

-ENOPARSE
