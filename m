Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3AXPLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:11:51 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54604 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab3AXPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:11:48 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v7 13/18] perf record: add support for mem access profiling
Date: Thu, 24 Jan 2013 16:10:37 +0100
Message-Id: <1359040242-8269-14-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the -W option to obtain the cost of the
memory accesses.

Data address sampling is obtained via the -d option.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evsel.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 49daa7b..277b98d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -501,6 +501,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (opts->sample_address)
+		attr->sample_type	|= PERF_SAMPLE_DSRC;
+
 	if (opts->no_delay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
-- 
1.7.9.5

