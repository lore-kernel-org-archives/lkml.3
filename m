Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3IPUqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:18077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab3IPUqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571780"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/7] mei: mei_cl_unlink: no need to loop over dev list
Date: Mon, 16 Sep 2013 23:44:45 +0300
Message-Id: <1379364288-16374-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can call list_del_init regardless the client is
linked or not it is always properly initialized

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 88bcde4..653b318 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -312,7 +312,6 @@ int mei_cl_link(struct mei_cl *cl, int id)
 int mei_cl_unlink(struct mei_cl *cl)
 {
 	struct mei_device *dev;
-	struct mei_cl *pos, *next;
 
 	/* don't shout on error exit path */
 	if (!cl)
@@ -324,14 +323,10 @@ int mei_cl_unlink(struct mei_cl *cl)
 
 	dev = cl->dev;
 
-	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
-		if (cl->host_client_id == pos->host_client_id) {
-			cl_dbg(dev, cl, "remove host client = %d, ME client = %d\n",
-				pos->host_client_id, pos->me_client_id);
-			list_del_init(&pos->link);
-			break;
-		}
-	}
+	cl_dbg(dev, cl, "unlink client");
+
+	list_del_init(&cl->link);
+
 	return 0;
 }
 
-- 
1.8.3.1

