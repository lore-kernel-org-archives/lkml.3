Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3JUTPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:39506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3JUTPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681937"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/8] mei: wd: host_init propagate error codes from called functions
Date: Mon, 21 Oct 2013 22:05:39 +0300
Message-Id: <1382382343-12066-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate error codes from called functions, they are correct.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/wd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index b892143..9e35421 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -60,7 +60,7 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
 int mei_wd_host_init(struct mei_device *dev)
 {
 	struct mei_cl *cl = &dev->wd_cl;
-	int i;
+	int id;
 	int ret;
 
 	mei_cl_init(cl, dev);
@@ -70,19 +70,19 @@ int mei_wd_host_init(struct mei_device *dev)
 
 
 	/* check for valid client id */
-	i = mei_me_cl_by_uuid(dev, &mei_wd_guid);
-	if (i < 0) {
+	id = mei_me_cl_by_uuid(dev, &mei_wd_guid);
+	if (id < 0) {
 		dev_info(&dev->pdev->dev, "wd: failed to find the client\n");
-		return -ENOENT;
+		return id;
 	}
 
-	cl->me_client_id = dev->me_clients[i].client_id;
+	cl->me_client_id = dev->me_clients[id].client_id;
 
 	ret = mei_cl_link(cl, MEI_WD_HOST_CLIENT_ID);
 
 	if (ret < 0) {
 		dev_info(&dev->pdev->dev, "wd: failed link client\n");
-		return -ENOENT;
+		return ret;
 	}
 
 	cl->state = MEI_FILE_CONNECTING;
-- 
1.8.3.1

