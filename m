Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCHJ3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:29:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46926 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaCHJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:29:40 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/28] phy: Select PHY_EXYNOS_DP_VIDEO by default for ARCH_EXYNOS
Date: Sat, 8 Mar 2014 14:59:06 +0530
Message-ID: <1394270969-11851-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Instead of requiring user to figure out when PHY_EXYNOS_DP_VIDEO needs
to be selected select it by default for Exynos SoCs. Also enable it
when COMPILE_TEST is selected. If required the display port PHY driver
can be then disabled or compiled in as module.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index f0fb429..5bf9ed3 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -57,6 +57,8 @@ config TWL4030_USB
 config PHY_EXYNOS_DP_VIDEO
 	tristate "EXYNOS SoC series Display Port PHY driver"
 	depends on OF
+	depends on ARCH_EXYNOS || COMPILE_TEST
+	default ARCH_EXYNOS
 	select GENERIC_PHY
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
-- 
1.7.9.5

