Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3HCMvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 08:51:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3HCMvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 08:51:19 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=HIwK-7WGynQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=baqANKS3vA0A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Zx5j6QXMWhG9DQdKit0A:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130803125117.382366827@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 03 Aug 2013 08:49:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>
Subject: [for-next-3.11][PATCH 2/4] tracing: Fix trace_dump_stack() proto when CONFIG_TRACING is not set
References: <20130803124926.157378122@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-trace_dump_stack-proto-when-CONFIG_TRACI.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dhaval Giani <dhaval.giani@gmail.com>

When CONFIG_TRACING is not enabled, the stub prototype for trace_dump_stack()
is incorrect. It has (void) when it should be (int).

Link: http://lkml.kernel.org/r/CAPhKKr_H=ukFnBL4WgDOVT5ay2xeF-Ho+CA0DWZX0E2JW-=vSQ@mail.gmail.com

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3bef14c..482ad2d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -629,7 +629,7 @@ extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
-static inline void trace_dump_stack(void) { }
+static inline void trace_dump_stack(int skip) { }
 
 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
-- 
1.7.10.4


