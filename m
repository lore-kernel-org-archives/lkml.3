Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaBZTIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:08:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42548 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753990AbaBZTGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:46 -0500
Message-Id: <20140226190644.442886305@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 26 Feb 2014 14:01:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dave Chinner <dchinner@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: [RFA][PATCH 1/4] tracing: Fix event header writeback.h to include tracepoint.h
References: <20140226190140.590029589@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-Fix-event-header-writeback.h-to-include-trac.patch
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

Fixes: 455b2864686d "writeback: Initial tracing support"
Cc: stable@vger.kernel.org # 2.6.36+
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/writeback.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c7bbbe7..309a086 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -4,6 +4,7 @@
 #if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_WRITEBACK_H
 
+#include <linux/tracepoint.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
 
-- 
1.8.5.3


