Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbaIAPaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:30:35 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64099 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaIAPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:30:31 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>, rabin@rab.in,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v8 1/7] clk: Add temporary mapping to the existing API
Date: Mon,  1 Sep 2014 17:29:36 +0200
Message-Id: <1409585377-26091-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409585377-26091-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1409585377-26091-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To preserve git-bisectability, add aliases from the future provider API to the
existing public API.

Also includes clk-provider.h and clk-dev.h in a few places so the right
functions are defined.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>

---
v7: * Add mappings for clk_notifier_[un]register
    * Add more clk-provider.h includes to clk implementations

v4: * Add more clk-provider.h includes to clk implementations
    * Add mapping for clk_provider_round_rate
---
 arch/arm/mach-omap2/display.c                 |  1 +
 arch/arm/mach-omap2/omap_device.c             |  1 +
 arch/arm/mach-shmobile/clock.c                |  1 +
 arch/arm/plat-orion/common.c                  |  1 +
 drivers/clk/berlin/bg2.c                      |  1 +
 drivers/clk/berlin/bg2q.c                     |  1 +
 drivers/clk/clk-conf.c                        |  1 +
 drivers/clk/clkdev.c                          |  1 +
 drivers/media/platform/exynos4-is/media-dev.c |  1 +
 include/linux/clk-provider.h                  | 25 +++++++++++++++++++++++++
 include/linux/clk/zynq.h                      |  1 +
 11 files changed, 35 insertions(+)

diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index bf852d7..0f9e479 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/of.h>
diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
index d22c30d..f138a62 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/notifier.h>
diff --git a/arch/arm/mach-shmobile/clock.c b/arch/arm/mach-shmobile/clock.c
index 806f940..ed415dc 100644
--- a/arch/arm/mach-shmobile/clock.c
+++ b/arch/arm/mach-shmobile/clock.c
@@ -24,6 +24,7 @@
 
 #ifdef CONFIG_COMMON_CLK
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include "clock.h"
 
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index 3ec6e8e..961b593 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -15,6 +15,7 @@
 #include <linux/serial_8250.h>
 #include <linux/ata_platform.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/mv643xx_eth.h>
 #include <linux/mv643xx_i2c.h>
diff --git a/drivers/clk/berlin/bg2.c b/drivers/clk/berlin/bg2.c
index 515fb13..4c81e09 100644
--- a/drivers/clk/berlin/bg2.c
+++ b/drivers/clk/berlin/bg2.c
@@ -19,6 +19,7 @@
 
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
index 21784e4..748da9b 100644
--- a/drivers/clk/berlin/bg2q.c
+++ b/drivers/clk/berlin/bg2q.c
@@ -19,6 +19,7 @@
 
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
index aad4796..d36a7b3 100644
--- a/drivers/clk/clk-conf.c
+++ b/drivers/clk/clk-conf.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/clkdev.h>
 #include <linux/clk-provider.h>
 #include <linux/clk/clk-conf.h>
 #include <linux/device.h>
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index da4bda8..c751d0c 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mutex.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/of.h>
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 344718d..2620c48 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -13,6 +13,7 @@
 #include <linux/bug.h>
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 411dd7e..a1a7bb7 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -16,6 +16,31 @@
 
 #ifdef CONFIG_COMMON_CLK
 
+/* Temporarily map the to-be-added API to the old API, just so stuff compiles */
+#define clk_core			clk
+
+#define __clk_create_clk
+
+#define clk_provider_get			clk_get
+#define clk_provider_get_sys			clk_get_sys
+#define devm_clk_provider_get			devm_clk_get
+#define of_clk_provider_get			of_clk_get
+#define of_clk_provider_get_by_name		of_clk_get_by_name
+
+#define clk_provider_set_rate			clk_set_rate
+#define clk_provider_get_rate			clk_get_rate
+#define clk_provider_round_rate			clk_round_rate
+#define clk_provider_set_parent			clk_set_parent
+#define clk_provider_get_parent			clk_get_parent
+#define clk_provider_prepare			clk_prepare
+#define clk_provider_unprepare			clk_unprepare
+#define clk_provider_enable			clk_enable
+#define clk_provider_disable			clk_disable
+#define clk_provider_prepare_enable		clk_prepare_enable
+#define clk_provider_disable_unprepare		clk_unprepare
+#define clk_provider_notifier_register		clk_notifier_register
+#define clk_provider_notifier_unregister	clk_notifier_unregister
+
 /*
  * flags used across common struct clk.  these flags should only affect the
  * top-level framework.  custom flags for dealing with hardware specifics
diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
index 7a5633b..a990a59 100644
--- a/include/linux/clk/zynq.h
+++ b/include/linux/clk/zynq.h
@@ -21,6 +21,7 @@
 #define __LINUX_CLK_ZYNQ_H_
 
 #include <linux/spinlock.h>
+#include <linux/clk-provider.h>
 
 void zynq_clock_init(void);
 
-- 
1.9.3

