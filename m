Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3BCB1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:27:23 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3BCBWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:50 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 47/62] scsi/lpfc: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:48 -0800
Message-Id: <1359854463-2538-48-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/scsi/lpfc/lpfc_init.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 89ad558..7de4ef14 100644
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

