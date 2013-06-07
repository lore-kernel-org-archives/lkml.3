Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3FGWWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:22:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47597 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab3FGWW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:22:29 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        David Ahern <dsahern@gmail.com>
Subject: [RFC PATCH 2/4] perf: add methods for setting/retrieving priv element of thread struct
Date: Fri,  7 Jun 2013 16:22:12 -0600
Message-Id: <1370643734-9579-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
References: <1370643734-9579-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/thread.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index eeb7ac6..5e7ba35 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -47,4 +47,14 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al,
 				symbol_filter_t filter);
+
+static inline void *thread__priv(struct thread *thread)
+{
+	return thread->priv;
+}
+
+static inline void thread__set_priv(struct thread *thread, void *p)
+{
+	thread->priv = p;
+}
 #endif	/* __PERF_THREAD_H */
-- 
1.7.10.1

