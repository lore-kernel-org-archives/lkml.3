Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3JUTRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:17:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:39506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab3JUTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681902"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/8] mei: hbm: validate client index is not exceeding allocated array size
Date: Mon, 21 Oct 2013 22:05:37 +0300
Message-Id: <1382382343-12066-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 9b3a0fb..0f5e8ca 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -228,8 +228,6 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 	unsigned long client_num;
 
 
-	client_num = dev->me_client_presentation_num;
-
 	next_client_index = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX,
 					  dev->me_client_index);
 
@@ -241,6 +239,10 @@ static int mei_hbm_prop_req(struct mei_device *dev)
 		return 0;
 	}
 
+	client_num = dev->me_client_presentation_num;
+	if (WARN_ON(dev->me_clients_num <= client_num))
+		return -EIO;
+
 	dev->me_clients[client_num].client_id = next_client_index;
 	dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
 
-- 
1.8.3.1

