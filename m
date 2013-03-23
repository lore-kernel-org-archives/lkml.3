Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3CWOeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:34:16 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35173 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3CWOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:34:14 -0400
Message-ID: <1364048887.13141.0.camel@phoenix>
Subject: [PATCH] clocksource: exynos_mct: Add terminating entry for
 exynos_mct_ids table
From: Axel Lin <axel.lin@ingics.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Changhwan Youn <chaos.youn@samsung.com>, linux-kernel@vger.kernel.org
Date: Sat, 23 Mar 2013 22:28:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clocksource/exynos_mct.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 203ac05..3cdafc0 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -514,6 +514,7 @@ static void __init exynos4_timer_resources(struct device_node *np)
 static const struct of_device_id exynos_mct_ids[] = {
 	{ .compatible = "samsung,exynos4210-mct", .data = (void *)MCT_INT_SPI },
 	{ .compatible = "samsung,exynos4412-mct", .data = (void *)MCT_INT_PPI },
+	{ }
 };
 
 void __init mct_init(void)
-- 
1.7.9.5



