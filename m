Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaCGPQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:16:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56520 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752818AbaCGPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:05 -0500
Message-Id: <20140307151202.688254163@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [for-next][PATCH 11/20] tracing/module: Replace include of tracepoint.h with jump_label.h in
 module.h
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0011-tracing-module-Replace-include-of-tracepoint.h-with-.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's nothing in the module.h header that requires tracepoint.h to be
included, and there may be cases that tracepoint.h may need to include
module.h, which will cause recursive header issues.

But module.h requires seeing HAVE_JUMP_LABEL which is set in jump_label.h
which it just coincidentally gets from tracepoint.h.

Link: http://lkml.kernel.org/r/20140307084712.5c68641a@gandalf.local.home

Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/module.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..5a50539 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -15,7 +15,7 @@
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
-#include <linux/tracepoint.h>
+#include <linux/jump_label.h>
 #include <linux/export.h>
 
 #include <linux/percpu.h>
-- 
1.8.5.3


