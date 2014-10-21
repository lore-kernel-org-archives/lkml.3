Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaJUJIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:08:11 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46962 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaJUJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:08:08 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] phy: berlin-sata: Add support for BG2 SATA PHY
Date: Tue, 21 Oct 2014 11:07:54 +0200
Message-Id: <1413882477-27922-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413882477-27922-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Berlin BG2 also has a SATA PHY compatible with the current driver
except different PHY_BASE. Add a new compatible to the driver
reflecting the different PHY_BASE.

Acked-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Kishon Vijay Abraham I <kishon@ti.com> 
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org 
---
 drivers/phy/phy-berlin-sata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
index 9682b0f66177..71568f5444ac 100644
--- a/drivers/phy/phy-berlin-sata.c
+++ b/drivers/phy/phy-berlin-sata.c
@@ -30,6 +30,7 @@
 #define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
 #define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
 
+#define BG2_PHY_BASE		0x080
 #define BG2Q_PHY_BASE		0x200
 
 /* register 0x01 */
@@ -186,10 +187,15 @@ static u32 phy_berlin_power_down_bits[] = {
 	POWER_DOWN_PHY1,
 };
 
+static u32 bg2_sata_phy_base = BG2_PHY_BASE;
 static u32 bg2q_sata_phy_base = BG2Q_PHY_BASE;
 
 static const struct of_device_id phy_berlin_sata_of_match[] = {
 	{
+		.compatible = "marvell,berlin2-sata-phy",
+		.data = &bg2_sata_phy_base,
+	},
+	{
 		.compatible = "marvell,berlin2q-sata-phy",
 		.data = &bg2q_sata_phy_base,
 	},
-- 
2.1.1

