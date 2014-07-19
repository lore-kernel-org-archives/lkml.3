Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaGSTg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:36:57 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:42385 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbaGSTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:36:55 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, josh@joshtriplett.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH 2/3] staging: lustre/lustre/lov: Add a blank line after declarations in lov_request.c
Date: Sat, 19 Jul 2014 21:34:57 +0200
Message-Id: <1405798498-15754-3-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following checkpatch.pl issue in lov_request.c:
WARNING: Missing a blank line after declarations

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
---
 drivers/staging/lustre/lustre/lov/lov_request.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index 90fc66a..d9344c7 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -141,14 +141,14 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
 static int lov_check_set(struct lov_obd *lov, int idx)
 {
 	int rc;
-	mutex_lock(&lov->lov_lock);
 
+	mutex_lock(&lov->lov_lock);
 	rc = lov->lov_tgts[idx] == NULL ||
 		lov->lov_tgts[idx]->ltd_active ||
 		(lov->lov_tgts[idx]->ltd_exp != NULL &&
 		 class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried);
-
 	mutex_unlock(&lov->lov_lock);
+
 	return rc;
 }
 
@@ -835,6 +835,7 @@ static int cb_getattr_update(void *cookie, int rc)
 {
 	struct obd_info *oinfo = cookie;
 	struct lov_request *lovreq;
+
 	lovreq = container_of(oinfo, struct lov_request, rq_oi);
 	return lov_update_common_set(lovreq->rq_rqset, lovreq, rc);
 }
@@ -1017,6 +1018,7 @@ static int cb_setattr_update(void *cookie, int rc)
 {
 	struct obd_info *oinfo = cookie;
 	struct lov_request *lovreq;
+
 	lovreq = container_of(oinfo, struct lov_request, rq_oi);
 	return lov_update_setattr_set(lovreq->rq_rqset, lovreq, rc);
 }
@@ -1140,6 +1142,7 @@ static int cb_update_punch(void *cookie, int rc)
 {
 	struct obd_info *oinfo = cookie;
 	struct lov_request *lovreq;
+
 	lovreq = container_of(oinfo, struct lov_request, rq_oi);
 	return lov_update_punch_set(lovreq->rq_rqset, lovreq, rc);
 }
-- 
1.9.1

