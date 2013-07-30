Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3G3Ssj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:48:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab3G3Ssg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:48:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 61/75] sunvnet: vnet_port_remove must call unregister_netdev
Date: Tue, 30 Jul 2013 11:45:05 -0700
Message-Id: <1375209919-1768-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit aabb9875d02559ab9b928cd6f259a5cc4c21a589 ]

The missing call to unregister_netdev() leaves the interface active
after the driver is unloaded by rmmod.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/sun/sunvnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index e1b8955..fb6f3e3 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1242,6 +1242,8 @@ static int vnet_port_remove(struct vio_dev *vdev)
 		dev_set_drvdata(&vdev->dev, NULL);
 
 		kfree(port);
+
+		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
-- 
1.8.1.2

