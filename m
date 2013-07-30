Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3G3JdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3G3JdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 055/106] sunvnet: vnet_port_remove must call unregister_netdev
Date: Tue, 30 Jul 2013 10:31:14 +0100
Message-Id: <1375176725-5825-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit aabb9875d02559ab9b928cd6f259a5cc4c21a589 upstream.

The missing call to unregister_netdev() leaves the interface active
after the driver is unloaded by rmmod.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sun/sunvnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index a108db3..1d68059 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -1243,6 +1243,8 @@ static int vnet_port_remove(struct vio_dev *vdev)
 		dev_set_drvdata(&vdev->dev, NULL);
 
 		kfree(port);
+
+		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
-- 
1.8.3.2

