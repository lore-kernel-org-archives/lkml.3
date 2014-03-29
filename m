Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaC2SPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:15:13 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38136 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaC2SPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:15:10 -0400
Date: Sat, 29 Mar 2014 23:45:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 28/55] scsi: Move prototype declaration to appropriate header
 file megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c
Message-ID: <e9f8d6d290802d1bd1006e01cbe5f6d2503d07a2.1396114898.git.rashika.kheria@gmail.com>
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

Move prototype declarations of function to header file
scsi/megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c because
they are used by more than one file.

This eliminates the following warning in megaraid/megaraid_sas_fusion.c:
drivers/scsi/megaraid/megaraid_sas_base.c:192:21: warning: no previous prototype for ‘megasas_get_cmd’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:218:1: warning: no previous prototype for ‘megasas_return_cmd’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:878:1: warning: no previous prototype for ‘megasas_issue_polled’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:1364:12: warning: no previous prototype for ‘megasas_is_ldio’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:1639:6: warning: no previous prototype for ‘megaraid_sas_kill_hba’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:1659:1: warning: no previous prototype for ‘megasas_check_and_restore_queue_depth’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:3030:6: warning: no previous prototype for ‘megasas_free_cmds’ [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:3066:5: warning: no previous prototype for ‘megasas_alloc_cmds’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   14 ++++++++++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   13 -------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 34452ea..3b0afb4 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1723,6 +1723,20 @@ struct megasas_mgmt_info {
 	int max_index;
 };
 
+struct megasas_cmd *megasas_get_cmd(struct megasas_instance
+				    *instance);
+void
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
+int
+megasas_issue_polled(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd);
+int megasas_is_ldio(struct scsi_cmnd *cmd);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+void
+megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+void megasas_free_cmds(struct megasas_instance *instance);
+int megasas_alloc_cmds(struct megasas_instance *instance);
+
 u8
 MR_BuildRaidContext(struct megasas_instance *instance,
 		    struct IO_REQUEST_INFO *io_info,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f655592..2806d6d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -54,31 +54,18 @@
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
 
-extern void megasas_free_cmds(struct megasas_instance *instance);
-extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-					   *instance);
 extern void
 megasas_complete_cmd(struct megasas_instance *instance,
 		     struct megasas_cmd *cmd, u8 alt_status);
-int megasas_is_ldio(struct scsi_cmnd *cmd);
 int
 wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
 
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
-int megasas_alloc_cmds(struct megasas_instance *instance);
 int
 megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
-int
-megasas_issue_polled(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd);
-void
-megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
 
 u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
 			   struct IO_REQUEST_INFO *in_info);
 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
-void megaraid_sas_kill_hba(struct megasas_instance *instance);
 
 extern u32 megasas_dbg_lvl;
 extern int resetwaittime;
-- 
1.7.9.5

