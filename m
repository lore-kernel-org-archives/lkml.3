Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3CONr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:47:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34593 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3CONoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:34 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 2/9] metag: perf: fix wrap handling in delta calculation
Date: Fri, 15 Mar 2013 13:43:41 +0000
Message-ID: <1363355028-23278-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating the delta, mask with MAX_PERIOD (24 bits) to handle
wrapping, which particularly happens with periodic sampling since the
value is intentionally set so that it will overflow soon.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index f38bf6d..8096db2 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -211,7 +211,7 @@ again:
 	/*
 	 * Calculate the delta and add it to the counter.
 	 */
-	delta = new_raw_count - prev_raw_count;
+	delta = (new_raw_count - prev_raw_count) & MAX_PERIOD;
 
 	local64_add(delta, &event->count);
 }
-- 
1.8.1.2


