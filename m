Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaHULa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:30:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:4826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbaHULa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:30:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969450"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 01/14] mei: use consistently me_addr in the hbm structures
Date: Thu, 21 Aug 2014 14:29:10 +0300
Message-Id: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use consistently me_addr name in hbm protocol structures
to represent in firmware client address

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hbm.c | 6 +++---
 drivers/misc/mei/hw.h  | 5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 8041062..68a1cba 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -288,7 +288,7 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 
 
 	prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
-	prop_req->address = next_client_index;
+	prop_req->me_addr = next_client_index;
 
 	ret = mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 	if (ret) {
@@ -783,9 +783,9 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 			return -EPROTO;
 		}
 
-		if (me_client->client_id != props_res->address) {
+		if (me_client->client_id != props_res->me_addr) {
 			dev_err(&dev->pdev->dev, "hbm: properties response: address mismatch %d ?= %d\n",
-				me_client->client_id, props_res->address);
+				me_client->client_id, props_res->me_addr);
 			return -EPROTO;
 		}
 
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index dd448e5..50526f9 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -206,14 +206,13 @@ struct mei_client_properties {
 
 struct hbm_props_request {
 	u8 hbm_cmd;
-	u8 address;
+	u8 me_addr;
 	u8 reserved[2];
 } __packed;
 
-
 struct hbm_props_response {
 	u8 hbm_cmd;
-	u8 address;
+	u8 me_addr;
 	u8 status;
 	u8 reserved[1];
 	struct mei_client_properties client_properties;
-- 
1.9.3

