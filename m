Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbaICJ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:59:07 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57470 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932577AbaICJ7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:59:02 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 27/56] mei: start disconnect request timer consistently
Date: Wed,  3 Sep 2014 11:26:46 +0200
Message-Id: <5204f5c8eb5213ccbe49d7ad628566999c1329be.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 22b987a325701223f9a37db700c6eb20b9924c6f upstream.

Link must be reset in case the fw doesn't
respond to client disconnect request.
We did charge the timer only in irq path
from mei_cl_irq_close and not in mei_cl_disconnect

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/mei/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 9abe5a4e3ef7..e9ea08dd8841 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -451,6 +451,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 			dev_err(&dev->pdev->dev, "failed to disconnect.\n");
 			goto free;
 		}
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
 		mdelay(10); /* Wait for hardware disconnection ready */
 		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {
-- 
2.1.0

