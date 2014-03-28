Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaC2P0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:26:42 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35666 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaC2P0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:26:40 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 16/29] ktap: add amalgamation build(kernel/trace/ktap/amalg.c)
Date: Fri, 28 Mar 2014 10:45:11 -0400
Message-Id: <1396017924-7754-17-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This compiles the ktapvm as one huge C file and allows
GCC to generate faster and shorter code.

No amalgamation build in x86_64:
ktapvm.ko: 3.1M

amalgamation build in x86_64:
ktapvm.ko: 1.1M

User can set use amalgamation build or not in Makefile.

(Need to analyze further why have so big differences)

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 kernel/trace/ktap/amalg.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 kernel/trace/ktap/amalg.c

diff --git a/kernel/trace/ktap/amalg.c b/kernel/trace/ktap/amalg.c
new file mode 100644
index 0000000..9935ccf
--- /dev/null
+++ b/kernel/trace/ktap/amalg.c
@@ -0,0 +1,37 @@
+/*
+ * amalg.c - ktapvm kernel module amalgamation.
+ *
+ * This file is part of ktap by Jovi Zhangwei.
+ *
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ *
+ * ktap is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * ktap is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "ktap.c"
+#include "kp_obj.c"
+#include "kp_bcread.c"
+#include "kp_str.c"
+#include "kp_mempool.c"
+#include "kp_tab.c"
+#include "kp_transport.c"
+#include "kp_vm.c"
+#include "kp_events.c"
+#include "lib_base.c"
+#include "lib_ansi.c"
+#include "lib_kdebug.c"
+#include "lib_timer.c"
+#include "lib_table.c"
+#include "lib_net.c"
+
-- 
1.8.1.4

