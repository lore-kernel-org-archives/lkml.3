Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3LSL4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab3LSL4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 060/208] can: flexcan: use correct clock as base for bit rate calculation
Date: Thu, 19 Dec 2013 11:52:38 +0000
Message-Id: <1387454106-19326-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 1a3e5173f5e72cbf7f0c8927b33082e361c16d72 upstream.

The flexcan IP core uses the peripheral clock ("per") as basic clock for the
bit timing calculation. However the driver uses the the wrong clock ("ipg").
This leads to wrong bit rates if the rates on both clock are different.

This patch fixes the problem by using the correct clock for the bit rate
calculation.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index cf3c93f..eb6b191 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1010,7 +1010,6 @@ static int flexcan_probe(struct platform_device *pdev)
 			err = PTR_ERR(clk_ipg);
 			goto failed_clock;
 		}
-		clock_freq = clk_get_rate(clk_ipg);
 
 		clk_per = devm_clk_get(&pdev->dev, "per");
 		if (IS_ERR(clk_per)) {
@@ -1018,6 +1017,7 @@ static int flexcan_probe(struct platform_device *pdev)
 			err = PTR_ERR(clk_per);
 			goto failed_clock;
 		}
+		clock_freq = clk_get_rate(clk_per);
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.8.3.2

