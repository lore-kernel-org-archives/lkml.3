Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbaGWJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:25:29 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35200 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbaGWJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:25:26 -0400
Subject: [PATCH 1/2] printk: Add function to return log buffer address and
 size
To: linux-kernel@vger.kernel.org
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Date: Wed, 23 Jul 2014 14:55:17 +0530
Message-ID: <20140723092506.5170.34633.stgit@hegdevasant.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072309-0260-0000-0000-000005702883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms like IBM Power Systems supports service processor
assisted dump. It provides interface to add memory region to
be captured when system is crashed.

During initialization/running we can add kernel memory region
to be collected.

Presently we don't have a way to get the log buffer base address
and size. This patch adds support to return log buffer address
and size.


Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>

---
Next patch extends arch specific code to add log buffer to platform
dump.

 include/linux/printk.h |    3 +++
 kernel/printk/printk.c |   12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 319ff7e..aae82c4 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -10,6 +10,9 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+extern void *get_log_buf_addr(void);
+extern u32 get_log_buf_len(void);
+
 static inline int printk_get_level(const char *buffer)
 {
 	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839d..4049f7b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -270,6 +270,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/* Return log buffer address */
+void *get_log_buf_addr(void)
+{
+	return log_buf;
+}
+
+/* Return log buffer size */
+u32 get_log_buf_len(void)
+{
+	return log_buf_len;
+}
+
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {

