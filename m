Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3LEKr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:47:56 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3654 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3LEKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:47:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Dec 2013 02:44:48 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/4] ARM: tegra: Add header file for pinctrl constants
Date: Thu, 5 Dec 2013 16:14:06 +0530
Message-ID: <1386240249-30786-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
References: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new header file defines pincontrol constants for Tegra to
use from Tegra's DTS file for pincontrol properties option.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Thierry Reding <treding@nvidia.com>
---
Changes from V1:
- Get rid of lots of macro and converge it to TEGRA_PIN_ENABLE/DISABLE.
- Change macro name for PULL UP/DOWN/NONE.

Changes from V2:
- Convert TEGRA -> Tegra.
- Add comment on ENABLE/DSIABLE and remove from pulls.

 include/dt-bindings/pinctrl/pinctrl-tegra.h |   45 +++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra.h

diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra.h b/include/dt-bindings/pinctrl/pinctrl-tegra.h
new file mode 100644
index 0000000..ebafa49
--- /dev/null
+++ b/include/dt-bindings/pinctrl/pinctrl-tegra.h
@@ -0,0 +1,45 @@
+/*
+ * This header provides constants for Tegra pinctrl bindings.
+ *
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _DT_BINDINGS_PINCTRL_TEGRA_H
+#define _DT_BINDINGS_PINCTRL_TEGRA_H
+
+/*
+ * Enable/disable for diffeent dt properties. This is applicable for
+ * properties nvidia,enable-input, nvidia,tristate, nvidia,open-drain,
+ * nvidia,lock, nvidia,rcv-sel, nvidia,high-speed-mode, nvidia,schmitt.
+ */
+#define TEGRA_PIN_DISABLE				0
+#define TEGRA_PIN_ENABLE				1
+
+#define TEGRA_PIN_PULL_NONE				0
+#define TEGRA_PIN_PULL_DOWN				1
+#define TEGRA_PIN_PULL_UP				2
+
+/* Low power mode driver */
+#define TEGRA_PIN_LP_DRIVE_DIV_8			0
+#define TEGRA_PIN_LP_DRIVE_DIV_4			1
+#define TEGRA_PIN_LP_DRIVE_DIV_2			2
+#define TEGRA_PIN_LP_DRIVE_DIV_1			3
+
+/* Rising/Falling slew rate */
+#define TEGRA_PIN_SLEW_RATE_FASTEST			0
+#define TEGRA_PIN_SLEW_RATE_FAST			1
+#define TEGRA_PIN_SLEW_RATE_SLOW			2
+#define TEGRA_PIN_SLEW_RATE_SLOWEST			3
+
+#endif
-- 
1.7.1.1

