Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaACCLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:11:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521AbaACCLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:46 -0500
Message-Id: <20140103021144.510962767@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 01/17] tracing/uprobes: Fix documentation of uprobe registration syntax
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-uprobes-Fix-documentation-of-uprobe-registra.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The uprobe syntax requires an offset after a file path not a symbol.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/trace/uprobetracer.txt | 10 +++++-----
 kernel/trace/trace_uprobe.c          |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index d9c3e68..8f1a8b89 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -19,15 +19,15 @@ user to calculate the offset of the probepoint in the object.
 
 Synopsis of uprobe_tracer
 -------------------------
-  p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a uprobe
-  r[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a return uprobe (uretprobe)
-  -:[GRP/]EVENT                                  : Clear uprobe or uretprobe event
+  p[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS] : Set a uprobe
+  r[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS] : Set a return uprobe (uretprobe)
+  -:[GRP/]EVENT                           : Clear uprobe or uretprobe event
 
   GRP           : Group name. If omitted, "uprobes" is the default value.
   EVENT         : Event name. If omitted, the event name is generated based
-                  on SYMBOL+offs.
+                  on PATH+OFFSET.
   PATH          : Path to an executable or a library.
-  SYMBOL[+offs] : Symbol+offset where the probe is inserted.
+  OFFSET        : Offset where the probe is inserted.
 
   FETCHARGS     : Arguments. Each probe can have up to 128 args.
    %REG         : Fetch register REG
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index b6dcc42..c77b92d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -211,7 +211,7 @@ end:
 
 /*
  * Argument syntax:
- *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:SYMBOL [FETCHARGS]
+ *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS]
  *
  *  - Remove uprobe: -:[GRP/]EVENT
  */
-- 
1.8.4.3


