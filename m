Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3F1Sw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:52:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41583 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3F1Swc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@ghostprotocols.net,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 006/105] perf: Fix error return code
Date: Fri, 28 Jun 2013 11:50:28 -0700
Message-Id: <1372445527-24414-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit c481420248c6730246d2a1b1773d5d7007ae0835 upstream.

Fix to return -ENOMEM in the allocation error case instead of 0
(if pmu_bus_running == 1), as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: a.p.zijlstra@chello.nl
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Link: http://lkml.kernel.org/r/CAPgLHd8j_fWcgqe%3DKLWjpBj%2B%3Do0Pw6Z-SEq%3DNTPU08c2w1tngQ@mail.gmail.com
[ Tweaked the error code setting placement and the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0600d3b..1df07c2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5988,6 +5988,7 @@ skip_type:
 	if (pmu->pmu_cpu_context)
 		goto got_cpu_context;
 
+	ret = -ENOMEM;
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
 	if (!pmu->pmu_cpu_context)
 		goto free_dev;
-- 
1.8.1.2

