Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3LCOyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:54:43 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64641 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3LCOve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:34 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 5/9] staging/lustre: fix defined not used warning
Date: Tue,  3 Dec 2013 22:42:04 +0800
Message-Id: <1386081729-9481-8-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_sysctl_table/unregister_sysctl_table are defined
regardless of CONFIG_SYSCTL true or false. so we don't need
to surround them with #ifdef CONFIG_SYSCTL. Besides, current
code got build warnings when CONFIG_SYSCTL is not set:
drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c:368:20: warning:
‘lnet_table’ defined but not used [-Wunused-variable]

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/lnet/router_proc.c     |    4 ----
 .../lustre/lustre/libcfs/linux/linux-proc.c        |    8 --------
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index daaa043..e4fe7a1 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -908,21 +908,17 @@ static ctl_table_t top_table[] = {
 void
 lnet_proc_init(void)
 {
-#ifdef CONFIG_SYSCTL
 	if (lnet_table_header == NULL)
 		lnet_table_header = register_sysctl_table(top_table);
-#endif
 }
 
 void
 lnet_proc_fini(void)
 {
-#ifdef CONFIG_SYSCTL
 	if (lnet_table_header != NULL)
 		unregister_sysctl_table(lnet_table_header);
 
 	lnet_table_header = NULL;
-#endif
 }
 
 #else
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index ef0ab10..e947b91 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
@@ -65,9 +65,7 @@
 #include <asm/div64.h>
 #include "tracefile.h"
 
-#ifdef CONFIG_SYSCTL
 static ctl_table_header_t *lnet_table_header = NULL;
-#endif
 extern char lnet_upcall[1024];
 /**
  * The path of debug log dump upcall script.
@@ -518,7 +516,6 @@ static ctl_table_t lnet_table[] = {
 	}
 };
 
-#ifdef CONFIG_SYSCTL
 static ctl_table_t top_table[] = {
 	{
 		.procname = "lnet",
@@ -530,23 +527,18 @@ static ctl_table_t top_table[] = {
 	{
 	}
 };
-#endif
 
 int insert_proc(void)
 {
-#ifdef CONFIG_SYSCTL
 	if (lnet_table_header == NULL)
 		lnet_table_header = register_sysctl_table(top_table);
-#endif
 	return 0;
 }
 
 void remove_proc(void)
 {
-#ifdef CONFIG_SYSCTL
 	if (lnet_table_header != NULL)
 		unregister_sysctl_table(lnet_table_header);
 
 	lnet_table_header = NULL;
-#endif
 }
-- 
1.7.9.5

