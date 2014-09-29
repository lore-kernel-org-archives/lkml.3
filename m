Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbaI2NdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:33:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:32053 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbaI2NdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:33:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393030125"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 16/18] mei: drop me_client_presentation_num
Date: Mon, 29 Sep 2014 16:31:48 +0300
Message-Id: <1411997510-29094-17-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

me_client_presentation_num field is not used for any
particular purpose now, so it can be safely dropped.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c     | 2 --
 drivers/misc/mei/mei_dev.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index c874fdd..92d0739 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -126,7 +126,6 @@ static void mei_me_cl_remove_all(struct mei_device *dev)
  */
 void mei_hbm_reset(struct mei_device *dev)
 {
-	dev->me_client_presentation_num = 0;
 	dev->me_client_index = 0;
 
 	mei_me_cl_remove_all(dev);
@@ -883,7 +882,6 @@ int mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		mei_hbm_me_cl_add(dev, props_res);
 
 		dev->me_client_index++;
-		dev->me_client_presentation_num++;
 
 		/* request property for the next client */
 		if (mei_hbm_prop_req(dev))
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index fed4c96..0a1f2b7 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -470,7 +470,6 @@ struct mei_device {
 	struct list_head me_clients;
 	DECLARE_BITMAP(me_clients_map, MEI_CLIENTS_MAX);
 	DECLARE_BITMAP(host_clients_map, MEI_CLIENTS_MAX);
-	unsigned long me_client_presentation_num;
 	unsigned long me_client_index;
 
 	struct mei_cl wd_cl;
-- 
1.9.3

