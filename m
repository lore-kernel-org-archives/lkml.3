Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab3GWSCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:02:33 -0400
Received: from sauhun.de ([89.238.76.85]:58692 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab3GWSCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:02:30 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 03/27] drivers/cpuidle: don't check resource with devm_ioremap_resource
Date: Tue, 23 Jul 2013 20:01:36 +0200
Message-Id: <1374602524-3398-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/cpuidle/cpuidle-kirkwood.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
index 521b0a7..2237135 100644
--- a/drivers/cpuidle/cpuidle-kirkwood.c
+++ b/drivers/cpuidle/cpuidle-kirkwood.c
@@ -60,9 +60,6 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
 	struct resource *res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL)
-		return -EINVAL;
-
 	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ddr_operation_base))
 		return PTR_ERR(ddr_operation_base);
-- 
1.7.10.4

