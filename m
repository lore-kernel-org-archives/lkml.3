Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaGSTgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:36:47 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56772 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaGSTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:36:46 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: oleg.drokin@intel.com, josh@joshtriplett.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Riccardo Lucchese <riccardo.lucchese@gmail.com>
Subject: [PATCH 1/3] staging: lustre/lustre/lov: Remove unneeded 'if' statement in lov_request.c/lov_check_set()
Date: Sat, 19 Jul 2014 21:34:56 +0200
Message-Id: <1405798498-15754-2-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
References: <1405798498-15754-1-git-send-email-riccardo.lucchese@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is silly to go through an if statement to set a single boolean
value in function of a single boolean expression. In the function
lov_check_set, assign the return value directly.

Signed-off-by: Riccardo Lucchese <riccardo.lucchese@gmail.com>
---
 drivers/staging/lustre/lustre/lov/lov_request.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_request.c b/drivers/staging/lustre/lustre/lov/lov_request.c
index ce830e4..90fc66a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_request.c
+++ b/drivers/staging/lustre/lustre/lov/lov_request.c
@@ -140,14 +140,13 @@ void lov_set_add_req(struct lov_request *req, struct lov_request_set *set)
 
 static int lov_check_set(struct lov_obd *lov, int idx)
 {
-	int rc = 0;
+	int rc;
 	mutex_lock(&lov->lov_lock);
 
-	if (lov->lov_tgts[idx] == NULL ||
-	    lov->lov_tgts[idx]->ltd_active ||
-	    (lov->lov_tgts[idx]->ltd_exp != NULL &&
-	     class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried))
-		rc = 1;
+	rc = lov->lov_tgts[idx] == NULL ||
+		lov->lov_tgts[idx]->ltd_active ||
+		(lov->lov_tgts[idx]->ltd_exp != NULL &&
+		 class_exp2cliimp(lov->lov_tgts[idx]->ltd_exp)->imp_connect_tried);
 
 	mutex_unlock(&lov->lov_lock);
 	return rc;
-- 
1.9.1

