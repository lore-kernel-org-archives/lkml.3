Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306Ab3DSK7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:59:01 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:54762 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968169Ab3DSK7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:59:00 -0400
Date: Fri, 19 Apr 2013 12:58:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
Message-ID: <20130419105855.GA30060@gmail.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
 <20130415093330.GC17715@gmail.com>
 <1366283681.19383.5.camel@laptop>
 <51701722.1070407@windriver.com>
 <20130419082546.GA25370@gmail.com>
 <1366368694.19383.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366368694.19383.22.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2013-04-19 at 10:25 +0200, Ingo Molnar wrote:
> > It might eventually make sense to integrate the 'average load'
> > calculation as well 
> > with all this - as they really have a similar purpose, the avenload[]
> > vector of 
> > averages is conceptually similar to the rq->cpu_load[] vector of
> > averages.
> 
> The /proc/loadavg definition isn't useful for anything remotely sane
> wrt load-balancing or otherwise, so I don't really see that integration
> happening (its a measure of how many tasks are blocked, where the
> load-balancer needs a measure of how many tasks are wanting to run).

Well, loadavg also includes running tasks:

        nr_active = this_rq->nr_running;
        nr_active += (long) this_rq->nr_uninterruptible;

but yeah, the two are not the same. It could at least integrate in terms 
of averaging code, working on two different instances of data structures - 
but yeah, full integration is indeed not possible.

Thanks,

	Ingo
