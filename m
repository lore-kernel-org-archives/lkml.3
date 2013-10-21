Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JUTP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:39506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3JUTPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681963"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/8] mei: mei_cl_link remove duplicated check for open_handle_count
Date: Mon, 21 Oct 2013 22:05:41 +0300
Message-Id: <1382382343-12066-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 0ccc22c..87c96e4 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -299,12 +299,6 @@ int mei_cl_link(struct mei_cl *cl, int id)
 		return -EMFILE;
 	}
 
-	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
-		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
-			MEI_MAX_OPEN_HANDLE_COUNT);
-		return -ENOENT;
-	}
-
 	dev->open_handle_count++;
 
 	cl->host_client_id = id;
-- 
1.8.3.1

