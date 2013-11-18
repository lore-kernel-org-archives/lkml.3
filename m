Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3KREk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 23:40:57 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58897 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3KREkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 23:40:51 -0500
X-AuditID: 9c93017d-b7b15ae000000e52-63-52899a5232cf
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 1/2] tracing/uprobes: Fix documentation of uprobe registration syntax
Date: Mon, 18 Nov 2013 13:40:48 +0900
Message-Id: <1384749649-31447-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
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

