Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab3CRFO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:14:56 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49132 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3CRFOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:14:55 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-53-5146a2cd5456
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] perf cgroup: Add __percpu annotation to perf_cgroup->info
Date: Mon, 18 Mar 2013 14:14:52 +0900
Message-Id: <1363583692-31631-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's a per-cpu data structure but missed the __percpu annotation.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 include/linux/perf_event.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 001a3b64fe61..16116aee9405 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -311,8 +311,8 @@ struct perf_cgroup_info {
 };
 
 struct perf_cgroup {
-	struct				cgroup_subsys_state css;
-	struct				perf_cgroup_info *info;	/* timing info, one per cpu */
+	struct cgroup_subsys_state 	css;
+	struct perf_cgroup_info __percpu * info;
 };
 #endif
 
-- 
1.7.11.7

