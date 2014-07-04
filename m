Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030240AbaGDJ4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:56:09 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38072 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964984AbaGDJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:01 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v6 10/23] clk: max77686: Add DT include for MAX77686 PMIC clock
Date: Fri,  4 Jul 2014 11:55:09 +0200
Message-Id: <1404467722-26687-11-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dt-binding include for Maxim 77686
PMIC clock IDs that can be used by both the max77686
clock driver and Device Tree source files.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Mike Turquette <mturquette@linaro.org>
---

Changes since v5:
 - Improve wording in commit message. Suggested by Andreas Farber.

Changes since v4: None

Changes since v3:
 - Keep the note that this patch needs another change due wakeup
   ordering problems.
---
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

