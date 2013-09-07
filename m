Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3IGIkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 04:40:47 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:38216 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3IGIkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 04:40:45 -0400
Message-ID: <522AE4E9.203@gmail.com>
Date: Sat, 07 Sep 2013 10:33:45 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/19] pramfs: test module
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add test module.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/pramfs/pramfs_test.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)
 create mode 100644 fs/pramfs/pramfs_test.c

diff --git a/fs/pramfs/pramfs_test.c b/fs/pramfs/pramfs_test.c
new file mode 100644
index 0000000..7acfda2
--- /dev/null
+++ b/fs/pramfs/pramfs_test.c
@@ -0,0 +1,47 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Pramfs test module.
+ *
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include "pram.h"
+
+int __init test_pramfs_write(void)
+{
+	struct pram_super_block *psb;
+
+	psb = get_pram_super();
+	if (!psb) {
+		printk(KERN_ERR
+			"%s: PRAMFS super block not found (not mounted?)\n",
+			__func__);
+		return 1;
+	}
+
+	/*
+	 * Attempt an unprotected clear of checksum information in the
+	 * superblock, this should cause a kernel page protection fault.
+	 */
+	printk("%s: writing to kernel VA %p\n", __func__, psb);
+	psb->s_sum = 0;
+
+	return 0;
+}
+
+void test_pramfs_write_cleanup(void) {}
+
+/* Module information */
+MODULE_LICENSE("GPL");
+module_init(test_pramfs_write);
+module_exit(test_pramfs_write_cleanup);
-- 
1.7.3.4
