Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3JJPnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab3JJPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:43:14 -0400
Date: Thu, 10 Oct 2013 17:36:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010153603.GB13375@redhat.com>
References: <20131008102505.404025673@infradead.org> <20131009225006.7101379c.akpm@linux-foundation.org> <20131010121908.GB28601@twins.programming.kicks-ass.net> <20131010145738.GA5167@gmail.com> <20131010152134.GQ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010152134.GQ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Peter Zijlstra wrote:
>
> That said, Oleg wants to use the same scheme for percpu_rwsem,

Yes, and later then (I hope) get_online_cpus() will be just
current->cpuhp_ref++ || percpu_down_read().

(just in case, we only need ->cpuhp_ref to ensure that the readers
 can't starve the writers as it currently possible. iow to block the
 new readers but ensure that the recursive get/down_read can't block)

And please look at sb_wait_write/sb_start_write. It uses the same
logic except:

	- it doesn't have the "true" fast-path for readers

	- its "slow" mode is slower than necessary

	- it is buggy (afaics)

> and I'm
> not sure his write-side (something in uprobes) wants to do the same.

surely not ;)

Oleg.

