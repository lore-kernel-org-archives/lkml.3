Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaLORVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:21:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLORVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:21:44 -0500
Date: Mon, 15 Dec 2014 18:21:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Josef Bacik <jbacik@fb.com>
Cc: bmaurer@fb.com, rkroll@fb.com, kernel-team@fb.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: [PATCH] sched/fair: change where we report sched stats V2
Message-ID: <20141215172129.GS3337@twins.programming.kicks-ass.net>
References: <1418313595-14286-1-git-send-email-jbacik@fb.com>
 <20141215101625.GW29390@twins.programming.kicks-ass.net>
 <548F0025.4040203@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548F0025.4040203@fb.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:37:09AM -0500, Josef Bacik wrote:

> >Yeah, so I don't like this, it adds overhead for everyone.
> >
> 
> Only if SCHEDSTATS is enabled tho, and it's no more overhead in the
> SCHEDSTATS case than before.  Would it be more acceptable to move the entire
> callback under SCHEDSTATS?

Nah, doesn't work. Distros need to enable the world and then some so
.config is a false choice.

> This is fine for discrete problems, but when trying to find a random latency
> spike in a production workload it's impossible. If I do
> 
> trace-cmd record -e sched:sched_switch -T sleep 5
> 
> on just one of our random web servers I end up with this
> 
> du -h trace.dat
> 62M     trace.dat
> 
> thats 62 megs in 5 seconds.  I ran the following command for almost 2 hours
> when searching for a latency spike
> 
> trace-cmd record -B latency -e sched:sched_stat_blocked -f \"delay >=
> 100000\" -T -o /root/latency.dat
> 
> and got the following .dat file
> 
> du -h latency.dat
> 48M     latency.dat

Ah, regardless what I think of our filter implementation, that actually
makes sense, let me ponder this a bit.
