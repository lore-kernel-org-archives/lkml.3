Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaBUQoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:44:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65202 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaBUQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:44:21 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-46-53078264edcd
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for
 ARCH_EXYNOS
Date: Fri, 21 Feb 2014 17:44:02 +0100
Message-id: <1393001042-5951-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393001042-5951-1-git-send-email-s.nawrocki@samsung.com>
References: <1393001042-5951-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xoG5KE3uwwcrlvBaXF15itbjwtIfN
	YtPja6wWl3fNYbOYcX4fk8XhN+2sDmwem5fUe/RtWcXocfzGdiaPz5vkAliiuGxSUnMyy1KL
	9O0SuDLe73/GXvCGo+LaJusGxvnsXYycHBICJhK7961kgrDFJC7cW8/WxcjFISQwnVHi2Zuf
	jBBOB5PE1dZZYFVsAoYSvUf7gBIcHCICghKfPjGChJkF1jNK3PtjBmILC4RIHLnZDhZnEVCV
	+LvhGlgrr4CrxJyHH5lAWiUEFCTmTLIBCXMKuEnsWf2ADcQWAipZ3f6BcQIj7wJGhlWMoqkF
	yQXFSem5RnrFibnFpXnpesn5uZsYwaHzTHoH46oGi0OMAhyMSjy8DqnswUKsiWXFlbmHGCU4
	mJVEeJujgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoY
	w55paa767H38YcDinV/+PnDZ51euLjdZY5pU53LfnQa6nItPp8olCE1MKo4Q4uSbpRy/UsF9
	6tPDjup8894s1PxWwzEp6PZbkbgnm7Y+03xee0r8Q/6Srv7mm9nJNx5f26uRul2h1tRky4+l
	XUcqF7FF7VlRxldkVjjB4WlhtYqW3oP5vVdeK7EUZyQaajEXFScCAPa0hE8ZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of requiring user to figure out when PHY_EXYNOS_DP_VIDEO needs
to be selected select it by default for Exynos SoCs. Also enable it
when COMPILE_TEST is selected. If required the display port PHY driver
can be then disabled or compiled in as module.

Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v2:
 - s/default y/default ARCH_EXYNOS

Changes since first version:
 - use ARCH_EXYNOS instead of "ARCH_EXYNOS4 || ARCH_EXYNOS5"
 - add dependency on COMPILE_TEST
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index d71be95..fe1b1f4 100644
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

