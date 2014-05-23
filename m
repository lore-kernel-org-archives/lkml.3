Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaEWT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:58:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32839 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaEWT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:57:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH v2 4/4] net: ks8851: Add of match table
Date: Fri, 23 May 2014 12:57:20 -0700
Message-Id: <1400875040-13269-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400875040-13269-1-git-send-email-sboyd@codeaurora.org>
References: <1400875040-13269-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users are currently just providing "ks8851" as the compatible for
this driver in device tree. Add a compatible string that provides
the vendor name along with the device name to be more explicit.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 3a322daba5ff..e72918970a58 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1603,9 +1603,15 @@ static int ks8851_remove(struct spi_device *spi)
 	return 0;
 }
 
+static const struct of_device_id ks8851_match_table[] = {
+	{ .compatible = "micrel,ks8851" },
+	{ }
+};
+
 static struct spi_driver ks8851_driver = {
 	.driver = {
 		.name = "ks8851",
+		.of_match_table = ks8851_match_table,
 		.owner = THIS_MODULE,
 		.pm = &ks8851_pm_ops,
 	},
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

