Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3IPUqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:18077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab3IPUqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571813"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 7/7] mei: amthif: mei_amthif_host_init: propagate errors from called functions
Date: Mon, 16 Sep 2013 23:44:48 +0300
Message-Id: <1379364288-16374-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

propagate error codes from called functions, they are correct.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 4f259d4..d22c686 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -79,8 +79,10 @@ int mei_amthif_host_init(struct mei_device *dev)
 
 	i = mei_me_cl_by_uuid(dev, &mei_amthif_guid);
 	if (i < 0) {
-		dev_info(&dev->pdev->dev, "amthif: failed to find the client\n");
-		return -ENOENT;
+		ret = i;
+		dev_info(&dev->pdev->dev,
+			"amthif: failed to find the client %d\n", ret);
+		return ret;
 	}
 
 	cl->me_client_id = dev->me_clients[i].client_id;
@@ -107,8 +109,9 @@ int mei_amthif_host_init(struct mei_device *dev)
 	ret = mei_cl_link(cl, MEI_IAMTHIF_HOST_CLIENT_ID);
 
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "amthif: failed link client\n");
-		return -ENOENT;
+		dev_err(&dev->pdev->dev,
+			"amthif: failed link client %d\n", ret);
+		return ret;
 	}
 
 	cl->state = MEI_FILE_CONNECTING;
-- 
1.8.3.1

