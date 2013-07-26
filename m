Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab3GZVGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:06:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760118Ab3GZU6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/45] sunvnet: vnet_port_remove must call unregister_netdev
Date: Fri, 26 Jul 2013 13:57:43 -0700
Message-Id: <20130726205657.415690898@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit aabb9875d02559ab9b928cd6f259a5cc4c21a589 ]

The missing call to unregister_netdev() leaves the interface active
after the driver is unloaded by rmmod.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sunvnet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/sunvnet.c
+++ b/drivers/net/sunvnet.c
@@ -1248,6 +1248,8 @@ static int vnet_port_remove(struct vio_d
 		dev_set_drvdata(&vdev->dev, NULL);
 
 		kfree(port);
+
+		unregister_netdev(vp->dev);
 	}
 	return 0;
 }


