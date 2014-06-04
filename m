Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaFDO6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:58:46 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49228 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaFDO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:58:44 -0400
From: "Adithya.K" <linux.challenge1@gmail.com>
To: omar.ramirez@copitl.com, gregkh@linuxfoundation.org,
        rashika.kheria@gmail.com, freemangordon@abv.bg,
        dan.carpenter@oracle.com, ody.guru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Adithya K <linux.challenge1@gmail.com>
Subject: [PATCH] Staging:tidspbridge Fix minor checkpatch.pl warning.
Date: Wed,  4 Jun 2014 20:28:36 +0530
Message-Id: <1401893916-23366-1-git-send-email-linux.challenge1@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adithya K <linux.challenge1@gmail.com>

Fixed few checkpatch.pl warnings.

Signed-off-by: Adithya K <linux.challenge1@gmail.com>
---
 drivers/staging/tidspbridge/pmgr/chnl.c   |    1 +
 drivers/staging/tidspbridge/pmgr/dspapi.c |    8 ++++----
 drivers/staging/tidspbridge/rmgr/dbdcd.c  |    1 +
 drivers/staging/tidspbridge/rmgr/nldr.c   |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index 4bd8686..e03c326 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -75,6 +75,7 @@ int chnl_create(struct chnl_mgr **channel_mgr,
 
 	if (!status) {
 		struct bridge_drv_interface *intf_fxns;
+
 		dev_get_intf_fxns(hdev_obj, &intf_fxns);
 		/* Let Bridge channel module finish the create: */
 		status = (*intf_fxns->chnl_create) (&hchnl_mgr, hdev_obj,
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index b7d5c8c..8fb6ed7 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -64,7 +64,7 @@
 
 /* Device IOCtl function pointer */
 struct api_cmd {
-	u32(*fxn) (union trapped_args *args, void *pr_ctxt);
+	u32 (*fxn)(union trapped_args *args, void *pr_ctxt);
 	u32 index;
 };
 
@@ -206,7 +206,7 @@ static inline void _cp_to_usr(void __user *to, const void *from,
 inline int api_call_dev_ioctl(u32 cmd, union trapped_args *args,
 				      u32 *result, void *pr_ctxt)
 {
-	u32(*ioctl_cmd) (union trapped_args *args, void *pr_ctxt) = NULL;
+	u32 (*ioctl_cmd)(union trapped_args *args, void *pr_ctxt) = NULL;
 	int i;
 
 	if (_IOC_TYPE(cmd) != DB) {
@@ -766,7 +766,7 @@ u32 procwrap_load(union trapped_args *args, void *pr_ctxt)
 		goto func_cont;
 	}
 
-	argv = kmalloc(count * sizeof(u8 *), GFP_KERNEL);
+	argv = kmalloc_array(count, sizeof(u8 *), GFP_KERNEL);
 	if (!argv) {
 		status = -ENOMEM;
 		goto func_cont;
@@ -812,7 +812,7 @@ u32 procwrap_load(union trapped_args *args, void *pr_ctxt)
 			}
 			count++;
 		} while (temp);
-		envp = kmalloc(count * sizeof(u8 *), GFP_KERNEL);
+		envp = kmalloc_array(count, sizeof(u8 *), GFP_KERNEL);
 		if (!envp) {
 			status = -ENOMEM;
 			goto func_cont;
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 2ae48c9..c91d1d7 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -489,6 +489,7 @@ int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 	strncpy(sz_sect_name, ".", 2);
 	do {
 		char *uuid = strsep(&tmp, "-");
+
 		if (!uuid)
 			break;
 		len -= strlen(uuid);
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 5ac507c..bddf6e5 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -239,7 +239,7 @@ struct nldr_nodeobject {
 	 *  Mask indicating whether each mem segment specified in seg_id[]
 	 *  is preferred or required.
 	 *  For example
-	 *  	if (code_data_flag_mask & (1 << EXECUTEDATAFLAGBIT)) != 0,
+	 *	if (code_data_flag_mask & (1 << EXECUTEDATAFLAGBIT)) != 0,
 	 *  then it is required to load execute phase data into the memory
 	 *  specified by seg_id[EXECUTEDATAFLAGBIT].
 	 */
-- 
1.7.9.5

