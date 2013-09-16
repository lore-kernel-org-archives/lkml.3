Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab3IPUqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:18077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3IPUqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571754"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/7] mei: fix function names in debug prints
Date: Mon, 16 Sep 2013 23:44:42 +0300
Message-Id: <1379364288-16374-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Fix calling function names in debug prints.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d27804e..be42c70 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -343,14 +343,14 @@ int mei_irq_read_handler(struct mei_device *dev,
 
 	/* decide where to read the message too */
 	if (!mei_hdr->host_addr) {
-		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_bus_message.\n");
+		dev_dbg(&dev->pdev->dev, "call mei_hbm_dispatch.\n");
 		mei_hbm_dispatch(dev, mei_hdr);
-		dev_dbg(&dev->pdev->dev, "end mei_irq_thread_read_bus_message.\n");
+		dev_dbg(&dev->pdev->dev, "end mei_hbm_dispatch.\n");
 	} else if (mei_hdr->host_addr == dev->iamthif_cl.host_client_id &&
 		   (MEI_FILE_CONNECTED == dev->iamthif_cl.state) &&
 		   (dev->iamthif_state == MEI_IAMTHIF_READING)) {
 
-		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
+		dev_dbg(&dev->pdev->dev, "call mei_amthif_irq_read_msg.\n");
 		dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
 
 		ret = mei_amthif_irq_read_msg(dev, mei_hdr, cmpl_list);
-- 
1.8.3.1

