Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaCACP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:15:56 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35783 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaCACPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:15:55 -0500
Date: Fri, 28 Feb 2014 18:15:52 -0800
From: Masood Mehmood <ody.guru@gmail.com>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:tidspbridge: Fixing coding style
Message-ID: <20140301021552.GB32665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch.txt"


Fixing some basic coding style issues.

Signed-off-by: Masood Mehmood <ody.guru@gmail.com>
---
 drivers/staging/tidspbridge/rmgr/node.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 87dfa92..76f885f 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -246,7 +246,7 @@ static void fill_stream_def(struct node_object *hnode,
 			    struct node_strmdef *pstrm_def,
 			    struct dsp_strmattr *pattrs);
 static void free_stream(struct node_mgr *hnode_mgr, struct stream_chnl stream);
-static int get_fxn_address(struct node_object *hnode, u32 * fxn_addr,
+static int get_fxn_address(struct node_object *hnode, u32 *fxn_addr,
 				  u32 phase);
 static int get_node_props(struct dcd_manager *hdcd_mgr,
 				 struct node_object *hnode,
@@ -406,7 +406,7 @@ int node_allocate(struct proc_object *hprocessor,
 
 	/* check for page aligned Heap size */
 	if (((attr_in->heap_size) & (PG_SIZE4K - 1))) {
-		pr_err("%s: node heap size not aligned to 4K, size = 0x%x \n",
+		pr_err("%s: node heap size not aligned to 4K, size = 0x%x",
 		       __func__, attr_in->heap_size);
 		status = -EINVAL;
 	} else {
@@ -425,7 +425,7 @@ int node_allocate(struct proc_object *hprocessor,
 					task_arg_obj.dsp_heap_res_addr),
 				     pr_ctxt);
 	if (status) {
-		pr_err("%s: Failed to reserve memory for heap: 0x%x\n",
+		pr_err("%s: Failed to reserve memory for heap: 0x%x",
 		       __func__, status);
 		goto func_cont;
 	}
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
@@ -1576,7 +1575,7 @@ func_end:
  *  Purpose:
  *      Frees the message buffer.
  */
-int node_free_msg_buf(struct node_object *hnode, u8 * pbuffer,
+int node_free_msg_buf(struct node_object *hnode, u8 *pbuffer,
 			     struct dsp_bufferattr *pattr)
 {
 	struct node_object *pnode = (struct node_object *)hnode;
@@ -2322,7 +2321,8 @@ int node_terminate(struct node_object *hnode, int *pstatus)
 			if (!hdeh_mgr)
 				goto func_cont;
 
-			bridge_deh_notify(hdeh_mgr, DSP_SYSERROR, DSP_EXCEPTIONABORT);
+			bridge_deh_notify(hdeh_mgr, DSP_SYSERROR,
+							DSP_EXCEPTIONABORT);
 		}
 	}
 func_cont:
@@ -2640,8 +2640,7 @@ static void free_stream(struct node_mgr *hnode_mgr, struct stream_chnl stream)
  *  Purpose:
  *      Retrieves the address for create, execute or delete phase for a node.
  */
-static int get_fxn_address(struct node_object *hnode, u32 * fxn_addr,
-				  u32 phase)
+static int get_fxn_address(struct node_object *hnode, u32 *fxn_addr, u32 phase)
 {
 	char *pstr_fxn_name = NULL;
 	struct node_mgr *hnode_mgr = hnode->node_mgr;
-- 
1.8.1.4


--17pEHd4RhPHOinZp--
