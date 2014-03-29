Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaC2SrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:47:10 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45330 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaC2SrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:47:08 -0400
Date: Sun, 30 Mar 2014 00:17:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 51/55] scsi: Move prototype declaration to header file
 megaraid/megaraid_sas_fusion.h from megaraid/megaraid_sas_base.c
Message-ID: <c3ef8857a4533ed6282301f74cec5a4b42e75944.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of functions to header file
megaraid/megaraid_sas_fusion.h from megaraid/megaraid_sas_base.c because
they are used by more than one file.

This eliminates the following type of warnings in
megaraid/megaraid_sas_fusion.c:
drivers/scsi/megaraid/megaraid_sas_fusion.c:2170:1: warning: no previous prototype for ‘megasas_release_fusion’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |   13 -------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9768deee..0ad386b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -160,21 +160,8 @@ u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
 static void megasas_complete_cmd_dpc(unsigned long instance_addr);
-void
-megasas_release_fusion(struct megasas_instance *instance);
-int
-megasas_ioc_init_fusion(struct megasas_instance *instance);
-void
-megasas_free_cmds_fusion(struct megasas_instance *instance);
-u8
-megasas_get_map_info(struct megasas_instance *instance);
-int
-megasas_sync_map_info(struct megasas_instance *instance);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
-void megasas_reset_reply_desc(struct megasas_instance *instance);
-int megasas_reset_fusion(struct Scsi_Host *shost);
-void megasas_fusion_ocr_wq(struct work_struct *work);
 
 static void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 35a5139..01e5ab3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -760,4 +760,18 @@ union desc_value {
 	} u;
 };
 
+void
+megasas_release_fusion(struct megasas_instance *instance);
+int
+megasas_ioc_init_fusion(struct megasas_instance *instance);
+void
+megasas_free_cmds_fusion(struct megasas_instance *instance);
+u8
+megasas_get_map_info(struct megasas_instance *instance);
+int
+megasas_sync_map_info(struct megasas_instance *instance);
+void megasas_reset_reply_desc(struct megasas_instance *instance);
+int megasas_reset_fusion(struct Scsi_Host *shost);
+void megasas_fusion_ocr_wq(struct work_struct *work);
+
 #endif /* _MEGARAID_SAS_FUSION_H_ */
-- 
1.7.9.5

