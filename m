Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3KRSlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:41:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3KRSkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 01/25] net/mlx4_core: Fix call to __mlx4_unregister_mac
Date: Mon, 18 Nov 2013 10:40:30 -0800
Message-Id: <20131118184032.608283851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit c32b7dfbb1dfb3f0a68f250deff65103c8bb704a ]

In function mlx4_master_deactivate_admin_state() __mlx4_unregister_mac was
called using the MAC index. It should be called with the value of the MAC itself.

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1673,7 +1673,7 @@ static void mlx4_master_deactivate_admin
 			vp_oper->vlan_idx = NO_INDX;
 		}
 		if (NO_INDX != vp_oper->mac_idx) {
-			__mlx4_unregister_mac(&priv->dev, port, vp_oper->mac_idx);
+			__mlx4_unregister_mac(&priv->dev, port, vp_oper->state.mac);
 			vp_oper->mac_idx = NO_INDX;
 		}
 	}


