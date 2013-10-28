Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3J1JLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:11:37 -0400
Received: from goliath.siemens.de ([192.35.17.28]:29837 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab3J1JLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:11:35 -0400
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 05:11:34 EDT
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v6 14/21] scripts/gdb: Add is_target_arch helper
Date: Mon, 28 Oct 2013 09:58:51 +0100
Message-Id: <1ce57083617f4f166a7716a7508ed8f3561d94b2.1382950737.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1382950737.git.jan.kiszka@siemens.com>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1382950737.git.jan.kiszka@siemens.com>
References: <cover.1382950737.git.jan.kiszka@siemens.com>
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

