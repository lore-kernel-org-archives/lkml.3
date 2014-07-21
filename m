Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaGUKQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:16:30 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59946 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaGUKQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:16:29 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, joe@perches.com,
        Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH v3 1/3] staging: lustre: lov: Cleanup lov_check_set() in lov_request.c
Date: Mon, 21 Jul 2014 12:15:55 +0200
Message-Id: <1405937757-16504-2-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
References: <1405870223.5135.6.camel@joe-AO725>
 <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code clearer by introducing a local variable and removing the
unnecessary 'if' statement.

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Changes in v3:
 - Renamed the local variable 'desc' to 'tgt' to be consistent with
   other definitions in the driver.

Changes in v2:
 - Improved the commit message:
    - changed the subject line to follow the same convention used by
      previous commits to the same file.
    - rewrote the message body using a more formal language.
 - Introduced a local variable to make the code clearer.
 - Added Acked-by - Julia.

 drivers/staging/lustre/lustre/lov/lov_request.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index ce830e4..da424de 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -140,14 +140,14 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
 
 static int lov_check_set(struct lov_obd *lov, int idx)
 {
-	int rc = 0;
+	int rc;
+	struct lov_tgt_desc *tgt;
 	mutex_lock(&lov->lov_lock);
 
-	if (lov->lov_tgts[idx] == NULL ||
-	    lov->lov_tgts[idx]->ltd_active ||
-	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
-	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
-		rc = 1;
+	tgt = lov->lov_tgts[idx];
+	rc = !tgt || tgt->ltd_active ||
+		(tgt->ltd_exp &&
+		 class_exp2cliimp(tgt->ltd_exp)->imp_connect_tried);
 
 	mutex_unlock(&lov->lov_lock);
 	return rc;
-- 
1.9.1

