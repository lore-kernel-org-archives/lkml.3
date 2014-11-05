Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaKEJp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:45:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:1384 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKEJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:45:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,319,1413270000"; 
   d="scan'208";a="631799442"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: fix hbm MEI_HBM_STARTED ambiguity
Date: Wed,  5 Nov 2014 11:44:48 +0200
Message-Id: <1415180688-2670-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have MEI_HBM_STARTED in two contexts one
after start message was received and second
after enumeration was completed.
Because after start message reception we move
immediately to the enumeration state, we need
only the later meaning.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 2 --
 drivers/misc/mei/hbm.h | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index c3cebc4e388b..c8412d41e4f1 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -802,8 +802,6 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		dev->hbm_state = MEI_HBM_STARTED;
-
 		if (mei_hbm_enum_clients_req(dev)) {
 			dev_err(dev->dev, "hbm: start: failed to send enumeration request\n");
 			return -EIO;
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
index b7cd3d857fd5..2544db7d1649 100644
--- a/drivers/misc/mei/hbm.h
+++ b/drivers/misc/mei/hbm.h
@@ -26,17 +26,17 @@ struct mei_cl;
  *
  * @MEI_HBM_IDLE : protocol not started
  * @MEI_HBM_STARTING : start request message was sent
- * @MEI_HBM_STARTED : start reply message was received
  * @MEI_HBM_ENUM_CLIENTS : enumeration request was sent
  * @MEI_HBM_CLIENT_PROPERTIES : acquiring clients properties
+ * @MEI_HBM_STARTED : enumeration was completed
  * @MEI_HBM_STOPPED : stopping exchange
  */
 enum mei_hbm_state {
 	MEI_HBM_IDLE = 0,
 	MEI_HBM_STARTING,
-	MEI_HBM_STARTED,
 	MEI_HBM_ENUM_CLIENTS,
 	MEI_HBM_CLIENT_PROPERTIES,
+	MEI_HBM_STARTED,
 	MEI_HBM_STOPPED,
 };
 
-- 
1.9.3

