Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaEOVxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:53:11 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:38381 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaEOVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:53:09 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Masood Mehmood <ody.guru@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=5D=20Fix=20for=20possible=20null=20pointer=20dereference=20in=20node=2Ec?=
Date: Thu, 15 May 2014 23:53:53 +0200
Message-Id: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/tidspbridge/rmgr/node.c |    4 ++--
 1 fil ändrad, 2 tillägg(+), 2 borttagningar(-)

diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 9d3044a..94c2cce 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -2361,8 +2361,7 @@ static void delete_node(struct node_object *hnode,
 	struct node_taskargs task_arg_obj;
 #ifdef DSP_DMM_DEBUG
 	struct dmm_object *dmm_mgr;
-	struct proc_object *p_proc_object =
-	    (struct proc_object *)hnode->processor;
+	struct proc_object *p_proc_object;
 #endif
 	int status;
 	if (!hnode)
@@ -2431,6 +2430,7 @@ static void delete_node(struct node_object *hnode,
 							dsp_heap_res_addr,
 							pr_ctxt);
 #ifdef DSP_DMM_DEBUG
+			p_proc_object = (struct proc_object *)hnode->processor;
 			status = dmm_get_handle(p_proc_object, &dmm_mgr);
 			if (dmm_mgr)
 				dmm_mem_map_dump(dmm_mgr);
-- 
1.7.10.4

