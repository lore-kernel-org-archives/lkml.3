Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478AbaJ1Hko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:40:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:1766 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaJ1Hkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:40:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,801,1406617200"; 
   d="scan'208";a="626743102"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: debugfs: display also connectionless clients
Date: Tue, 28 Oct 2014 09:39:39 +0200
Message-Id: <1414481979-2316-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<debugfs>meiX/meclients: display also fixed/connectionless clients

Use better name for fixed client field:
fixed_address is boolean and indicates whether a client
is fixed or dynamic.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/debugfs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index ce1566715f80..b60b4263cf0f 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -34,7 +34,7 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 	int pos = 0;
 	int ret;
 
-#define HDR "  |id|addr|         UUID                       |con|msg len|sb|\n"
+#define HDR "  |id|fix|         UUID                       |con|msg len|sb|\n"
 
 	mutex_lock(&dev->device_lock);
 
@@ -56,12 +56,8 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 
 	list_for_each_entry(me_cl, &dev->me_clients, list) {
 
-		/* skip me clients that cannot be connected */
-		if (me_cl->props.max_number_of_connections == 0)
-			continue;
-
 		pos += scnprintf(buf + pos, bufsz - pos,
-			"%2d|%2d|%4d|%pUl|%3d|%7d|%2d|\n",
+			"%2d|%2d|%3d|%pUl|%3d|%7d|%2d|\n",
 			i++, me_cl->client_id,
 			me_cl->props.fixed_address,
 			&me_cl->props.protocol_name,
-- 
1.9.3

