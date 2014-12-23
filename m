Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaLWRxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:53:11 -0500
Received: from www.osadl.org ([62.245.132.105]:33722 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaLWRxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:53:10 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] incorrect use of init_completion fixup
Date: Tue, 23 Dec 2014 18:44:53 +0100
Message-Id: <1419356693-22625-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second init_completion call should be a reinit_completion here.

patch is against 3.18.0 linux-next

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/block/aoe/aoecmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 422b7d8..2239513 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1331,7 +1331,7 @@ aoe_ktstart(struct ktstate *k)
 		return -ENOMEM;
 	k->task = task;
 	wait_for_completion(&k->rendez); /* allow kthread to start */
-	init_completion(&k->rendez);	/* for waiting for exit later */
+	reinit_completion(&k->rendez);	/* for waiting for exit later */
 	return 0;
 }

--
1.7.10.4

