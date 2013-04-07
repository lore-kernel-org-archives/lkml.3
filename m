Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab3DGPC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:02:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47321 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761082Ab3DGPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:02:57 -0400
Date: Sun, 7 Apr 2013 11:02:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH] wfcqueue: implement __wfcq_enqueue_head() (v2)
Message-ID: <20130407150253.GA10154@Krystal>
References: <20130406232908.GA7797@Krystal> <20130406235125.GA12779@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406235125.GA12779@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > Implement enqueue-to-head. It can run concurrently with enqueue, splice
> > to queue, and iteration, but requires a mutex against dequeue and splice
> > from queue operations.
> > 
> > Useful for special-cases where a queue needs to have nodes enqueued into
> > its head.
> > 
> > This patch is only compile-tested.
> > 
> > Changes since v1:
> > * Don't require mutual exclusion between traversals and
> >   __wfcq_enqueue_head().
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> Thanks!  The first hunk (sync table comment) conflicted with
> my __wfcq_enqueue patch, but other than that I could not benchmark any
> regression with my 4-core machine with v4 of my
> "epoll: avoid spinlock contention with wfcqueue" patch.
> 
> All I needed was "s/__wfcq_prepend/__wfcq_enqueue_head/g" to my original
> patch to use the updated API.
> 
> I was worried about the cmpxchg at first, but it does not seem to hurt
> performance on my 4-core system.  In fact, it was slightly better
> (but within margin of error)
> 
> time ./eponeshotmt -c 1000000 -w 4 -t 4 -f 10
> real    0m 5.78s
> user    0m 1.20s
> sys     0m 21.90s
> 
> Tested-by: Eric Wong <normalperson@yhbt.net>
> 
> Hopefully somebody can test my epoll patches with more cores/threads :)

Thanks for testing. Taking care of your comments, and of memory
barriers, brings me to send a v3 of this patch shortly. Testing is
welcome!

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
