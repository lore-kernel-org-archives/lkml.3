Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab3BFT4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:56:39 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42431 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030235Ab3BFTvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:06 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 63/77] scsi/lpfc: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:35 -0800
Message-Id: <1360179649-22465-64-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/lpfc/lpfc_init.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 26ca2ef..314b4f6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3165,14 +3165,10 @@ destroy_port(struct lpfc_vport *vport)
 int
 lpfc_get_instance(void)
 {
-	int instance = 0;
-
-	/* Assign an unused number */
-	if (!idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&lpfc_hba_index, NULL, &instance))
-		return -1;
-	return instance;
+	int ret;
+
+	ret = idr_alloc(&lpfc_hba_index, NULL, 0, 0, GFP_KERNEL);
+	return ret < 0 ? -1 : ret;
 }
 
 /**
-- 
1.8.1

