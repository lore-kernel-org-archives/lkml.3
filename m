Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbaELBpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:45:17 -0400
Received: from 1wt.eu ([62.212.114.60]:34825 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbaELBpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:45:14 -0400
Message-Id: <20140512003202.836489832@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 053/143] sunvnet: vnet_port_remove must call unregister_netdev
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit aabb9875d02559ab9b928cd6f259a5cc4c21a589 ]

The missing call to unregister_netdev() leaves the interface active
after the driver is unloaded by rmmod.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/sunvnet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/sunvnet.c b/drivers/net/sunvnet.c
index bc74db0..b6d0348 100644
--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1260,6 +1260,8 @@ static int vnet_port_remove(struct vio_dev *vdev)
 		dev_set_drvdata(&vdev->dev, NULL);
 
 		kfree(port);
+
+		unregister_netdev(vp->dev);
 	}
 	return 0;
 }
-- 
1.7.12.2.21.g234cd45.dirty



