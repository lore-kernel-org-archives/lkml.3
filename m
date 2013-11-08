Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3KHCWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:22:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286Ab3KHCWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 49/91] can: flexcan: fix mx28 detection by rearanging OF match table
Date: Thu,  7 Nov 2013 18:15:04 -0800
Message-Id: <1383876946-2396-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit e358784297992b012e8071764d996191dd2b1a54 upstream.

The current implemetation of of_match_device() relies that the of_device_id
table in the driver is sorted from most specific to least specific compatible.

Without this patch the mx28 is detected as the less specific p1010. This leads
to a p1010 specific workaround is activated on the mx28, which is not needed.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/can/flexcan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 5817a39..4c90a27 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -968,9 +968,9 @@ static void unregister_flexcandev(struct net_device *dev)
 }
 
 static const struct of_device_id flexcan_of_match[] = {
-	{ .compatible = "fsl,p1010-flexcan", .data = &fsl_p1010_devtype_data, },
-	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
+	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
+	{ .compatible = "fsl,p1010-flexcan", .data = &fsl_p1010_devtype_data, },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, flexcan_of_match);
-- 
1.8.1.2

