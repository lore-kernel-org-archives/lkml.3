Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaK3LAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:00:53 -0500
Received: from mout.gmx.net ([212.227.17.20]:54549 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaK3LAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:00:50 -0500
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: nab@linux-iscsi.org
Cc: sagig@mellanox.com, cvubrugier@yahoo.fr, joern@logfs.org,
        steven.allen@purestorage.com, arshad.hussain@calsoftinc.com,
        agrover@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH] iscsi-target: fix error path in iscsi_target_init_module()
Date: Sun, 30 Nov 2014 12:00:11 +0100
Message-Id: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:EGY2XLnJ3GehKjbuWJ3FsM5Uh1VkZ8ZVX27DH6RXbMUM26FbwjM
 nGaafY3f48MGZnpe8KvfEWwkwL+PWHUmUmJdWvXKRps1Z7wCVIcjS/+641JkdFYi5TisNzI
 Oyv+HunOCh75CTnXxFjcsKjSZD7koAm1wjawhVsL6P0IJRMy9duisxPPQqaVcY+eIVJhi3X
 Yvh3HHyKqEKS/b27qxjgA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In iscsi_target_init_module() unwind transport protocol registration in case
that iscsit_load_discovery_tpg() failed.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 drivers/target/iscsi/iscsi_target.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 73e58d2..f8ec322 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -609,6 +609,7 @@ static int __init iscsi_target_init_module(void)
 
 	return ret;
 r2t_out:
+	iscsit_unregister_transport(&iscsi_target_transport);
 	kmem_cache_destroy(lio_r2t_cache);
 ooo_out:
 	kmem_cache_destroy(lio_ooo_cache);
-- 
1.9.1

