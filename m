Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3COQvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:51:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51088 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab3COQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:51:30 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880046"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 2/9] events: use DEFINE_STATIC_SRCU() to define pmus_srcu
Date: Sat, 16 Mar 2013 00:50:50 +0800
Message-Id: <1363366257-4886-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:11,
	Serialize complete at 2013/03/16 00:50:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_STATIC_SRCU() defines srcu struct and do init at build time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/events/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..c334f26 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -146,7 +146,7 @@ static atomic_t nr_task_events __read_mostly;
 
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
-static struct srcu_struct pmus_srcu;
+DEFINE_STATIC_SRCU(pmus_srcu);
 
 /*
  * perf event paranoia level:
@@ -7396,7 +7396,6 @@ void __init perf_event_init(void)
 	idr_init(&pmu_idr);
 
 	perf_event_init_all_cpus();
-	init_srcu_struct(&pmus_srcu);
 	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
 	perf_pmu_register(&perf_cpu_clock, NULL, -1);
 	perf_pmu_register(&perf_task_clock, NULL, -1);
-- 
1.7.4.4

