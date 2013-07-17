Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3GQKyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:54:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60553 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3GQKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:54:32 -0400
Date: Wed, 17 Jul 2013 12:54:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] sched: Avoid overloading CPUs on a preferred NUMA
 node
Message-ID: <20130717105423.GC17211@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-17-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373901620-2021-17-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 04:20:18PM +0100, Mel Gorman wrote:
> +static long effective_load(struct task_group *tg, int cpu, long wl, long wg);

And this -- which suggests you always build with cgroups enabled? I generally
try and disable all that nonsense when building new stuff, the scheduler is a
'lot' simpler that way. Once that works make it 'interesting' again.

---

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3367,8 +3367,7 @@ static long effective_load(struct task_g
 }
 #else
 
-static unsigned long effective_load(struct task_group *tg, int cpu,
-		unsigned long wl, unsigned long wg)
+static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	return wl;
 }

