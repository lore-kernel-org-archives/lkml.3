Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3CFS3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 13:29:32 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53740 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3CFS2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 13:28:51 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Michal Marek <mmarek@suse.cz>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 4/6] ARM: tegra: create a DT header defining GPIO IDs
Date: Wed,  6 Mar 2013 11:28:35 -0700
Message-Id: <1362594517-22099-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
References: <1362594517-22099-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

All Tegra GPIOs are named after the GPIO bank and GPIO number within
the bank. Define a macro to calculate the GPIO ID based on those
parameters. Make the macro available via all Tegra .dtsip files.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Moved header file. Added include guard. Limit patch to just creating
    the new header file.
---
 include/dt-bindings/gpio/tegra-gpio.h |   50 +++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 include/dt-bindings/gpio/tegra-gpio.h

diff --git a/include/dt-bindings/gpio/tegra-gpio.h b/include/dt-bindings/gpio/tegra-gpio.h
new file mode 100644
index 0000000..4d179c0
--- /dev/null
+++ b/include/dt-bindings/gpio/tegra-gpio.h
@@ -0,0 +1,50 @@
+/*
+ * This header provides constants for binding nvidia,tegra*-gpio.
+ *
+ * The first cell in Tegra's GPIO specifier is the GPIO ID. The macros below
+ * provide names for this.
+ *
+ * The second cell contains standard flag values specified in gpio.h.
+ */
+
+#ifndef _DT_BINDINGS_GPIO_TEGRA_GPIO_H
+#define _DT_BINDINGS_GPIO_TEGRA_GPIO_H
+
+#include <dt-bindings/gpio/gpio.h>
+
+#define TEGRA_GPIO_BANK_ID_A 0
+#define TEGRA_GPIO_BANK_ID_B 1
+#define TEGRA_GPIO_BANK_ID_C 2
+#define TEGRA_GPIO_BANK_ID_D 3
+#define TEGRA_GPIO_BANK_ID_E 4
+#define TEGRA_GPIO_BANK_ID_F 5
+#define TEGRA_GPIO_BANK_ID_G 6
+#define TEGRA_GPIO_BANK_ID_H 7
+#define TEGRA_GPIO_BANK_ID_I 8
+#define TEGRA_GPIO_BANK_ID_J 9
+#define TEGRA_GPIO_BANK_ID_K 10
+#define TEGRA_GPIO_BANK_ID_L 11
+#define TEGRA_GPIO_BANK_ID_M 12
+#define TEGRA_GPIO_BANK_ID_N 13
+#define TEGRA_GPIO_BANK_ID_O 14
+#define TEGRA_GPIO_BANK_ID_P 15
+#define TEGRA_GPIO_BANK_ID_Q 16
+#define TEGRA_GPIO_BANK_ID_R 17
+#define TEGRA_GPIO_BANK_ID_S 18
+#define TEGRA_GPIO_BANK_ID_T 19
+#define TEGRA_GPIO_BANK_ID_U 20
+#define TEGRA_GPIO_BANK_ID_V 21
+#define TEGRA_GPIO_BANK_ID_W 22
+#define TEGRA_GPIO_BANK_ID_X 23
+#define TEGRA_GPIO_BANK_ID_Y 24
+#define TEGRA_GPIO_BANK_ID_Z 25
+#define TEGRA_GPIO_BANK_ID_AA 26
+#define TEGRA_GPIO_BANK_ID_BB 27
+#define TEGRA_GPIO_BANK_ID_CC 28
+#define TEGRA_GPIO_BANK_ID_DD 29
+#define TEGRA_GPIO_BANK_ID_EE 30
+
+#define TEGRA_GPIO(bank, offset) \
+	((TEGRA_GPIO_BANK_ID_##bank * 8) + offset)
+
+#endif
-- 
1.7.10.4

