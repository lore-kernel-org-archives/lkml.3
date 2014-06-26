Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbaFZSQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 14:16:30 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33302 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbaFZSQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 14:16:26 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 03/14] clk: max77686: Add DT include for MAX77686 PMIC clock
Date: Thu, 26 Jun 2014 20:15:35 +0200
Message-Id: <1403806546-31122-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dt-binding include for Maxim 77686
PMIC clock IDs that can be to be shared between the
clk-max77686 clock driver and DeviceTree source files.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---

Changes since v4: None

Changes since v3: None

 drivers/clk/clk-max77686.c                 |  7 +------
 include/dt-bindings/clock/maxim,max77686.h | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 6 deletions(-)
 create mode 100644 include/dt-bindings/clock/maxim,max77686.h

diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index 3d7e8dd..185b611 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -30,12 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/clkdev.h>
 
-enum {
-	MAX77686_CLK_AP = 0,
-	MAX77686_CLK_CP,
-	MAX77686_CLK_PMIC,
-	MAX77686_CLKS_NUM,
-};
+#include <dt-bindings/clock/maxim,max77686.h>
 
 struct max77686_clk {
 	struct max77686_dev *iodev;
diff --git a/include/dt-bindings/clock/maxim,max77686.h b/include/dt-bindings/clock/maxim,max77686.h
new file mode 100644
index 0000000..7b28b09
--- /dev/null
+++ b/include/dt-bindings/clock/maxim,max77686.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants clocks for the Maxim 77686 PMIC.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_MAXIM_MAX77686_CLOCK_H
+#define _DT_BINDINGS_CLOCK_MAXIM_MAX77686_CLOCK_H
+
+/* Fixed rate clocks. */
+
+#define MAX77686_CLK_AP		0
+#define MAX77686_CLK_CP		1
+#define MAX77686_CLK_PMIC	2
+
+/* Total number of clocks. */
+#define MAX77686_CLKS_NUM		(MAX77686_CLK_PMIC + 1)
+
+#endif /* _DT_BINDINGS_CLOCK_MAXIM_MAX77686_CLOCK_H */
-- 
2.0.0.rc2

