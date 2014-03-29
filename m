Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaC2SsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:48:23 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42528 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaC2SsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:48:21 -0400
Date: Sun, 30 Mar 2014 00:18:46 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 52/55] scsi: Move prototype declaration to header file
 megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c
Message-ID: <f1f0ea7aadc1c722efdcbaecf3ac9d8dfe3afc5d.1396114898.git.rashika.kheria@gmail.com>
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

Move prototype declaration of function to header file
megaraid/megaraid_sas.h from megaraid/megaraid_sas_fusion.c because it
is used by more than one file.

This eliminates the following warning in megaraid/megaraid_sas_fp.c:
drivers/scsi/megaraid/megaraid_sas_fp.c:1223:5: warning: no previous prototype for ‘get_updated_dev_handle’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        |    3 +++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 3b0afb4..17fe706 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1737,6 +1737,9 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
 void megasas_free_cmds(struct megasas_instance *instance);
 int megasas_alloc_cmds(struct megasas_instance *instance);
 
+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *in_info);
+
 u8
 MR_BuildRaidContext(struct megasas_instance *instance,
 		    struct IO_REQUEST_INFO *io_info,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ce6219c..b3d79f4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -63,8 +63,6 @@ wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
 int
 megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
 
-u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
-			   struct IO_REQUEST_INFO *in_info);
 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 
 extern u32 megasas_dbg_lvl;
-- 
1.7.9.5

