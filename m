Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab3A2Mi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:38:57 -0500
Received: from thoth.sbs.de ([192.35.17.2]:23300 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab3A2Miz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:38:55 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 13/20] scripts/gdb: Add is_target_arch helper
Date: Tue, 29 Jan 2013 13:37:56 +0100
Message-Id: <ee9f53440ebd93d76655345881d70f4f5b481b19.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper caches to result of "show architecture" and matches the
provided arch (sub-)string against that output.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 9b23052..bcf4278 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -112,3 +112,12 @@ def read_u64(buffer):
 		return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
 	else:
 		return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
+
+
+target_arch = None
+
+def is_target_arch(arch):
+	global target_arch
+	if target_arch == None:
+		target_arch = gdb.execute("show architecture", False, True)
+	return target_arch.find(arch) >= 0
-- 
1.7.3.4

