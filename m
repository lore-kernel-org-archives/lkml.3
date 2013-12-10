Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3LJIDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:03:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3LJICy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.12 28/62] can: flexcan: use correct clock as base for bit rate calculation
Date: Tue, 10 Dec 2013 00:00:59 -0800
Message-Id: <20131210080059.417469585@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 1a3e5173f5e72cbf7f0c8927b33082e361c16d72 upstream.

The flexcan IP core uses the peripheral clock ("per") as basic clock for the
bit timing calculation. However the driver uses the the wrong clock ("ipg").
This leads to wrong bit rates if the rates on both clock are different.

This patch fixes the problem by using the correct clock for the bit rate
calculation.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1020,13 +1020,13 @@ static int flexcan_probe(struct platform
 			dev_err(&pdev->dev, "no ipg clock defined\n");
 			return PTR_ERR(clk_ipg);
 		}
-		clock_freq = clk_get_rate(clk_ipg);
 
 		clk_per = devm_clk_get(&pdev->dev, "per");
 		if (IS_ERR(clk_per)) {
 			dev_err(&pdev->dev, "no per clock defined\n");
 			return PTR_ERR(clk_per);
 		}
+		clock_freq = clk_get_rate(clk_per);
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);


