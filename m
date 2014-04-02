Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbaDBUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:16:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42877 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758936AbaDBUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 37/40] net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
Date: Wed,  2 Apr 2014 22:13:23 +0200
Message-Id: <c41e5a0f38a367b2ba343ba87b17e7ff9e9be72f.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a79121d3b57e7ad61f0b5d23eae05214054f3ccd upstream.

Bit 3 of the MVNETA_GMAC_CTRL_2 is actually used to enable the PCS,
not the PSC: there was a typo in the name of the define, which this
commit fixes.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index e35bac7cfdf1..5cdd2b2f18c5 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -121,7 +121,7 @@
 #define      MVNETA_GMAC_MAX_RX_SIZE_MASK        0x7ffc
 #define      MVNETA_GMAC0_PORT_ENABLE            BIT(0)
 #define MVNETA_GMAC_CTRL_2                       0x2c08
-#define      MVNETA_GMAC2_PSC_ENABLE             BIT(3)
+#define      MVNETA_GMAC2_PCS_ENABLE             BIT(3)
 #define      MVNETA_GMAC2_PORT_RGMII             BIT(4)
 #define      MVNETA_GMAC2_PORT_RESET             BIT(6)
 #define MVNETA_GMAC_STATUS                       0x2c10
@@ -688,7 +688,7 @@ static void mvneta_port_sgmii_config(struct mvneta_port *pp)
 	u32 val;
 
 	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
-	val |= MVNETA_GMAC2_PSC_ENABLE;
+	val |= MVNETA_GMAC2_PCS_ENABLE;
 	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
 
 	mvreg_write(pp, MVNETA_SGMII_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
-- 
1.9.1

