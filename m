Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3GOLAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:00:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36312 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3GOLAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:00:50 -0400
Date: Mon, 15 Jul 2013 12:59:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        devel@openvz.org, pjt@google.com
Subject: Re: [PATCH RFC] sched: move h_load calculation to task_h_load
Message-ID: <20130715105950.GA23818@dyad.programming.kicks-ass.net>
References: <1373705235-22523-1-git-send-email-vdavydov@parallels.com>
 <20130715082853.GM17211@twins.programming.kicks-ass.net>
 <51E3C84A.5090403@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E3C84A.5090403@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 02:00:42PM +0400, Vladimir Davydov wrote:
> On 07/15/2013 12:28 PM, Peter Zijlstra wrote:
> >OK, fair enough. It does somewhat rely on us getting the single
> >rq->clock update thing right, but that should be ok.
> 
> Frankly, I doubt that rq->clock is the right thing to use here, because it
> can be updated very frequently under some conditions, so that cfs_rq->h_load
> can get updated several times during the same balance run. Perhaps, jiffies
> would suit better for that purpose. This would work as h_load update
> throttler similar to how it works now (I mean rq->h_load_throttle in
> update_h_load()).
> 
> If there is something else you don't like/have some thoughts on, please
> share - I'll try to improve.

Yeah, go with jiffies, that makes more sense.

Other than that, when I initially saw your patch I thought about 'fixing'
walk_tg_tree() to ignore groups that have no tasks but that's not going to help
for the case where all groups have 1 (or more) tasks that are inactive.

We also cannot use cfs_rq::h_nr_running because that's per cpu and not system
wide.

So yeah, after a bit of a ponder I agreed that your aproach was the most
feasible.

So unless someone else has a bright idea I think what you propose is a good
solution.
