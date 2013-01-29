Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab3A2MlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:41:16 -0500
Received: from goliath.siemens.de ([192.35.17.28]:18465 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab3A2MjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:39:10 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 04/20] scripts/gdb: Add module iteration helper
Date: Tue, 29 Jan 2013 13:37:47 +0100
Message-Id: <25e00ee43b65bb23478c0e4922eecedf8fde112a.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will soon be used for loading symbols, printing global variables or
listing modules.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/module.py |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)
 create mode 100644 scripts/gdb/module.py

diff --git a/scripts/gdb/module.py b/scripts/gdb/module.py
new file mode 100644
index 0000000..01b23df
--- /dev/null
+++ b/scripts/gdb/module.py
@@ -0,0 +1,28 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  module tools
+#
+# Copyright (c) Siemens AG, 2013
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import gdb
+
+from utils import *
+
+module_type = CachedType("struct module")
+
+def for_each_module(func, arg = None):
+	global module_type
+	module_ptr_type = module_type.get_type().pointer()
+	modules = gdb.parse_and_eval("modules")
+	entry = modules['next']
+	while entry != modules.address:
+		module = container_of(entry, module_ptr_type, "list")
+		func(module, arg)
+		entry = entry['next']
-- 
1.7.3.4

