Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaCEJ5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:57:48 -0500
Received: from mailp.voltaire.com ([193.47.165.129]:50260 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753553AbaCEJ5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:57:45 -0500
From: Amir Vadai <amirv@mellanox.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, Yevgeny Petrilin <yevgenyp@mellanox.com>,
        Amir Vadai <amirv@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Eugenia Emantayev <eugenia@mellanox.com>
Subject: [PATCH net-next] net/mlx4_en: mlx4_en_verify_params() can be static
Date: Wed,  5 Mar 2014 11:57:23 +0200
Message-Id: <1394013443-17153-1-git-send-email-amirv@mellanox.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

Fix static error introduced by commit:
b97b33a3df0439401f80f041eda507d4fffa0dbf [645/653] net/mlx4_en: Verify
mlx4_en module parameters

sparse warnings:
drivers/net/ethernet/mellanox/mlx4/en_main.c:335:6: sparse: symbol
'mlx4_en_verify_params' was not declared. Should it be static?

CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: Eugenia Emantayev <eugenia@mellanox.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 3454437..0c59d4f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -332,7 +332,7 @@ static struct mlx4_interface mlx4_en_interface = {
 	.protocol	= MLX4_PROT_ETH,
 };
 
-void mlx4_en_verify_params(void)
+static void mlx4_en_verify_params(void)
 {
 	if (pfctx > MAX_PFC_TX) {
 		pr_warn("mlx4_en: WARNING: illegal module parameter pfctx 0x%x - should be in range 0-0x%x, will be changed to default (0)\n",
-- 
1.8.3.4

