Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaLOKQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:16:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:37821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaLOKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:16:38 -0500
Date: Mon, 15 Dec 2014 11:16:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josef Bacik <jbacik@fb.com>
Cc: bmaurer@fb.com, rkroll@fb.com, kernel-team@fb.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: [PATCH] sched/fair: change where we report sched stats V2
Message-ID: <20141215101625.GW29390@twins.programming.kicks-ass.net>
References: <1418313595-14286-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418313595-14286-1-git-send-email-jbacik@fb.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 10:59:55AM -0500, Josef Bacik wrote:
> The schedule stats currently spit out once the entity is being queued, which
> means if we have stack traces enabled we will get the stack trace of the waker,
> not of the task being woken.  This makes the backtrace completely useless when
> trying to track down latency spikes, as we want to know why we were put to sleep
> for as long as we were.
> 
> This patch moves the trace_sched_stat* calls to after the task has been put back
> on the CPU so that the backtrace we get is the one that put us to sleep.  Mike
> Galbraith suggested that I leave the actual stat collection stuff where it is so
> that we don't add the scheduler latency to the sleep stats, so I've added 3 new
> fields in the scheduler stats to keep track of the last sleep time so that if
> any of these are set we know to trigger the trace points.  Thanks,
> 

Yeah, so I don't like this, it adds overhead for everyone.

Also, I'm very sure this issue has been raised before, and I'm pretty
sure the answer back then was why don't you look at the
trace_sched_switch() site matching this wakeup?
