Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3CONof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:44:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34595 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3CONod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:33 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 1/9] metag: perf: fix core internal / perf channel mux
Date: Fri, 15 Mar 2013 13:43:40 +0000
Message-ID: <1363355028-23278-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value written to the PERF_ICOREx or PERF_CHANx register to select
the performance events for the core internal and perf channel events was
(tmp & 0x0f), but tmp was set to (config & 0xf0) so it would always be
0. Correct it to use config instead of tmp.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index a876d5f..f38bf6d 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -634,7 +634,7 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 			break;
 		}
 
-		metag_out32((tmp & 0x0f), perf_addr);
+		metag_out32((config & 0x0f), perf_addr);
 
 		/*
 		 * Now we use the high nibble as the performance event to
-- 
1.8.1.2


