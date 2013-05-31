Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3EaIvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:51:17 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36403 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3EaIsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:48:13 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>
Subject: [PATCH 03/16] perf, persistent: Setting default buffer size to 512k as in perf tools
Date: Fri, 31 May 2013 10:47:23 +0200
Message-Id: <1369990056-10310-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1369990056-10310-1-git-send-email-rric@kernel.org>
References: <1369990056-10310-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@calxeda.com>

The default buffer size used to setup event buffers with perf tools is
512k. Using the same buffer size for persistent events. This also
avoids failed mmap calls due to different buffer sizes.

Signed-off-by: Robert Richter <robert.richter@calxeda.com>
---
 kernel/events/persistent.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index 9075164..1e6c03a 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -5,6 +5,9 @@
 
 #include "internal.h"
 
+/* 512 kiB: default perf tools memory size, see perf_evlist__mmap() */
+#define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
+
 static DEFINE_PER_CPU(struct list_head, pers_events);
 
 static struct perf_event *
@@ -151,7 +154,7 @@ int perf_add_persistent_event_by_id(int id)
 	attr->type		= PERF_TYPE_TRACEPOINT;
 	attr->size		= sizeof(*attr);
 
-	return perf_add_persistent_event(attr, 4);
+	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
 }
 
 int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
-- 
1.8.1.1

