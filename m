Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3IBAMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:12:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:29144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3IBAL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:11:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="395354832"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/5] mei: mei_cl_link protect open_handle_count from overflow
Date: Mon,  2 Sep 2013 03:11:00 +0300
Message-Id: <1378080664-7274-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
References: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_cl_link is called both from mei_open and also from
in-kernel drivers so we need to protect open_handle_count
from overflow

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e0684b4..a82b443 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -287,6 +287,12 @@ int mei_cl_link(struct mei_cl *cl, int id)
 		return -ENOENT;
 	}
 
+	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
+		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
+			MEI_MAX_OPEN_HANDLE_COUNT);
+		return -ENOENT;
+	}
+
 	dev->open_handle_count++;
 
 	cl->host_client_id = id;
-- 
1.8.3.1

