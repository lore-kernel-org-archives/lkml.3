Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3LRSYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:24:43 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40097 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3LRSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:24:41 -0500
Date: Wed, 18 Dec 2013 23:54:32 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 1/4] drivers: target: Move prototype declaration of function
 to header file target_core_pr.h
Message-ID: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of function
spc_parse_naa_6h_vendor_specific() from target_core_xcopy.c to header
file target_core_pr.h because it is used by more than one file.

This eliminates the following warning in target_core_spc.c:
drivers/target/target_core_spc.c:138:6: warning: no previous prototype for ‘spc_parse_naa_6h_vendor_specific’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/target/target_core_pr.h    |    5 +++++
 drivers/target/target_core_xcopy.c |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index ed75cdd..2ee2936 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -43,6 +43,11 @@
 #define PR_APTPL_MAX_IPORT_LEN			256
 #define PR_APTPL_MAX_TPORT_LEN			256
 
+/*
+ *  Function defined in target_core_spc.c
+ */
+void spc_parse_naa_6h_vendor_specific(struct se_device *, unsigned char *);
+
 extern struct kmem_cache *t10_pr_reg_cache;
 
 extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 6b88a99..669c536 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -40,10 +40,6 @@
 
 static struct workqueue_struct *xcopy_wq = NULL;
 /*
- * From target_core_spc.c
- */
-extern void spc_parse_naa_6h_vendor_specific(struct se_device *, unsigned char *);
-/*
  * From target_core_device.c
  */
 extern struct mutex g_device_mutex;
-- 
1.7.9.5

