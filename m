Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbaIOWRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:17:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51016 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaIOWRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/187] mei: start disconnect request timer consistently
Date: Mon, 15 Sep 2014 15:08:14 -0700
Message-Id: <1410818997-9432-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 22b987a325701223f9a37db700c6eb20b9924c6f upstream.

Link must be reset in case the fw doesn't
respond to client disconnect request.
We did charge the timer only in irq path
from mei_cl_irq_close and not in mei_cl_disconnect

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 714a998..54122db 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -460,6 +460,7 @@ int mei_cl_disconnect(struct mei_cl *cl)
 			cl_err(dev, cl, "failed to disconnect.\n");
 			goto free;
 		}
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
 		mdelay(10); /* Wait for hardware disconnection ready */
 		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {
-- 
1.9.1

