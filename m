Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3IBAMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:12:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:29144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab3IBAME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="395354871"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/5] mei: fix format compilation warrning on 32 bit architecture
Date: Mon,  2 Sep 2013 03:11:03 +0300
Message-Id: <1378080664-7274-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
References: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hbm.c: In function mei_hbm_me_cl_allocate:
hbm.c:52:212: warning: format %zd expects argument of type signed size_t but argument 4 has type long unsigned

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 95d4dab..f706fe8 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -45,7 +45,7 @@ static void mei_hbm_me_cl_allocate(struct mei_device *dev)
 	kfree(dev->me_clients);
 	dev->me_clients = NULL;
 
-	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%zd.\n",
+	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%ld.\n",
 		dev->me_clients_num * sizeof(struct mei_me_client));
 	/* allocate storage for ME clients representation */
 	clients = kcalloc(dev->me_clients_num,
-- 
1.8.3.1

