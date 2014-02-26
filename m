Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaBZTGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:06:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:41763 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753637AbaBZTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:45 -0500
Message-Id: <20140226190644.730153889@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 26 Feb 2014 14:01:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFA][PATCH 3/4] tracing/module: Remove include of tracepoint.h from module.h
References: <20140226190140.590029589@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-module-Remove-include-of-tracepoint.h-from-m.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Request for Ack ]

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's nothing in the module.h header that requires tracepoint.h to be
included. Soon, tracepoint.h will require struct module, and will have to
include module.h. To avoid include hell, we need to remove the include of
tracepoint.h from module.h.

A stable patch will require this change, so include stable in the Cc.

Cc: stable@vger.kernel.org # 2.6.31+
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/module.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..6cc28d9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,7 +15,6 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
-#include <linux/tracepoint.h>
 #include <linux/export.h>
 
 #include <linux/percpu.h>
-- 
1.8.5.3


