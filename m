Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaCDFW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 00:22:28 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:51146 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaCDFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 00:22:26 -0500
From: Masood Mehmood <ody.guru@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:tidspbridge: Fixed braces, spaces and long line coding style
Date: Mon,  3 Mar 2014 00:32:10 -0800
Message-Id: <1393835530-6524-1-git-send-email-ody.guru@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies following code style changes to the whole driver.

- Removing braces from single statements following a 'if' statement.
- Removing unnessasary spaces and braces from files.
- Re-order statements crossing 80 columns limitation.
- Fixed one quoted string split across lines.

Signed-off-by: Masood Mehmood <ody.guru@gmail.com>
---
 drivers/staging/tidspbridge/core/io_sm.c          |  2 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c | 15 +++++++++------
 drivers/staging/tidspbridge/rmgr/nldr.c           |  3 +--
 drivers/staging/tidspbridge/rmgr/node.c           | 14 +++++++-------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index e322fb7..c2829aa 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -2127,7 +2127,7 @@ void dump_dl_modules(struct bridge_dev_context *bridge_context)
 	u32 module_size;
 	u32 module_struct_size = 0;
 	u32 sect_ndx;
-	char *sect_str ;
+	char *sect_str;
 	int status = 0;
 
 	status = dev_get_intf_fxns(dev_object, &intf_fxns);
diff --git a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
index 1862afd..657104f 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430_pwr.c
@@ -99,7 +99,8 @@ int handle_hibernation_from_dsp(struct bridge_dev_context *dev_context)
 			return -EPERM;
 		}
 		pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
-					OMAP2_PM_PWSTST) & OMAP_POWERSTATEST_MASK;
+						   OMAP2_PM_PWSTST) &
+						   OMAP_POWERSTATEST_MASK;
 	}
 	if (timeout == 0) {
 		pr_err("%s: Timed out waiting for DSP off mode\n", __func__);
@@ -209,7 +210,8 @@ int sleep_dsp(struct bridge_dev_context *dev_context, u32 dw_cmd,
 			return -EPERM;
 		}
 		pwr_state = (*pdata->dsp_prm_read)(OMAP3430_IVA2_MOD,
-					OMAP2_PM_PWSTST) & OMAP_POWERSTATEST_MASK;
+						   OMAP2_PM_PWSTST) &
+						   OMAP_POWERSTATEST_MASK;
 	}
 
 	if (!timeout) {
@@ -355,7 +357,7 @@ int pre_scale_dsp(struct bridge_dev_context *dev_context, void *pargs)
 	    (dev_context->brd_state == BRD_DSP_HIBERNATION)) {
 		dev_dbg(bridge, "OPP: %s IVA in sleep. No message to DSP\n");
 		return 0;
-	} else if ((dev_context->brd_state == BRD_RUNNING)) {
+	} else if (dev_context->brd_state == BRD_RUNNING) {
 		/* Send a prenotification to DSP */
 		dev_dbg(bridge, "OPP: %s sent notification to DSP\n", __func__);
 		sm_interrupt_dsp(dev_context, MBX_PM_SETPOINT_PRENOTIFY);
@@ -396,13 +398,14 @@ int post_scale_dsp(struct bridge_dev_context *dev_context,
 		io_sh_msetting(hio_mgr, SHM_CURROPP, &level);
 		dev_dbg(bridge, "OPP: %s IVA in sleep. Wrote to shm\n",
 			__func__);
-	} else if ((dev_context->brd_state == BRD_RUNNING)) {
+	} else if (dev_context->brd_state == BRD_RUNNING) {
 		/* Update the OPP value in shared memory */
 		io_sh_msetting(hio_mgr, SHM_CURROPP, &level);
 		/* Send a post notification to DSP */
 		sm_interrupt_dsp(dev_context, MBX_PM_SETPOINT_POSTNOTIFY);
-		dev_dbg(bridge, "OPP: %s wrote to shm. Sent post notification "
-			"to DSP\n", __func__);
+		dev_dbg(bridge,
+			"OPP: %s wrote to shm. Sent post notification to DSP\n",
+			 __func__);
 	} else {
 		status = -EPERM;
 	}
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 7e10c95..5ac507c 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -1751,9 +1751,8 @@ static void unload_ovly(struct nldr_nodeobject *nldr_node_obj,
 	}
 	if (ref_count && (*ref_count > 0)) {
 		*ref_count -= 1;
-		if (other_ref) {
+		if (other_ref)
 			*other_ref -= 1;
-		}
 	}
 
 	if (ref_count && *ref_count == 0) {
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index c0211dd..9d3044a 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -406,7 +406,7 @@ int node_allocate(struct proc_object *hprocessor,
 
 	/* check for page aligned Heap size */
 	if (((attr_in->heap_size) & (PG_SIZE4K - 1))) {
-		pr_err("%s: node heap size not aligned to 4K, size = 0x%x \n",
+		pr_err("%s: node heap size not aligned to 4K, size = 0x%x\n",
 		       __func__, attr_in->heap_size);
 		status = -EINVAL;
 	} else {
@@ -703,9 +703,9 @@ DBAPI node_alloc_msg_buf(struct node_object *hnode, u32 usize,
 		pattr = &node_dfltbufattrs;	/* set defaults */
 
 	status = proc_get_processor_id(pnode->processor, &proc_id);
-	if (proc_id != DSP_UNIT) {
+	if (proc_id != DSP_UNIT)
 		goto func_end;
-	}
+
 	/*  If segment ID includes MEM_SETVIRTUALSEGID then pbuffer is a
 	 *  virt  address, so set this info in this node's translator
 	 *  object for  future ref. If MEM_GETVIRTUALSEGID then retrieve
@@ -886,11 +886,10 @@ int node_connect(struct node_object *node1, u32 stream1,
 	if (pattrs && pattrs->strm_mode != STRMMODE_PROCCOPY)
 		return -EPERM;	/* illegal stream mode */
 
-	if (node1_type != NODE_GPP) {
+	if (node1_type != NODE_GPP)
 		hnode_mgr = node1->node_mgr;
-	} else {
+	else
 		hnode_mgr = node2->node_mgr;
-	}
 
 	/* Enter critical section */
 	mutex_lock(&hnode_mgr->node_mgr_lock);
@@ -2322,7 +2321,8 @@ int node_terminate(struct node_object *hnode, int *pstatus)
 			if (!hdeh_mgr)
 				goto func_cont;
 
-			bridge_deh_notify(hdeh_mgr, DSP_SYSERROR, DSP_EXCEPTIONABORT);
+			bridge_deh_notify(hdeh_mgr, DSP_SYSERROR,
+					  DSP_EXCEPTIONABORT);
 		}
 	}
 func_cont:
-- 
1.8.3.1

