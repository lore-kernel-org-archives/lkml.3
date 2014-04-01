Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaDAEOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaDAEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:14:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 13/22] net: mvneta: rename MVNETA_GMAC2_PSC_ENABLE to MVNETA_GMAC2_PCS_ENABLE
Date: Mon, 31 Mar 2014 21:08:43 -0700
Message-Id: <20140401040706.479440303@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit a79121d3b57e7ad61f0b5d23eae05214054f3ccd upstream.

Bit 3 of the MVNETA_GMAC_CTRL_2 is actually used to enable the PCS,
not the PSC: there was a typo in the name of the define, which this
commit fixes.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvneta.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -161,7 +161,7 @@
 #define      MVNETA_GMAC_MAX_RX_SIZE_MASK        0x7ffc
 #define      MVNETA_GMAC0_PORT_ENABLE            BIT(0)
 #define MVNETA_GMAC_CTRL_2                       0x2c08
-#define      MVNETA_GMAC2_PSC_ENABLE             BIT(3)
+#define      MVNETA_GMAC2_PCS_ENABLE             BIT(3)
 #define      MVNETA_GMAC2_PORT_RGMII             BIT(4)
 #define      MVNETA_GMAC2_PORT_RESET             BIT(6)
 #define MVNETA_GMAC_STATUS                       0x2c10
@@ -729,7 +729,7 @@ static void mvneta_port_sgmii_config(str
 	u32 val;
 
 	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
-	val |= MVNETA_GMAC2_PSC_ENABLE;
+	val |= MVNETA_GMAC2_PCS_ENABLE;
 	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
 
 	mvreg_write(pp, MVNETA_SGMII_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);


