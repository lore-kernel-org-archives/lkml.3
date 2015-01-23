Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbbAWQJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:09:30 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65420 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbbAWQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:21 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 18/18] spi/xilinx: Check number of slaves range
Date: Fri, 23 Jan 2015 17:08:50 +0100
Message-Id: <1422029330-10971-19-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core only supports up to 32 slaves, and the chipselect function
expects the same.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 026f4c5..134d8cd 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -22,6 +22,8 @@
 #include <linux/spi/xilinx_spi.h>
 #include <linux/io.h>
 
+#define MAX_CS			32
+
 #define XILINX_SPI_NAME "xilinx_spi"
 
 /* Register definitions as per "OPB Serial Peripheral Interface (SPI) (v1.00e)
@@ -340,6 +342,11 @@ static int xilinx_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	if (num_cs > MAX_CS) {
+		dev_err(&pdev->dev, "Invalid number of spi slaves\n");
+		return -EINVAL;
+	}
+
 	master = spi_alloc_master(&pdev->dev, sizeof(struct xilinx_spi));
 	if (!master)
 		return -ENODEV;
-- 
2.1.4

