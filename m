Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaIVRk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:40:27 -0400
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:57380 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754033AbaIVRkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:40:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3867:3871:3872:4321:4605:5007:6119:7652:9592:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: farm48_5ac0eae56aa29
X-Filterd-Recvd-Size: 2920
Message-ID: <1411407622.2952.49.camel@joe-AO725>
Subject: [PATCH net-next] mellanox: Change en_print to return void
From: Joe Perches <joe@perches.com>
To: Amir Vadai <amirv@mellanox.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 10:40:22 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No caller or macro uses the return value so make it void.

Signed-off-by: Joe Perches <joe@perches.com>
---
This change is associated to a desire to eventually
change printk to return void.

 drivers/net/ethernet/mellanox/mlx4/en_main.c | 17 +++++++----------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  4 ++--
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 3626fdf..2091ae88 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -78,27 +78,24 @@ MLX4_EN_PARM_INT(inline_thold, MAX_INLINE,
 #define MAX_PFC_TX     0xff
 #define MAX_PFC_RX     0xff
 
-int en_print(const char *level, const struct mlx4_en_priv *priv,
-	     const char *format, ...)
+void en_print(const char *level, const struct mlx4_en_priv *priv,
+	      const char *format, ...)
 {
 	va_list args;
 	struct va_format vaf;
-	int i;
 
 	va_start(args, format);
 
 	vaf.fmt = format;
 	vaf.va = &args;
 	if (priv->registered)
-		i = printk("%s%s: %s: %pV",
-			   level, DRV_NAME, priv->dev->name, &vaf);
+		printk("%s%s: %s: %pV",
+		       level, DRV_NAME, priv->dev->name, &vaf);
 	else
-		i = printk("%s%s: %s: Port %d: %pV",
-			   level, DRV_NAME, dev_name(&priv->mdev->pdev->dev),
-			   priv->port, &vaf);
+		printk("%s%s: %s: Port %d: %pV",
+		       level, DRV_NAME, dev_name(&priv->mdev->pdev->dev),
+		       priv->port, &vaf);
 	va_end(args);
-
-	return i;
 }
 
 void mlx4_en_update_loopback_state(struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 3de41be..03e95f7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -836,8 +836,8 @@ extern const struct ethtool_ops mlx4_en_ethtool_ops;
  */
 
 __printf(3, 4)
-int en_print(const char *level, const struct mlx4_en_priv *priv,
-	     const char *format, ...);
+void en_print(const char *level, const struct mlx4_en_priv *priv,
+	      const char *format, ...);
 
 #define en_dbg(mlevel, priv, format, ...)				\
 do {									\


