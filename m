Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaGTNW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 09:22:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34455 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaGTNWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 09:22:52 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH v2 1/3] staging: lustre: lov: Cleanup lov_check_set() in lov_request.c
Date: Sun, 20 Jul 2014 15:22:28 +0200
Message-Id: <1405862550-16694-2-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
References: <20140720113747.GG18338@mwanda>
 <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code clearer by introducing a local variable and removing the
unnecessary 'if' statement.

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
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
index ce830e4..ae670bb 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -140,14 +140,14 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
 
 static int lov_check_set(struct lov_obd *lov, int idx)
 {
-	int rc = 0;
+	int rc;
+	struct lov_tgt_desc *desc;
 	mutex_lock(&lov->lov_lock);
 
-	if (lov->lov_tgts[idx] == NULL ||
-	    lov->lov_tgts[idx]->ltd_active ||
-	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
-	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
-		rc = 1;
+	desc = lov->lov_tgts[idx];
+	rc = !desc || desc->ltd_active ||
+		(desc->ltd_exp &&
+		 class_exp2cliimp(desc->ltd_exp)->imp_connect_tried);
 
 	mutex_unlock(&lov->lov_lock);
 	return rc;
-- 
1.9.1

