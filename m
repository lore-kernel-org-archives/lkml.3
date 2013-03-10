Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab3CJMLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:11:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60102 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3CJMLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:11:18 -0400
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
To: iss_storagedev@hp.com
Cc: mike.miller@hp.com, linux-kernel@vger.kernel.org,
        Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: [PATCH] block: don't cast kmalloc() return value
Date: Sun, 10 Mar 2013 14:11:09 +0200
Message-Id: <1362917469-20015-1-git-send-email-mihneadb@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
---
 drivers/block/cciss_scsi.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index da33111..13a70d8 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -705,8 +705,7 @@ cciss_scsi_setup(ctlr_info_t *h)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[h->ctlr].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
-- 
1.7.10.4

