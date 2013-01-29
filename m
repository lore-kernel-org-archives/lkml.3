Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3A2MjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:39:11 -0500
Received: from david.siemens.de ([192.35.17.14]:29524 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab3A2MjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:39:06 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 17/20] scripts/gdb: Add lx_current convenience function
Date: Tue, 29 Jan 2013 13:38:00 +0100
Message-Id: <d33aed5e89cfb715115c08b4677d567e6eadee22.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a shorthand for *$lx_per_cpu("current_task"), i.e. a convenience
function to retrieve the currently running task of the active context.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/percpu.py |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
index 864962c..4dab8d3 100644
--- a/scripts/gdb/percpu.py
+++ b/scripts/gdb/percpu.py
@@ -59,3 +59,19 @@ class PerCpu(gdb.Function):
 		return per_cpu(var_ptr, cpu)
 
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
+		var_ptr = gdb.parse_and_eval("&current_task")
+		return per_cpu(var_ptr, cpu).dereference()
+
+LxCurrentFunc()
-- 
1.7.3.4

