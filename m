Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaDAQPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:15:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaDAQP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 79/86] net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
Date: Tue,  1 Apr 2014 09:08:32 -0700
Message-Id: <1396368519-12728-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit a79121d3b57e7ad61f0b5d23eae05214054f3ccd upstream.

Bit 3 of the MVNETA_GMAC_CTRL_2 is actually used to enable the PCS,
not the PSC: there was a typo in the name of the define, which this
commit fixes.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 81d57e9..d01ce5f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -120,7 +120,7 @@
 #define      MVNETA_GMAC_MAX_RX_SIZE_MASK        0x7ffc
 #define      MVNETA_GMAC0_PORT_ENABLE            BIT(0)
 #define MVNETA_GMAC_CTRL_2                       0x2c08
-#define      MVNETA_GMAC2_PSC_ENABLE             BIT(3)
+#define      MVNETA_GMAC2_PCS_ENABLE             BIT(3)
 #define      MVNETA_GMAC2_PORT_RGMII             BIT(4)
 #define      MVNETA_GMAC2_PORT_RESET             BIT(6)
 #define MVNETA_GMAC_STATUS                       0x2c10
@@ -656,7 +656,7 @@ static void mvneta_port_sgmii_config(struct mvneta_port *pp)
 	u32 val;
 
 	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
-	val |= MVNETA_GMAC2_PSC_ENABLE;
+	val |= MVNETA_GMAC2_PCS_ENABLE;
 	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
 }
 
-- 
1.8.3.2

