Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3AVQKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:10:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36573 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753643Ab3AVQKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:10:38 -0500
Date: Tue, 22 Jan 2013 10:10:37 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: mmotm 2013-01-18-15-48 uploaded (sched/stats.c)
Message-ID: <20130122161037.GA24669@gulag1.americas.sgi.com>
References: <20130118234944.5C99C31C240@corp2gmr1-1.hot.corp.google.com> <50FAF661.4070801@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FAF661.4070801@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 11:39:13AM -0800, Randy Dunlap wrote:
> On 01/18/13 15:49, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2013-01-18-15-48 has been uploaded to
> > 
> >    http://www.ozlabs.org/~akpm/mmotm/
> > 
> > mmotm-readme.txt says
> > 
> > README for mm-of-the-moment:
> > 
> > http://www.ozlabs.org/~akpm/mmotm/
> > 
> > This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> > more than once a week.
> > 
> 
> on i386 or x86_64:
> 
> kernel/sched/stats.c:31:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
> 
> 
> 
> -- 
> ~Randy

Sorry about that.
Here is the correction.

>From c832132ade12e28cd09d3c13d412fc14a7b9ab87 Mon Sep 17 00:00:00 2001
From: Nathan Zimmer <nzimmer@sgi.com>
Date: Tue, 22 Jan 2013 09:09:17 -0600
Subject: [PATCH] on i386 or x86_64:

kernel/sched/stats.c:31:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 kernel/sched/stats.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index bae2757..3cbfc46 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -25,14 +25,13 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
 		seq_printf(seq, "timestamp %lu\n", jiffies);
 	} else {
-
-		cpu = (unsigned long)(v - 2);
-
-		struct rq *rq = cpu_rq(cpu);
+		struct rq *rq; 
 #ifdef CONFIG_SMP
 		struct sched_domain *sd;
 		int dcount = 0;
 #endif
+		cpu = (unsigned long)(v - 2);
+		rq = cpu_rq(cpu);
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-- 
1.6.0.2


