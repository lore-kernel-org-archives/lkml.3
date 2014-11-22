Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaKVTs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:48:27 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36876 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaKVTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:47:22 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, al.kochet@gmail.com
Subject: [PATCH v3 1/4] i2c: omap: cleanup register definitions
Date: Sat, 22 Nov 2014 23:47:11 +0400
Message-Id: <1416685634-5864-2-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete STAT_AD0 mask as unrelated to current IP (omap1?).
Delete DEBUG conditional around SYSTEST masks group.
Add SYSTEST functional mode masks for SCL and SDA.
Add STAT_BF mask.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 32dc651..adfac9b 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -98,7 +98,7 @@ enum {
 #define OMAP_I2C_STAT_ROVR	(1 << 11)	/* Receive overrun */
 #define OMAP_I2C_STAT_XUDF	(1 << 10)	/* Transmit underflow */
 #define OMAP_I2C_STAT_AAS	(1 << 9)	/* Address as slave */
-#define OMAP_I2C_STAT_AD0	(1 << 8)	/* Address zero */
+#define OMAP_I2C_STAT_BF	(1 << 8)	/* Bus Free */
 #define OMAP_I2C_STAT_XRDY	(1 << 4)	/* Transmit data ready */
 #define OMAP_I2C_STAT_RRDY	(1 << 3)	/* Receive data ready */
 #define OMAP_I2C_STAT_ARDY	(1 << 2)	/* Register access ready */
@@ -146,16 +146,20 @@ enum {
 #define OMAP_I2C_SCLH_HSSCLH	8
 
 /* I2C System Test Register (OMAP_I2C_SYSTEST): */
-#ifdef DEBUG
 #define OMAP_I2C_SYSTEST_ST_EN		(1 << 15)	/* System test enable */
 #define OMAP_I2C_SYSTEST_FREE		(1 << 14)	/* Free running mode */
 #define OMAP_I2C_SYSTEST_TMODE_MASK	(3 << 12)	/* Test mode select */
 #define OMAP_I2C_SYSTEST_TMODE_SHIFT	(12)		/* Test mode select */
+/* Functional mode */
+#define OMAP_I2C_SYSTEST_SCL_I_FUNC	(1 << 8)	/* SCL line input value */
+#define OMAP_I2C_SYSTEST_SCL_O_FUNC	(1 << 7)	/* SCL line output value */
+#define OMAP_I2C_SYSTEST_SDA_I_FUNC	(1 << 6)	/* SDA line input value */
+#define OMAP_I2C_SYSTEST_SDA_O_FUNC	(1 << 5)	/* SDA line output value */
+/* SDA/SCL IO mode */
 #define OMAP_I2C_SYSTEST_SCL_I		(1 << 3)	/* SCL line sense in */
 #define OMAP_I2C_SYSTEST_SCL_O		(1 << 2)	/* SCL line drive out */
 #define OMAP_I2C_SYSTEST_SDA_I		(1 << 1)	/* SDA line sense in */
 #define OMAP_I2C_SYSTEST_SDA_O		(1 << 0)	/* SDA line drive out */
-#endif
 
 /* OCP_SYSSTATUS bit definitions */
 #define SYSS_RESETDONE_MASK		(1 << 0)
-- 
1.7.9.5

