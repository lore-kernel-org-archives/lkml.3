Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3JUTPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:21055 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3JUTPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681951"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/8] mei: bus: propagate error code returned by mei_me_cl_by_id
Date: Mon, 21 Oct 2013 22:05:40 +0300
Message-Id: <1382382343-12066-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no need to change error code value returned by
mei_me_cl_by_id, just propagate it on

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index cd2033c..4bc7d62 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -245,7 +245,7 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 	/* Check if we have an ME client device */
 	id = mei_me_cl_by_id(dev, cl->me_client_id);
 	if (id < 0)
-		return -ENODEV;
+		return id;
 
 	if (length > dev->me_clients[id].props.max_msg_length)
 		return -EINVAL;
-- 
1.8.3.1

