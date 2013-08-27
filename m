Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3H0ItC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:49:02 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52972 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3H0Is7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:48:59 -0400
X-AuditID: 9c930197-b7b44ae00000347f-42-521c67fa0366
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 01/13] tracing/uprobes: Fix documentation of uprobe registration syntax
Date: Tue, 27 Aug 2013 17:48:44 +0900
Message-Id: <1377593336-16828-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The uprobe syntax requires an offset after a file path not a symbol.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/trace/uprobetracer.txt | 10 +++++-----
 kernel/trace/trace_uprobe.c          |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index d9c3e682312c..8f1a8b8956fc 100644
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
index 272261b5f94f..a415c5867ec5 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -210,7 +210,7 @@ end:
 
 /*
  * Argument syntax:
- *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:SYMBOL [FETCHARGS]
+ *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:OFFSET [FETCHARGS]
  *
  *  - Remove uprobe: -:[GRP/]EVENT
  */
-- 
1.7.11.7

