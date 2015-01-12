Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbbALSaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbbALSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 185/216] i2c: mv64xxx: use BIT() macro for register value definitions
Date: Mon, 12 Jan 2015 18:29:23 +0000
Message-Id: <1421087394-2712-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 12598695c26ff8fccea92bd36ee3617a6da9b0d0 upstream.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index e21e206d94e7..d9ecab9652b7 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -30,12 +30,12 @@
 #define MV64XXX_I2C_BAUD_DIV_N(val)			(val & 0x7)
 #define MV64XXX_I2C_BAUD_DIV_M(val)			((val & 0xf) << 3)
 
-#define	MV64XXX_I2C_REG_CONTROL_ACK			0x00000004
-#define	MV64XXX_I2C_REG_CONTROL_IFLG			0x00000008
-#define	MV64XXX_I2C_REG_CONTROL_STOP			0x00000010
-#define	MV64XXX_I2C_REG_CONTROL_START			0x00000020
-#define	MV64XXX_I2C_REG_CONTROL_TWSIEN			0x00000040
-#define	MV64XXX_I2C_REG_CONTROL_INTEN			0x00000080
+#define	MV64XXX_I2C_REG_CONTROL_ACK			BIT(2)
+#define	MV64XXX_I2C_REG_CONTROL_IFLG			BIT(3)
+#define	MV64XXX_I2C_REG_CONTROL_STOP			BIT(4)
+#define	MV64XXX_I2C_REG_CONTROL_START			BIT(5)
+#define	MV64XXX_I2C_REG_CONTROL_TWSIEN			BIT(6)
+#define	MV64XXX_I2C_REG_CONTROL_INTEN			BIT(7)
 
 /* Ctlr status values */
 #define	MV64XXX_I2C_STATUS_BUS_ERR			0x00
@@ -68,16 +68,16 @@
 #define	MV64XXX_I2C_REG_BRIDGE_TIMING			0xe0
 
 /* Bridge Control values */
-#define	MV64XXX_I2C_BRIDGE_CONTROL_WR			0x00000001
-#define	MV64XXX_I2C_BRIDGE_CONTROL_RD			0x00000002
+#define	MV64XXX_I2C_BRIDGE_CONTROL_WR			BIT(0)
+#define	MV64XXX_I2C_BRIDGE_CONTROL_RD			BIT(1)
 #define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_SHIFT		2
-#define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_EXT		0x00001000
+#define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_EXT		BIT(12)
 #define	MV64XXX_I2C_BRIDGE_CONTROL_TX_SIZE_SHIFT	13
 #define	MV64XXX_I2C_BRIDGE_CONTROL_RX_SIZE_SHIFT	16
-#define	MV64XXX_I2C_BRIDGE_CONTROL_ENABLE		0x00080000
+#define	MV64XXX_I2C_BRIDGE_CONTROL_ENABLE		BIT(19)
 
 /* Bridge Status values */
-#define	MV64XXX_I2C_BRIDGE_STATUS_ERROR			0x00000001
+#define	MV64XXX_I2C_BRIDGE_STATUS_ERROR			BIT(0)
 #define	MV64XXX_I2C_STATUS_OFFLOAD_ERROR		0xf0000001
 #define	MV64XXX_I2C_STATUS_OFFLOAD_OK			0xf0000000
 
-- 
2.1.4

