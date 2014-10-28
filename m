Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaJ1NXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:23:24 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:64824 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaJ1NXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:23:13 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv3 4/9] net: fec: declare bufdesc_ex flag as bool
Date: Tue, 28 Oct 2014 14:22:59 +0100
Message-Id: <1414502584-10583-5-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
References: <1414494104-27943-1-git-send-email-LW@KARO-electronics.de>
 <1414502584-10583-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fep->bufdesc_ex is used as boolean flag; thus declare it as such.
Also remove an unnecessary initialization to 0.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/ethernet/freescale/fec.h      |    2 +-
 drivers/net/ethernet/freescale/fec_main.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 27e75cf..1418813 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -502,7 +502,7 @@ struct fec_enet_private {
 	int	speed;
 	struct	completion mdio_done;
 	int	irq[FEC_IRQ_NUM];
-	int	bufdesc_ex;
+	bool	bufdesc_ex;
 	int	pause_flag;
 
 	struct	napi_struct napi;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 50a851d..bb006e1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3169,8 +3169,6 @@ fec_probe(struct platform_device *pdev)
 	fep->pdev = pdev;
 	fep->dev_id = dev_id++;
 
-	fep->bufdesc_ex = 0;
-
 	platform_set_drvdata(pdev, ndev);
 
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
@@ -3228,7 +3226,7 @@ fec_probe(struct platform_device *pdev)
 		pdev->id_entry->driver_data & FEC_QUIRK_HAS_BUFDESC_EX;
 	if (IS_ERR(fep->clk_ptp)) {
 		fep->clk_ptp = NULL;
-		fep->bufdesc_ex = 0;
+		fep->bufdesc_ex = false;
 	}
 
 	ret = fec_enet_clk_enable(ndev, true);
-- 
1.7.10.4

