Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab3BFTyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:54:00 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52706 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab3BFTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:21 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 72/77] events: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:44 -0800
Message-Id: <1360179649-22465-73-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 kernel/events/core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7b6646a..43ba037 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5965,13 +5965,9 @@ int perf_pmu_register(struct pmu *pmu, char *name, int type)
 	pmu->name = name;
 
 	if (type < 0) {
-		int err = idr_pre_get(&pmu_idr, GFP_KERNEL);
-		if (!err)
-			goto free_pdc;
-
-		err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);
-		if (err) {
-			ret = err;
+		type = idr_alloc(&pmu_idr, pmu, PERF_TYPE_MAX, 0, GFP_KERNEL);
+		if (type < 0) {
+			ret = type;
 			goto free_pdc;
 		}
 	}
-- 
1.8.1

