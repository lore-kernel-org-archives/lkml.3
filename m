Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaCPMhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 08:37:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:16901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaCPMhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 08:37:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="scan'208";a="493061448"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/5] mei: use cl_dbg where appropriate
Date: Sun, 16 Mar 2014 14:35:55 +0200
Message-Id: <1394973358-21690-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
References: <1394973358-21690-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use cl_dbg for debug log messages in cl context

this also removes checkpatch warning:
quoted string split across lines

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c  |  3 +--
 drivers/misc/mei/main.c | 10 ++--------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 5fa5ff9..4960288 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -329,8 +329,7 @@ int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 	mei_hbm_hdr(mei_hdr, len);
 	mei_hbm_cl_hdr(cl, MEI_FLOW_CONTROL_CMD, dev->wr_msg.data, len);
 
-	dev_dbg(&dev->pdev->dev, "sending flow control host client = %d, ME client = %d\n",
-		cl->host_client_id, cl->me_client_id);
+	cl_dbg(dev, cl, "sending flow control\n");
 
 	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 }
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index bc1c39e..b35594d 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -125,17 +125,11 @@ static int mei_release(struct inode *inode, struct file *file)
 	}
 	if (cl->state == MEI_FILE_CONNECTED) {
 		cl->state = MEI_FILE_DISCONNECTING;
-		dev_dbg(&dev->pdev->dev,
-			"disconnecting client host client = %d, "
-		    "ME client = %d\n",
-		    cl->host_client_id,
-		    cl->me_client_id);
+		cl_dbg(dev, cl, "disconnecting\n");
 		rets = mei_cl_disconnect(cl);
 	}
 	mei_cl_flush_queues(cl);
-	dev_dbg(&dev->pdev->dev, "remove client host client = %d, ME client = %d\n",
-	    cl->host_client_id,
-	    cl->me_client_id);
+	cl_dbg(dev, cl, "removing\n");
 
 	mei_cl_unlink(cl);
 
-- 
1.8.5.3

