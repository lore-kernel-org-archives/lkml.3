Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaGHNs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:48:28 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60061 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaGHNsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:48:25 -0400
Message-ID: <53BBF6A5.8090707@gmail.com>
Date: Tue, 08 Jul 2014 21:48:21 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/kernel: Add 'score_ksyms.c' to export special
 symbols
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some symbols are not implemented in C, or not in "arch/score", but
score need export them, so add 'score_ksyms.c' to export them, just
like other architectures have done.

The related error (with allmodconfig under score):

   MODPOST 1365 modules
  ERROR: "__clear_user" [drivers/md/dm-mod.ko] undefined!
  ERROR: "__copy_tofrom_user" [net/x25/x25.ko] undefined!
  ERROR: "__strncpy_from_user" [fs/xfs/xfs.ko] undefined!

  ERROR: "max_low_pfn" [net/wireless/lib80211_crypt_tkip.ko] undefined!
  ERROR: "min_low_pfn" [net/wireless/lib80211_crypt_tkip.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/kernel/Makefile      |  2 +-
 arch/score/kernel/score_ksyms.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 arch/score/kernel/score_ksyms.c

diff --git a/arch/score/kernel/Makefile b/arch/score/kernel/Makefile
index fb1802b..891133b 100644
--- a/arch/score/kernel/Makefile
+++ b/arch/score/kernel/Makefile
@@ -6,6 +6,6 @@ extra-y	:= head.o vmlinux.lds
 
 obj-y += entry.o irq.o process.o ptrace.o \
 	setup.o signal.o sys_score.o time.o traps.o \
-	sys_call_table.o
+	sys_call_table.o score_ksyms.o
 
 obj-$(CONFIG_MODULES) += module.o
diff --git a/arch/score/kernel/score_ksyms.c b/arch/score/kernel/score_ksyms.c
new file mode 100644
index 0000000..507d008
--- /dev/null
+++ b/arch/score/kernel/score_ksyms.c
@@ -0,0 +1,39 @@
+/*
+ * arch/score/kernel/score_ksyms.c
+ *
+ * Score Processor version.
+ *
+ * No Copyright (C)
+ *  Chen Gang <gang.chen.5i5j@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/export.h>
+#include <linux/syscalls.h>
+
+/*
+ * Assembly functions that may be used (directly or indirectly) by modules
+ */
+EXPORT_SYMBOL(__clear_user);
+EXPORT_SYMBOL(__copy_tofrom_user);
+EXPORT_SYMBOL(__strncpy_from_user);
+
+/*
+ * Define but not export in generic mm sub-systems, but score need export
+ */
+EXPORT_SYMBOL(min_low_pfn);
+EXPORT_SYMBOL(max_low_pfn);
-- 
1.9.2.459.g68773ac
