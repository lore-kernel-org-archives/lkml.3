Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3BLEL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:11:57 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63541 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab3BLELw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:11:52 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Cyril Roelandt <tipecaml@gmail.com>, omar.ramirez@copitl.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Subject: [PATCH 4/5] staging: tidspbridge: remove redundant NULL check before delete_msg_mgr().
Date: Tue, 12 Feb 2013 05:01:52 +0100
Message-Id: <1360641713-24895-5-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
References: <1360641713-24895-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


delete_msg_mgr on a NULL pointer is a no-op, so the NULL check in
bridge_msg_delete can be removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/tidspbridge/core/msg_sm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/msg_sm.c b/drivers/staging/tidspbridge/core/msg_sm.c
index ce9557e..7b517eb 100644
--- a/drivers/staging/tidspbridge/core/msg_sm.c
+++ b/drivers/staging/tidspbridge/core/msg_sm.c
@@ -198,8 +198,7 @@ out_err:
  */
 void bridge_msg_delete(struct msg_mgr *hmsg_mgr)
 {
-	if (hmsg_mgr)
-		delete_msg_mgr(hmsg_mgr);
+	delete_msg_mgr(hmsg_mgr);
 }
 
 /*
-- 
1.7.10.4

