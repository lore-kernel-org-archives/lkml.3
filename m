Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaEQVwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:52:31 -0400
Received: from mout.gmx.net ([212.227.17.22]:50182 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaEQVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:52:30 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: netdev@vger.kernel.org
Cc: amirv@mellanox.com, linux-kernel@vger.kernel.org,
        Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] net/mlx4_en: Fix uninitialized use of 'port_up' in mlx4_en_set_channels()
Date: Sat, 17 May 2014 23:52:03 +0200
Message-Id: <1400363523-18371-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:v/YpgUBAsEcRTAAM/MTIlqcBLD/u7i1CzQGJ4dr6/CkP93vG2Mx
 2KMJtYsYRSRkS7+bwlAx1KL7b+0XPWFNbcjDmyfu5Y/F9/blhasYImqPhXRbpu899galU6G
 Pyp4Pp4Pij+yLUeFIZrAiLERhKqzdYXakI2O1Ggw3Ij439GRjRXMXKR0NL9hHhG5ykP6nTm
 0LHS27kv3P8kckFU+23iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mlx4_en_set_channels() stops running ports before performing the
requested action. In that case local variable 'port_up' is set so that the
port is restarted at the end of the function, however, in case the port was
not stopped, variable 'port_up' is left uninitialized and the behaviour is
undetermined. Detected by Coverity - CID 751497.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Compile tested. Applies against branch master in tree
git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index a72d99f..7ba3df3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1121,7 +1121,7 @@ static int mlx4_en_set_channels(struct net_device *dev,
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
-	int port_up;
+	int port_up = 0;
 	int err = 0;
 
 	if (channel->other_count || channel->combined_count ||
-- 
1.9.1

