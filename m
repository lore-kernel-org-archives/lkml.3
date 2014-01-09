Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaAIXwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:52:00 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52063 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbaAIXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:51:52 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/3] perf: clarify comment regarding event merging
Date: Thu,  9 Jan 2014 15:51:31 -0800
Message-Id: <1389311492-5059-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010923-0928-0000-0000-0000053EE411
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are actually 2 things about software events that allow us to
merge them: they never fail to schedule _and_ they have transaction
handlers we can (and do, when they are added to !sw groups) ignore. Note
both of these in the comment on adding sw events to !sw groups.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f574401..e9f60d0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7065,7 +7065,8 @@ SYSCALL_DEFINE5(perf_event_open,
 			 *
 			 * Allow the addition of software events to !software
 			 * groups, this is safe because software events never
-			 * fail to schedule.
+			 * fail to schedule and have ignorable transaction
+			 * handlers ({start,cancel,commit}_txn).
 			 */
 			pmu = group_leader->pmu;
 		} else if (is_software_event(group_leader) &&
-- 
1.8.5.2

