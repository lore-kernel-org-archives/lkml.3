Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3IYMvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab3IYMv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/21] perf: Be more specific on pmu related event init naming
Date: Wed, 25 Sep 2013 14:50:36 +0200
Message-Id: <1380113447-17144-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

This disambiguates the function names as we prepare to split
the event allocation and initialization codes.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7df7a21..2a19b64 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6598,7 +6598,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	free_pmu_context(pmu);
 }
 
-struct pmu *perf_init_event(struct perf_event *event)
+struct pmu *perf_pmu_init_event(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
 	int idx;
@@ -6775,7 +6775,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
 		goto err_ns;
 
-	pmu = perf_init_event(event);
+	pmu = perf_pmu_init_event(event);
 	if (!pmu)
 		goto err_ns;
 	else if (IS_ERR(pmu)) {
-- 
1.7.11.7

