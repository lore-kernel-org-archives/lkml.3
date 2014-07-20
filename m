Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaGTNXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 09:23:03 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45820 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaGTNW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 09:22:59 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH v2 2/3] staging: lustre: lov: Add a blank line after declarations in lov_request.c
Date: Sun, 20 Jul 2014 15:22:29 +0200
Message-Id: <1405862550-16694-3-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
References: <20140720113747.GG18338@mwanda>
 <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl issue in lov_request.c:
WARNING: Missing a blank line after declarations

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Changes in v2:
 - Changed the subject line to follow the same convention used by
   previous commits to the same file.
 - Added Acked-by - Julia.

 drivers/staging/lustre/lustre/lov/lov_request.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index ae670bb..7491f26 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -142,14 +142,14 @@ static int lov_check_set(struct lov_obd *lov, int idx)
 {
 	int rc;
 	struct lov_tgt_desc *desc;
-	mutex_lock(&lov->lov_lock);
 
+	mutex_lock(&lov->lov_lock);
 	desc = lov->lov_tgts[idx];
 	rc = !desc || desc->ltd_active ||
 		(desc->ltd_exp &&
 		 class_exp2cliimp(desc->ltd_exp)->imp_connect_tried);
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

