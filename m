Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3FHX77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 19:59:59 -0400
Received: from gloria.sntech.de ([95.129.55.99]:37120 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3FHX76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 19:59:58 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: add devicetree constants for simple generic pnconfig options
Date: Sun, 9 Jun 2013 01:59:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Patrice Chotard <patrice.chotard.st@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201306090159.05383.heiko@sntech.de>
In-Reply-To: <201306090159.05383.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306090159.54323.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most pinconfig options either ignore the argument or only have two states
for them. Therefore it's possible to combine them into one value in dt
bindings as bits, resulting in smaller pin definitions.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/pinctrl/pinctrl-bindings.txt          |    6 +++
 include/dt-bindings/pinctrl/pinconfig.h            |   37 ++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/pinconfig.h

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
index c95ea82..d206da0 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -126,3 +126,9 @@ device; they may be grandchildren, for example. Whether this is legal, and
 whether there is any interaction between the child and intermediate parent
 nodes, is again defined entirely by the binding for the individual pin
 controller device.
+
+== Generic pinctrl config settings ==
+
+dt-bindings/pinctrl/pinconfig.h defines a set of constants to combine basic
+generic pinconfig settings, like pulls, into one value, that can be used
+in pinctrl bindings like <bank pin mux CONFIG>.
diff --git a/include/dt-bindings/pinctrl/pinconfig.h b/include/dt-bindings/pinctrl/pinconfig.h
new file mode 100644
index 0000000..b6ad251
--- /dev/null
+++ b/include/dt-bindings/pinctrl/pinconfig.h
@@ -0,0 +1,37 @@
+/*
+ * Header providing constants for generic pinconf bindings.
+ *
+ * Copyright (c) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __DT_BINDINGS_PINCTRL_PINCONFIG_H__
+#define __DT_BINDINGS_PINCTRL_PINCONFIG_H__
+
+#define PINCONFIG_NONE			0
+#define PINCONFIG_BIAS_DISABLE		(1 << 0)
+#define PINCONFIG_BIAS_HIGH_IMPEDANCE	(1 << 1)
+#define PINCONFIG_BIAS_BUS_HOLD		(1 << 2)
+#define PINCONFIG_BIAS_PULL_PIN_DEFAULT	(1 << 3)
+#define PINCONFIG_BIAS_PULL_UP		(1 << 4)
+#define PINCONFIG_BIAS_PULL_DOWN	(1 << 5)
+#define PINCONFIG_DRIVE_PUSH_PULL	(1 << 6)
+#define PINCONFIG_DRIVE_OPEN_DRAIN	(1 << 7)
+#define PINCONFIG_DRIVE_OPEN_SOURCE	(1 << 8)
+#define PINCONFIG_INPUT_SCHMITT_ENABLE	(1 << 9)
+#define PINCONFIG_INPUT_SCHMITT_DISABLE	(1 << 10)
+#define PINCONFIG_LOW_POWER_MODE	(1 << 11)
+#define PINCONFIG_OUTPUT_LOW		(1 << 12)
+#define PINCONFIG_OUTPUT_HIGH		(1 << 13)
+
+#endif
-- 
1.7.2.3

