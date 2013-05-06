Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3EFHYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:24:34 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41670 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EFHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:24:33 -0400
From: Jassi Brar <jassisinghbrar@gmail.com>
To: s-anna@ti.com, loic.pallardy@st.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCHv2 1/4] mailbox: rename pl320-ipc specific mailbox.h
Date: Mon,  6 May 2013 12:53:44 +0530
Message-Id: <1367825024-6195-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

The patch 30058677 "ARM / highbank: add support for pl320 IPC"
added a pl320 IPC specific header file as a generic mailbox.h.
This file has been renamed appropriately to allow the
introduction of the generic mailbox API framework.

Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/cpufreq/highbank-cpufreq.c |    2 +-
 drivers/mailbox/pl320-ipc.c        |    2 +-
 include/linux/mailbox.h            |   17 -----------------
 include/linux/pl320-ipc.h          |   17 +++++++++++++++++
 4 files changed, 19 insertions(+), 19 deletions(-)
 delete mode 100644 include/linux/mailbox.h
 create mode 100644 include/linux/pl320-ipc.h

diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
index b61b5a3..3118b87 100644
--- a/drivers/cpufreq/highbank-cpufreq.c
+++ b/drivers/cpufreq/highbank-cpufreq.c
@@ -19,7 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/of.h>
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 #include <linux/platform_device.h>
 
 #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index d873cba..f3755e0 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -26,7 +26,7 @@
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 
-#include <linux/mailbox.h>
+#include <linux/pl320-ipc.h>
 
 #define IPCMxSOURCE(m)		((m) * 0x40)
 #define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
deleted file mode 100644
index 5161f63..0000000
--- a/include/linux/mailbox.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-int pl320_ipc_transmit(u32 *data);
-int pl320_ipc_register_notifier(struct notifier_block *nb);
-int pl320_ipc_unregister_notifier(struct notifier_block *nb);
diff --git a/include/linux/pl320-ipc.h b/include/linux/pl320-ipc.h
new file mode 100644
index 0000000..5161f63
--- /dev/null
+++ b/include/linux/pl320-ipc.h
@@ -0,0 +1,17 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+int pl320_ipc_transmit(u32 *data);
+int pl320_ipc_register_notifier(struct notifier_block *nb);
+int pl320_ipc_unregister_notifier(struct notifier_block *nb);
-- 
1.7.10.4

