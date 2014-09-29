Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaI2Ncw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:32:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:2354 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaI2Ncu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393029951"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 03/18] mei: debugfs: add single buffer indicator
Date: Mon, 29 Sep 2014 16:31:35 +0300
Message-Id: <1411997510-29094-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
References: <1411997510-29094-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add indication whether the client operates in single
buffer mode

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index ca2a12d..be16c4b 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -35,7 +35,7 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 	int pos = 0;
 	int ret;
 
-#define HDR "  |id|addr|         UUID                       |con|msg len|\n"
+#define HDR "  |id|addr|         UUID                       |con|msg len|sb|\n"
 
 	mutex_lock(&dev->device_lock);
 
@@ -62,12 +62,13 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 			continue;
 
 		pos += scnprintf(buf + pos, bufsz - pos,
-			"%2d|%2d|%4d|%pUl|%3d|%7d|\n",
+			"%2d|%2d|%4d|%pUl|%3d|%7d|%2d|\n",
 			i++, me_cl->client_id,
 			me_cl->props.fixed_address,
 			&me_cl->props.protocol_name,
 			me_cl->props.max_number_of_connections,
-			me_cl->props.max_msg_length);
+			me_cl->props.max_msg_length,
+			me_cl->props.single_recv_buf);
 	}
 out:
 	mutex_unlock(&dev->device_lock);
-- 
1.9.3

