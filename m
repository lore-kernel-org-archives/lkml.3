Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaHULbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:31:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:16496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaHULbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969512"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 08/14] mei: use disconnect name consistently
Date: Thu, 21 Aug 2014 14:29:17 +0300
Message-Id: <1408620563-25834-8-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename mei_cl_irq_close to mei_cl_irq_disconnect
and MEI_FOP_CLOSE to MEI_FOP_DISCONNECT
Remove unused MEI_FOP_OPEN

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c    | 3 ++-
 drivers/misc/mei/interrupt.c | 8 ++++----
 drivers/misc/mei/mei_dev.h   | 6 ++----
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 1fb23e8..3d4f311 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -516,7 +516,8 @@ int mei_cl_disconnect(struct mei_cl *cl)
 		goto free;
 	}
 
-	cb->fop_type = MEI_FOP_CLOSE;
+	cb->fop_type = MEI_FOP_DISCONNECT;
+
 	if (mei_hbuf_acquire(dev)) {
 		if (mei_hbm_cl_disconnect_req(dev, cl)) {
 			rets = -ENODEV;
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 19709b7..1b6c14b 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -195,7 +195,7 @@ static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
 
 
 /**
- * mei_cl_irq_close - processes close related operation from
+ * mei_cl_irq_disconnect - processes close related operation from
  *	interrupt thread context - send disconnect request
  *
  * @cl: client
@@ -204,7 +204,7 @@ static int mei_cl_irq_disconnect_rsp(struct mei_cl *cl, struct mei_cl_cb *cb,
  *
  * returns 0, OK; otherwise, error.
  */
-static int mei_cl_irq_close(struct mei_cl *cl, struct mei_cl_cb *cb,
+static int mei_cl_irq_disconnect(struct mei_cl *cl, struct mei_cl_cb *cb,
 			    struct mei_cl_cb *cmpl_list)
 {
 	struct mei_device *dev = cl->dev;
@@ -495,9 +495,9 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 			return -ENODEV;
 		}
 		switch (cb->fop_type) {
-		case MEI_FOP_CLOSE:
+		case MEI_FOP_DISCONNECT:
 			/* send disconnect message */
-			ret = mei_cl_irq_close(cl, cb, cmpl_list);
+			ret = mei_cl_irq_disconnect(cl, cb, cmpl_list);
 			if (ret)
 				return ret;
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 9f684b9..0922ce8 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -132,17 +132,15 @@ enum mei_wd_states {
  * @MEI_FOP_READ      - read
  * @MEI_FOP_WRITE     - write
  * @MEI_FOP_CONNECT   - connect
+ * @MEI_FOP_DISCONNECT - disconnect
  * @MEI_FOP_DISCONNECT_RSP - disconnect response
- * @MEI_FOP_OPEN      - open
- * @MEI_FOP_CLOSE     - close
  */
 enum mei_cb_file_ops {
 	MEI_FOP_READ = 0,
 	MEI_FOP_WRITE,
 	MEI_FOP_CONNECT,
+	MEI_FOP_DISCONNECT,
 	MEI_FOP_DISCONNECT_RSP,
-	MEI_FOP_OPEN,
-	MEI_FOP_CLOSE
 };
 
 /*
-- 
1.9.3

