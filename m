Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3EJIRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:50 -0400
Received: from sauhun.de ([89.238.76.85]:60618 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab3EJIRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:47 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: [RFC 38/42] arch/arm/plat-omap: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:23 +0200
Message-Id: <1368173847-5661-39-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 arch/arm/plat-omap/dmtimer.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 869254c..da1a3f7 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -814,12 +814,6 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (unlikely(!mem)) {
-		dev_err(dev, "%s: no memory resource.\n", __func__);
-		return -ENODEV;
-	}
-
 	timer = devm_kzalloc(dev, sizeof(struct omap_dm_timer), GFP_KERNEL);
 	if (!timer) {
 		dev_err(dev, "%s: memory alloc failed!\n", __func__);
@@ -827,6 +821,7 @@ static int omap_dm_timer_probe(struct platform_device *pdev)
 	}
 
 	timer->fclk = ERR_PTR(-ENODEV);
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	timer->io_base = devm_ioremap_resource(dev, mem);
 	if (IS_ERR(timer->io_base))
 		return PTR_ERR(timer->io_base);
-- 
1.7.10.4

