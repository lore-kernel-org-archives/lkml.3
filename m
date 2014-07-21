Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaGUKQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:16:39 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37261 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaGUKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:16:37 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, joe@perches.com,
        Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH v3 2/3] staging: lustre: lov: Add a blank line after declarations in lov_request.c
Date: Mon, 21 Jul 2014 12:15:56 +0200
Message-Id: <1405937757-16504-3-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
References: <1405870223.5135.6.camel@joe-AO725>
 <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl issue in lov_request.c:
WARNING: Missing a blank line after declarations

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
No changes in v3.

Changes in v2:
 - Changed the subject line to follow the same convention used by
   previous commits to the same file.
 - Added Acked-by - Julia.

 drivers/staging/lustre/lustre/lov/lov_request.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index da424de..887b4b0 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -142,14 +142,14 @@ static int lov_check_set(struct lov_obd *lov, int idx)
 {
 	int rc;
 	struct lov_tgt_desc *tgt;
-	mutex_lock(&lov->lov_lock);
 
+	mutex_lock(&lov->lov_lock);
 	tgt = lov->lov_tgts[idx];
 	rc = !tgt || tgt->ltd_active ||
 		(tgt->ltd_exp &&
 		 class_exp2cliimp(tgt->ltd_exp)->imp_connect_tried);
-
 	mutex_unlock(&lov->lov_lock);
+
 	return rc;
 }
 
@@ -836,6 +836,7 @@ static int cb_getattr_update(void *cookie, int rc)
 {
 	struct obd_info *oinfo = cookie;
 	struct lov_request *lovreq;
+
 	lovreq = container_of(oinfo, struct lov_request, rq_oi);
 	return lov_update_common_set(lovreq->rq_rqset, lovreq, rc);
 }
@@ -1018,6 +1019,7 @@ static int cb_setattr_update(void *cookie, int rc)
 {
 	struct obd_info *oinfo = cookie;
 	struct lov_request *lovreq;
+
 	lovreq = container_of(oinfo, struct lov_request, rq_oi);
 	return lov_update_setattr_set(lovreq->rq_rqset, lovreq, rc);
 }
@@ -1141,6 +1143,7 @@ static int cb_update_punch(void *cookie, int rc)
 {
 	struct obd_info *oinfo = cookie;
 	struct lov_request *lovreq;
+
 	lovreq = container_of(oinfo, struct lov_request, rq_oi);
 	return lov_update_punch_set(lovreq->rq_rqset, lovreq, rc);
 }
-- 
1.9.1

