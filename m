Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3AXPOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:14:42 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33531 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab3AXPLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:11:25 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v7 06/18] perf: add support for PERF_SAMPLE_ADDR in dump_sampple()
Date: Thu, 24 Jan 2013 16:10:30 +0100
Message-Id: <1359040242-8269-7-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was missing from current code yet PERF_SAMPLE_ADDR has
been present for a long time. Needed for PEBS-LL mode.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3de9097..8fe3688 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1008,7 +1008,10 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 		stack_user__printf(&sample->user_stack);
 
 	if (sample_type & PERF_SAMPLE_WEIGHT)
-		printf("... weight: %" PRIu64 "\n", sample->weight);
+		printf(" ... weight: %" PRIu64 "\n", sample->weight);
+
+	if (sample_type & PERF_SAMPLE_ADDR)
+		printf(" ..... data: 0x%"PRIx64"\n", sample->addr);
 }
 
 static struct machine *
-- 
1.7.9.5

