Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbaD2NsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbaD2NsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:48:09 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 4/6] perf tests: Add a test of kvm-390: trace event
Date: Tue, 29 Apr 2014 15:47:48 +0200
Message-Id: <1398779270-10271-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
References: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Add a s390 specific test of a hardcoded trace event with '-'
in the name.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1398440047-6641-4-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/parse-events.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 81dbd5a..deba669 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1389,6 +1389,13 @@ static struct evlist_test test__events[] = {
 		.check = test__pinned_group,
 		.id    = 41,
 	},
+#if defined(__s390x__)
+	{
+		.name  = "kvm-s390:kvm_s390_create_vm",
+		.check = test__checkevent_tracepoint,
+		.id    = 100,
+	},
+#endif
 };
 
 static struct evlist_test test__events_pmu[] = {
-- 
1.8.3.1

