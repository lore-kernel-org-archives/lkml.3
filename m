Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaIUIBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 04:01:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:53795 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaIUIBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 04:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,564,1406617200"; 
   d="scan'208";a="478959604"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/4] mei: drop me_client_presentation_num
Date: Sun, 21 Sep 2014 11:00:14 +0300
Message-Id: <1411286416-15339-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411286416-15339-1-git-send-email-tomas.winkler@intel.com>
References: <1411286416-15339-1-git-send-email-tomas.winkler@intel.com>
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

