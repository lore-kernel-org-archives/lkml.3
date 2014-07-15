Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353AbaGOW1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:27:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbaGOVb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Asai Thambi S P <asamymuthupa@micron.com>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/198] mtip32xx: Remove dfs_parent after pci unregister
Date: Tue, 15 Jul 2014 14:28:03 -0700
Message-Id: <1405459868-15089-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asai Thambi S P <asamymuthupa@micron.com>

commit af5ded8ccf21627f9614afc03b356712666ed225 upstream.

In module exit, dfs_parent and it's subtree were removed before
unregistering with pci. When debugfs entry for each device is attempted
to remove in pci_remove() context, they don't exist, as dfs_parent and
its children were already ripped apart.

Modified to first unregister with pci and then remove dfs_parent.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index c03caae..919b0d9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4869,13 +4869,13 @@ static int __init mtip_init(void)
  */
 static void __exit mtip_exit(void)
 {
-	debugfs_remove_recursive(dfs_parent);
-
 	/* Release the allocated major block device number. */
 	unregister_blkdev(mtip_major, MTIP_DRV_NAME);
 
 	/* Unregister the PCI driver. */
 	pci_unregister_driver(&mtip_pci_driver);
+
+	debugfs_remove_recursive(dfs_parent);
 }
 
 MODULE_AUTHOR("Micron Technology, Inc");
-- 
1.9.1

