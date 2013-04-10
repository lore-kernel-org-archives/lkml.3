Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936814Ab3DJOjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:39:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57494 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935212Ab3DJOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:39:30 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: wm8994: Add device ID data to WM8994 OF device IDs
Date: Wed, 10 Apr 2013 15:39:22 +0100
Message-Id: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can actually read this back from the device but we use this when
registered using standard I2C board data registration so make sure
it's there for OF too.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Untested at present.

 drivers/mfd/wm8994-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index cdea84e..3f8d591 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -673,9 +673,9 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
 }
 
 static const struct of_device_id wm8994_of_match[] = {
-	{ .compatible = "wlf,wm1811", },
-	{ .compatible = "wlf,wm8994", },
-	{ .compatible = "wlf,wm8958", },
+	{ .compatible = "wlf,wm1811", .data = (void *)WM1811 },
+	{ .compatible = "wlf,wm8994", .data = (void *)WM8994 },
+	{ .compatible = "wlf,wm8958", .data = (void *)WM8958 },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, wm8994_of_match);
-- 
1.7.10.4

