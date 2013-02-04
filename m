Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3BDD3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:29:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38233 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753981Ab3BDD2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:28:50 -0500
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] caif: Remove unnecessary alloc/OOM messages
Date: Sun,  3 Feb 2013 19:28:08 -0800
Message-Id: <05378a956f540b9fd80929d1761ee78f8d052228.1359939013.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1359939012.git.joe@perches.com>
References: <cover.1359939012.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc failures already get standardized OOM
messages and a dump_stack.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/caif/caif_shmcore.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/caif/caif_shmcore.c b/drivers/net/caif/caif_shmcore.c
index bc497d7..bce8bac 100644
--- a/drivers/net/caif/caif_shmcore.c
+++ b/drivers/net/caif/caif_shmcore.c
@@ -633,9 +633,6 @@ int caif_shmcore_probe(struct shmdev_layer *pshm_dev)
 				kmalloc(sizeof(struct buf_list), GFP_KERNEL);
 
 		if (tx_buf == NULL) {
-			pr_warn("ERROR, Could not"
-					" allocate dynamic mem. for tx_buf,"
-					" Bailing out ...\n");
 			free_netdev(pshm_dev->pshm_netdev);
 			return -ENOMEM;
 		}
@@ -662,9 +659,6 @@ int caif_shmcore_probe(struct shmdev_layer *pshm_dev)
 				kmalloc(sizeof(struct buf_list), GFP_KERNEL);
 
 		if (rx_buf == NULL) {
-			pr_warn("ERROR, Could not"
-					" allocate dynamic mem.for rx_buf,"
-					" Bailing out ...\n");
 			free_netdev(pshm_dev->pshm_netdev);
 			return -ENOMEM;
 		}
-- 
1.8.0.dirty

