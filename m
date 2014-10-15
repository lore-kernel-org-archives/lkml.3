Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaJOQWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:22:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33557 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbaJOQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:21:03 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 6/9] regulator: max77802: Add header for operating modes
Date: Wed, 15 Oct 2014 18:20:36 +0200
Message-Id: <1413390039-19364-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a header file for the max77802 constants that could be shared between
the regulator driver and Device Tree source files. Also, remove standby
and off opmodes since only normal and low power are valid operating modes.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c                   |  1 +
 include/dt-bindings/regulator/maxim,max77802.h | 18 ++++++++++++++++++
 include/linux/mfd/max77686.h                   |  7 -------
 3 files changed, 19 insertions(+), 7 deletions(-)
 create mode 100644 include/dt-bindings/regulator/maxim,max77802.h

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 046b9b7..43e34dd 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -33,6 +33,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/mfd/max77686.h>
 #include <linux/mfd/max77686-private.h>
+#include <dt-bindings/regulator/maxim,max77802.h>
 
 /* Default ramp delay in case it is not manually set */
 #define MAX77802_RAMP_DELAY		100000		/* uV/us */
diff --git a/include/dt-bindings/regulator/maxim,max77802.h b/include/dt-bindings/regulator/maxim,max77802.h
new file mode 100644
index 0000000..cf28631
--- /dev/null
+++ b/include/dt-bindings/regulator/maxim,max77802.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Device Tree binding constants for the Maxim 77802 PMIC regulators
+ */
+
+#ifndef _DT_BINDINGS_REGULATOR_MAXIM_MAX77802_H
+#define _DT_BINDINGS_REGULATOR_MAXIM_MAX77802_H
+
+/* Regulator operating modes */
+#define MAX77802_OPMODE_LP	1
+#define MAX77802_OPMODE_NORMAL	3
+
+#endif /* _DT_BINDINGS_REGULATOR_MAXIM_MAX77802_H */
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index 7e6dc4b..553f7d0 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -131,13 +131,6 @@ enum max77686_opmode {
 	MAX77686_OPMODE_STANDBY,
 };
 
-enum max77802_opmode {
-	MAX77802_OPMODE_OFF,
-	MAX77802_OPMODE_STANDBY,
-	MAX77802_OPMODE_LP,
-	MAX77802_OPMODE_NORMAL,
-};
-
 struct max77686_opmode_data {
 	int id;
 	int mode;
-- 
2.1.0

