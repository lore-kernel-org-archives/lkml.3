Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab3ICFoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:44:19 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54963 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICFoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:44:18 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-93-52257730259a
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
Date: Tue,  3 Sep 2013 14:44:02 +0900
Message-Id: <1378187054-27401-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378187054-27401-1-git-send-email-namhyung@kernel.org>
References: <1378187054-27401-1-git-send-email-namhyung@kernel.org>
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

