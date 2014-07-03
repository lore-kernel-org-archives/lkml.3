Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbaGCQMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:12:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759145AbaGCQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:25 -0400
Message-Id: <20140703161224.437537348@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 12:05:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [for-next][PATCH 06/21] tracing: Change trace event sample to use strlcpy instead of strncpy
References: <20140703160503.006976702@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0006-tracing-Change-trace-event-sample-to-use-strlcpy-ins.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

Strings should be copied with strlcpy instead of strncpy when they will
later be printed via %s. This guarantees that they terminate with a
NUL '\0' character and do not run pass the end of the allocated string.

This is only for sample code, but it should stil represent a good
role model.

Link: http://lkml.kernel.org/p/51C2E204.1080501@huawei.com

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 samples/trace_events/trace-events-sample.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 4b0113f73ee9..476429281389 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -87,7 +87,7 @@ TRACE_EVENT(foo_bar,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->foo, foo, 10);
+		strlcpy(__entry->foo, foo, 10);
 		__entry->bar	= bar;
 	),
 
-- 
2.0.0


