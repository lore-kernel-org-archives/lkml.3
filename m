Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaFSQCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:02:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62129 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaFSQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:02:06 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 2/3] staging: lustre: lustre: ldlm: ldlm_lib.c - removed unnecessary braces
Date: Fri, 20 Jun 2014 02:01:47 +1000
Message-Id: <1403193708-22407-2-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403193708-22407-1-git-send-email-askb23@gmail.com>
References: <1403193708-22407-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this change fixes "WARNING: braces {} are not necessary for single
  statement blocks"

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_lib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
index 8bb5915..5d69af5 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lib.c
@@ -74,9 +74,8 @@ static int import_set_conn(struct obd_import *imp, struct obd_uuid *uuid,
 
 	if (create) {
 		OBD_ALLOC(imp_conn, sizeof(*imp_conn));
-		if (!imp_conn) {
+		if (!imp_conn)
 			GOTO(out_put, rc = -ENOMEM);
-		}
 	}
 
 	spin_lock(&imp->imp_lock);
@@ -662,9 +661,8 @@ void target_send_reply(struct ptlrpc_request *req, int rc, int fail_id)
 	struct ptlrpc_reply_state *rs;
 	struct obd_export	 *exp;
 
-	if (req->rq_no_reply) {
+	if (req->rq_no_reply)
 		return;
-	}
 
 	svcpt = req->rq_rqbd->rqbd_svcpt;
 	rs = req->rq_reply_state;
-- 
1.9.0

