Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3I2TxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:53:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3I2T2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 04/49] bgmac: fix internal switch initialization
Date: Sun, 29 Sep 2013 12:26:38 -0700
Message-Id: <20130929191603.310906889@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit 6a391e7bf26c04a6df5f77290e1146941d210d49 upstream.

Some devices (BCM4749, BCM5357, BCM53572) have internal switch that
requires initialization. We already have code for this, but because
of the typo in code it was never working. This resulted in network not
working for some routers and possibility of soft-bricking them.

Use correct bit for switch initialization and fix typo in the define.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bgmac.c |    2 +-
 drivers/net/ethernet/broadcom/bgmac.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -908,7 +908,7 @@ static void bgmac_chip_reset(struct bgma
 		struct bcma_drv_cc *cc = &bgmac->core->bus->drv_cc;
 		u8 et_swtype = 0;
 		u8 sw_type = BGMAC_CHIPCTL_1_SW_TYPE_EPHY |
-			     BGMAC_CHIPCTL_1_IF_TYPE_RMII;
+			     BGMAC_CHIPCTL_1_IF_TYPE_MII;
 		char buf[2];
 
 		if (bcm47xx_nvram_getenv("et_swtype", buf, 1) > 0) {
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -333,7 +333,7 @@
 
 #define BGMAC_CHIPCTL_1_IF_TYPE_MASK		0x00000030
 #define BGMAC_CHIPCTL_1_IF_TYPE_RMII		0x00000000
-#define BGMAC_CHIPCTL_1_IF_TYPE_MI		0x00000010
+#define BGMAC_CHIPCTL_1_IF_TYPE_MII		0x00000010
 #define BGMAC_CHIPCTL_1_IF_TYPE_RGMII		0x00000020
 #define BGMAC_CHIPCTL_1_SW_TYPE_MASK		0x000000C0
 #define BGMAC_CHIPCTL_1_SW_TYPE_EPHY		0x00000000


