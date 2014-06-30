Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaF3IGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:06:50 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:52882 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaF3IGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:06:45 -0400
Message-ID: <1404115601.5132.156.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jun 2014 10:06:41 +0200
In-Reply-To: <53B11387.9020001@linux.vnet.ibm.com>
References: <53A11A89.5000602@linux.vnet.ibm.com>
	 <53B11387.9020001@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 15:36 +0800, Michael wang wrote: 
> On 06/18/2014 12:50 PM, Michael wang wrote:
> > By testing we found that after put benchmark (dbench) in to deep cpu-group,
> > tasks (dbench routines) start to gathered on one CPU, which lead to that the
> > benchmark could only get around 100% CPU whatever how big it's task-group's
> > share is, here is the link of the way to reproduce the issue:
> 
> Hi, Peter
> 
> We thought that involved too much factors will make things too
> complicated, we are trying to start over and get rid of the concepts of
> 'deep-group' and 'GENTLE_FAIR_SLEEPERS' in the idea, wish this could
> make things more easier...

While you're getting rid of the concept of 'GENTLE_FAIR_SLEEPERS', don't
forget to also get rid of the concept of 'over-scheduling' :)

That gentle thing isn't perfect (is the enemy of good), but preemption
model being based upon sleep, while nice and simple, has the unfortunate
weakness that as contention increases, so does the quantity of sleep in
the system.  Would be nice to come up with an alternative preemption
model as dirt simple as this one, but lacking the inherent weakness.

-Mike

