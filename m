Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaBQINw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:13:52 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35753 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaBQINv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:13:51 -0500
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org, ohad@wizery.com
Cc: linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Wei Chen <Wei.Chen@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] drivers/rpmsg/virtio_rpmsg_bus.c: fix the return value of rpmsg_init
Date: Mon, 17 Feb 2014 16:13:34 +0800
Message-Id: <1392624815-20759-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Chen <Wei.Chen@csr.com>

rpmsg_init() always return ERROR code or random integer now, this patch fixes
it.

Signed-off-by: Wei Chen <Wei.Chen@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index b6135d4..7812585 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1096,9 +1096,10 @@ static int __init rpmsg_init(void)
 	if (ret) {
 		pr_err("failed to register virtio driver: %d\n", ret);
 		bus_unregister(&rpmsg_bus);
+		return ret;
 	}
 
-	return ret;
+	return 0;
 }
 subsys_initcall(rpmsg_init);
 
-- 
1.7.5.4

