Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab3AURSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:18:37 -0500
Received: from goliath.siemens.de ([192.35.17.28]:19848 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab3AURSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:18:35 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH v4 13/13] scripts/gdb: Add lx_current convenience function
Date: Mon, 21 Jan 2013 18:06:20 +0100
Message-Id: <266ac6de0961add828fd1c5824b1ca88e5443999.1358787929.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a shorthand for *$lx_per_cpu("current_task"), i.e. a convenience
function to retrieve the currently running task of the active context.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/percpu.py |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
index e2556919..dbc84c0 100644
--- a/scripts/gdb/percpu.py
+++ b/scripts/gdb/percpu.py
@@ -59,3 +59,18 @@ class PerCpu(gdb.Function):
 		return per_cpu(var_name.string(), cpu)
 
 PerCpu()
+
+
+class LxCurrentFunc(gdb.Function):
+	__doc__ = "Return current task.\n" \
+		  "\n" \
+		  "$lx_current([CPU]): Return the per-cpu task variable for the given CPU\n" \
+		  "number. If CPU is omitted, the CPU of the current context is used."
+
+	def __init__(self):
+		super(LxCurrentFunc, self).__init__("lx_current")
+
+	def invoke(self, cpu = -1):
+		return per_cpu("current_task", cpu).dereference()
+
+LxCurrentFunc()
-- 
1.7.3.4

