Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaJTISZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:18:25 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:35247 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaJTISU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:18:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Iyappan Subramanian <isubramanian@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] drivers: net: xgene: Add missing initialization in xgene_enet_ecc_init()
Date: Mon, 20 Oct 2014 10:08:16 +0200
Message-Id: <1413792496-8558-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: In function ‘xgene_enet_ecc_init’:
drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:126: warning: ‘data’ may be used uninitialized in this function

Depending on the arbitrary value on the stack, the loop may terminate
too early, and cause a bogus -ENODEV failure.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
index e6d24c2101982444..19e13583b4259cd4 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -123,7 +123,7 @@ static u32 xgene_enet_rd_mac(struct xgene_enet_pdata *p, u32 rd_addr)
 static int xgene_enet_ecc_init(struct xgene_enet_pdata *p)
 {
 	struct net_device *ndev = p->ndev;
-	u32 data;
+	u32 data = 0;
 	int i;
 
 	xgene_enet_wr_diag_csr(p, ENET_CFG_MEM_RAM_SHUTDOWN_ADDR, 0);
-- 
1.9.1

