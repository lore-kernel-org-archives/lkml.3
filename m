Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaF2Im4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:42:56 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:46421 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbaF2Imx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:42:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkIAOfQr1NbsmJR/2dsb2JhbABZgw2sLwsFAW4BkgaHQIEHF3WECwJTI4EJETeIRgHGBBeFZIkjHYQtBY96h3qCaos/iD6CAIFEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Amit Shah <amit.shah@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/1] virtio: console: remove unnecessary null test before debugfs_remove_recursive
Date: Sun, 29 Jun 2014 10:41:33 +0200
Message-Id: <1404031293-5678-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required

Cc: Amit Shah <amit.shah@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/char/virtio_console.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 60aafb8..b585b47 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2262,8 +2262,7 @@ static int __init init(void)
 unregister:
 	unregister_virtio_driver(&virtio_console);
 free:
-	if (pdrvdata.debugfs_dir)
-		debugfs_remove_recursive(pdrvdata.debugfs_dir);
+	debugfs_remove_recursive(pdrvdata.debugfs_dir);
 	class_destroy(pdrvdata.class);
 	return err;
 }
@@ -2276,8 +2275,7 @@ static void __exit fini(void)
 	unregister_virtio_driver(&virtio_rproc_serial);
 
 	class_destroy(pdrvdata.class);
-	if (pdrvdata.debugfs_dir)
-		debugfs_remove_recursive(pdrvdata.debugfs_dir);
+	debugfs_remove_recursive(pdrvdata.debugfs_dir);
 }
 module_init(init);
 module_exit(fini);
-- 
1.8.4.5

