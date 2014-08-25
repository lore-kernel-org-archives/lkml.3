Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbaHYV4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:56:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:11405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933615AbaHYVyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299635"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 05/10] mei: debugfs: add single buffer indicator
Date: Tue, 26 Aug 2014 00:53:23 +0300
Message-Id: <1409003608-30274-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
References: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
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

