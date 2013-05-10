Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3EJIUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:20:52 -0400
Received: from sauhun.de ([89.238.76.85]:60611 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab3EJIRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:44 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [RFC 37/42] arch/arm/mach-tegra: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:22 +0200
Message-Id: <1368173847-5661-38-git-send-email-wsa@the-dreams.de>
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
 arch/arm/mach-tegra/tegra2_emc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra2_emc.c b/arch/arm/mach-tegra/tegra2_emc.c
index 9e8bdfa..31e69a0 100644
--- a/arch/arm/mach-tegra/tegra2_emc.c
+++ b/arch/arm/mach-tegra/tegra2_emc.c
@@ -307,11 +307,6 @@ static int tegra_emc_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "missing register base\n");
-		return -ENOMEM;
-	}
-
 	emc_regbase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(emc_regbase))
 		return PTR_ERR(emc_regbase);
-- 
1.7.10.4

