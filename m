Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab3B0Alf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:41:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097Ab3BZX6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 133/150] mlx4_en: fix allocation of device tx_cq
Date: Tue, 26 Feb 2013 15:56:30 -0800
Message-Id: <20130226235538.035791414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

[ Upstream commit 427a96252d8eee7b9bbafce15bd37fa3387ede55 ]

The memory to hold the network device tx_cq is not being allocated with
the correct size in mlx4_en_init_netdev(). It should use MAX_TX_RINGS
instead of MAX_RX_RINGS. This can cause problems if the number of tx
rings being used is greater than MAX_RX_RINGS.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Acked-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1597,7 +1597,7 @@ int mlx4_en_init_netdev(struct mlx4_en_d
 		err = -ENOMEM;
 		goto out;
 	}
-	priv->tx_cq = kzalloc(sizeof(struct mlx4_en_cq) * MAX_RX_RINGS,
+	priv->tx_cq = kzalloc(sizeof(struct mlx4_en_cq) * MAX_TX_RINGS,
 			      GFP_KERNEL);
 	if (!priv->tx_cq) {
 		err = -ENOMEM;


