Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaG0RIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 13:08:40 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64591 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaG0RIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 13:08:39 -0400
From: Nicolas Thery <nthery@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org, me@aldo.io
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, nthery@gmail.com
Subject: [PATCH] staging: ft1000: fix some checkpatch complaints
Date: Sun, 27 Jul 2014 19:08:33 +0200
Message-Id: <1406480913-31378-1-git-send-email-nthery@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following errors and warnings:

ft1000_proc.c:26: WARNING: Use #include <linux/io.h> instead of <asm/io.h>
ft1000_proc.c:27: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
ft1000_proc.c:33: ERROR: Macros with multiple statements should be enclosed in a do - while loop
ft1000_proc.c:40: ERROR: Macros with multiple statements should be enclosed in a do - while loop
ft1000_proc.c:49: WARNING: static const char * array should probably be static const char * const
ft1000_proc.c:53: WARNING: static const char * array should probably be static const char * const

Signed-off-by: Nicolas Thery <nthery@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index 88f6f9c..28a2744 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -23,34 +23,38 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/netdevice.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include "ft1000.h"
 
 #define FT1000_PROC "ft1000"
 #define MAX_FILE_LEN 255
 
-#define seq_putx(m, message, size, var) \
+#define seq_putx(m, message, size, var) do { \
 	seq_printf(m, message);	\
 	for (i = 0; i < (size - 1); i++) { \
 		seq_printf(m, "%02x:", var[i]); \
 	} \
-	seq_printf(m, "%02x\n", var[i])
+	seq_printf(m, "%02x\n", var[i]); \
+} while (0)
 
-#define seq_putd(m, message, size, var) \
+#define seq_putd(m, message, size, var) do { \
 	seq_printf(m, message); \
 	for (i = 0; i < (size - 1); i++) { \
 		seq_printf(m, "%d.", var[i]); \
 	} \
-	seq_printf(m, "%d\n", var[i])
+	seq_printf(m, "%d\n", var[i]); \
+} while (0)
 
 static int ft1000ReadProc(struct seq_file *m, void *v)
 {
-	static const char *status[] = {
+	static const char * const status[] = {
 		"Idle (Disconnect)", "Searching", "Active (Connected)",
 		"Waiting for L2", "Sleep", "No Coverage", "", ""
 	};
-	static const char *signal[] = { "", "*", "**", "***", "****" };
+	static const char * const signal[] = {
+		"", "*", "**", "***", "****"
+	};
 
 	struct net_device *dev = m->private;
 	struct ft1000_info *info = netdev_priv(dev);
-- 
1.9.1

