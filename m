Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaBUPva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:51:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43408 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaBUPv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:51:27 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-60-530775fe3ea0
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: kishon@ti.com
Cc: linux-kernel@vger.kernel.org, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for
 ARCH_EXYNOS
Date: Fri, 21 Feb 2014 16:50:02 +0100
Message-id: <1392997802-29050-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com>
References: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xgO6/UvZgg+tv1SwuL7zEanHhaQ+b
	xabH11gtLu+aw2Yx4/w+JovDb9pZHdg8Ni+p9+jbsorR4/iN7UwenzfJBbBEcdmkpOZklqUW
	6dslcGUcbdrPVLCSo2Liae0GxhdsXYycHBICJhKXL9yBssUkLtxbD2RzcQgJLGKUWLLnKjuE
	08Ek8WPfLxaQKjYBQ4neo32MXYwcHCICghKfPjGChJkF1jNK3PtjBmILC4RI7On9xwRiswio
	Shxdfw5sAa+Am8S1K+2sIK0SAgoScybZgIQ5BdwlTu6AmC4EVPL76WH2CYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEh84z6R2MqxosDjEKcDAq8fA6pLIHC7EmlhVX5h5ilOBg
	VhLhbY4GCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamD0
	Ob1G+lafXdo+L5XJjq6vBXU5tkhPnujdskx63Vyvky/lz2eZRnzgZa+uX3y8c8/jlXzck26s
	tG4vWOx5ttzecMl85rt6NtxNd9mUbgd8Sph/jbfzy46g6km3sxprWYrsOJmi8m5PDmlyEC0+
	G3D46R/J9uDdfVNyHLftzFnbNWXih5Zp0TFKLMUZiYZazEXFiQCUqZD1GQIAAA==
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
Changes since first version:
 - use ARCH_EXYNOS instead of "ARCH_EXYNOS4 || ARCH_EXYNOS5"
 - add dependency on COMPILE_TEST
---
 drivers/phy/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index ebd455c..4218c99 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -57,6 +57,8 @@ config TWL4030_USB
 config PHY_EXYNOS_DP_VIDEO
 	tristate "EXYNOS SoC series Display Port PHY driver"
 	depends on OF
+	depends on ARCH_EXYNOS || COMPILE_TEST
+	default y
 	select GENERIC_PHY
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
-- 
1.7.9.5

