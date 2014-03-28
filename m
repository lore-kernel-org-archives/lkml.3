Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaC1Nzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:55:47 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45222 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaC1Nzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:55:40 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 16/28] ktap: add runtime/amalg.c
Date: Fri, 28 Mar 2014 09:47:37 -0400
Message-Id: <1396014469-5937-17-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use amalgamation build make ktapvm.ko much smaller.

No amalgamation build in x86_64:
ktapvm.ko: 2.4M

amalgamation build in x86_64:
ktapvm.ko: 1.1M

User can set use amalgamation build or not in Makefile.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/runtime/amalg.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 tools/ktap/runtime/amalg.c

diff --git a/tools/ktap/runtime/amalg.c b/tools/ktap/runtime/amalg.c
new file mode 100644
index 0000000..9935ccf
--- /dev/null
+++ b/tools/ktap/runtime/amalg.c
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

