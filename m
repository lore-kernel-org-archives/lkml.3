Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935261AbaH0PW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:22:26 -0400
Received: from david.siemens.de ([192.35.17.14]:39535 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935240AbaH0PWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:20 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v9 14/23] scripts/gdb: Add is_target_arch helper
Date: Wed, 27 Aug 2014 17:21:29 +0200
Message-Id: <edac9b83ab4a25eefc66634150c59cbe2b291440.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper caches to result of "show architecture" and matches the
provided arch (sub-)string against that output.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/utils.py | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index 808a265..71ee48c 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -106,3 +106,16 @@ def read_u64(buffer):
         return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
     else:
         return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
+
+
+target_arch = None
+
+
+def is_target_arch(arch):
+    if hasattr(gdb.Frame, 'architecture'):
+        return arch in gdb.newest_frame().architecture().name()
+    else:
+        global target_arch
+        if target_arch is None:
+            target_arch = gdb.execute("show architecture", to_string=True)
+        return arch in target_arch
-- 
1.8.1.1.298.ge7eed54

