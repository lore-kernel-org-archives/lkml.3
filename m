Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaBZTGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:06:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42548 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753688AbaBZTGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:46 -0500
Message-Id: <20140226190644.591040764@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 26 Feb 2014 14:01:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFA][PATCH 2/4] tracing: Fix event header migrate.h to include tracepoint.h
References: <20140226190140.590029589@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Fix-event-header-migrate.h-to-include-tracep.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Request for Ack ]

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace event headers are required to include tracepoint.h. The only reason
they worked now is because module.h included tracepoint.h, and that will soon
change. (And the change will be going to the stable tree as well)

Fixes: 7b2a2d4a18ff "mm: migrate: Add a tracepoint for migrate_pages"
Cc: stable@vger.kernel.org # 3.8+
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/migrate.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index 3075ffb..4e4f2f8 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -4,6 +4,8 @@
 #if !defined(_TRACE_MIGRATE_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_MIGRATE_H
 
+#include <linux/tracepoint.h>
+
 #define MIGRATE_MODE						\
 	{MIGRATE_ASYNC,		"MIGRATE_ASYNC"},		\
 	{MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT"},		\
-- 
1.8.5.3


