Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3DLDF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 23:05:56 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59293 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3DLDFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 23:05:55 -0400
MIME-Version: 1.0
Date: Fri, 12 Apr 2013 11:05:54 +0800
Message-ID: <CAPgLHd8j_fWcgqe=KLWjpBj+=o0Pw6Z-SEq=NTPU08c2w1tngQ@mail.gmail.com>
Subject: [PATCH -next] perf: fix error return code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/events/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2427107..7504140 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6033,8 +6033,10 @@ skip_type:
 		goto got_cpu_context;
 
 	pmu->pmu_cpu_context = alloc_percpu(struct perf_cpu_context);
-	if (!pmu->pmu_cpu_context)
+	if (!pmu->pmu_cpu_context) {
+		ret = -ENOMEM;
 		goto free_dev;
+	}
 
 	for_each_possible_cpu(cpu) {
 		struct perf_cpu_context *cpuctx;

