Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab3IOPMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:12:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:11876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650Ab3IOPMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:12:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,909,1371106800"; 
   d="scan'208";a="403616406"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: mei_release: drop redundant check if cb is NULL
Date: Sun, 15 Sep 2013 18:11:06 +0300
Message-Id: <1379257867-9107-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_io_cb_free follows kfree design and check for NULL internally

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index b8f8604..c71420e 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -165,10 +165,7 @@ static int mei_release(struct inode *inode, struct file *file)
 
 	file->private_data = NULL;
 
-	if (cb) {
-		mei_io_cb_free(cb);
-		cb = NULL;
-	}
+	mei_io_cb_free(cb);
 
 	kfree(cl);
 out:
-- 
1.8.3.1

