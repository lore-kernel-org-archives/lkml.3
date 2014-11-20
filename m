Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbaKTRGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:06:09 -0500
Received: from thoth.sbs.de ([192.35.17.2]:43754 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768AbaKTRCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:02:46 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v10 18/27] scripts/gdb: Add lx_current convenience function
Date: Thu, 20 Nov 2014 18:01:55 +0100
Message-Id: <4ffd20eb4288b8f9f323b2ae5f163594d33d8c1f.1416502923.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1416502923.git.jan.kiszka@siemens.com>
References: <cover.1416502923.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a shorthand for *$lx_per_cpu("current_task"), i.e. a convenience
function to retrieve the currently running task of the active context.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/cpus.py | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/scripts/gdb/linux/cpus.py b/scripts/gdb/linux/cpus.py
index 18337e0..b683da9 100644
--- a/scripts/gdb/linux/cpus.py
+++ b/scripts/gdb/linux/cpus.py
@@ -66,3 +66,20 @@ Note that VAR has to be quoted as string."""
 
 
 PerCpu()
+
+
+class LxCurrentFunc(gdb.Function):
+    """Return current task.
+
+$lx_current([CPU]): Return the per-cpu task variable for the given CPU
+number. If CPU is omitted, the CPU of the current context is used."""
+
+    def __init__(self):
+        super(LxCurrentFunc, self).__init__("lx_current")
+
+    def invoke(self, cpu=-1):
+        var_ptr = gdb.parse_and_eval("&current_task")
+        return per_cpu(var_ptr, cpu).dereference()
+
+
+LxCurrentFunc()
-- 
1.8.4.5

