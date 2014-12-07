Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaLGOlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 09:41:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:12340 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaLGOlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 09:41:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,533,1413270000"; 
   d="scan'208";a="634007140"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: use uuid, me_addr tuple addressing also for flow control credits
Date: Sun,  7 Dec 2014 16:40:14 +0200
Message-Id: <1417963214-2136-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add uuid, me_addr addressing also for flow control credits.
The only exception in cases for single buffer clients for which
the host address in flow credits response is always 0

To in order to deal with add/remove race between fw and driver clients
addressing we need to use [uuid, me_addr] tuple to address the clients

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index fb04bfbef9fe..9541218c10eb 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -800,7 +800,7 @@ int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 	if (cl->mei_flow_ctrl_creds > 0)
 		return 1;
 
-	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	me_cl = mei_me_cl_by_uuid_id(dev, &cl->cl_uuid, cl->me_client_id);
 	if (!me_cl) {
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
 		return -ENOENT;
@@ -836,7 +836,7 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 
 	dev = cl->dev;
 
-	me_cl = mei_me_cl_by_id(dev, cl->me_client_id);
+	me_cl = mei_me_cl_by_uuid_id(dev, &cl->cl_uuid, cl->me_client_id);
 	if (!me_cl) {
 		cl_err(dev, cl, "no such me client %d\n", cl->me_client_id);
 		return -ENOENT;
-- 
1.9.3

