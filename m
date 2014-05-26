Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaEZPVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:21:40 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57113 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaEZPVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:21:36 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: qla2xxx-upstream@qlogic.com
Cc: benoit.taine@lip6.fr, "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 7/18] qla2xxx: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:16 +0200
Message-Id: <1401117687-28911-8-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/scsi/qla2xxx/qla_mbx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7f39e36..1c33a77 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1319,7 +1319,7 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
 
 		left = 0;
 
-		list = kzalloc(dma_size, GFP_KERNEL);
+		list = kmemdup(pmap, dma_size, GFP_KERNEL);
 		if (!list) {
 			ql_log(ql_log_warn, vha, 0x1140,
 			    "%s(%ld): failed to allocate node names list "
@@ -1328,7 +1328,6 @@ qla2x00_get_node_name_list(scsi_qla_host_t *vha, void **out_data, int *out_len)
 			goto out_free;
 		}
 
-		memcpy(list, pmap, dma_size);
 restart:
 		dma_free_coherent(&ha->pdev->dev, dma_size, pmap, pmap_dma);
 	}

