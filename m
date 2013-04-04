Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883Ab3DDUcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:32:18 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51045 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764798Ab3DDUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:32:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] BLOCK: rbd, return proper error from rbd_dev_probe_update_spec
Date: Thu,  4 Apr 2013 22:32:08 +0200
Message-Id: <1365107532-32721-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ret might be uninitialized and is returned that way when kstrdup of
rbd_dev->spec->snap_name fails. Fix it by returning ENOMEM from that
place.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/rbd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6b2b039..3417f34 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3113,8 +3113,10 @@ static int rbd_dev_probe_update_spec(struct rbd_device *rbd_dev)
 		goto out_err;
 	}
 	rbd_dev->spec->snap_name = kstrdup(name, GFP_KERNEL);
-	if(!rbd_dev->spec->snap_name)
+	if(!rbd_dev->spec->snap_name) {
+		ret = -ENOMEM;
 		goto out_err;
+	}
 
 	return 0;
 out_err:
-- 
1.8.2


