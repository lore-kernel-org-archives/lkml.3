Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaIAPod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:44:33 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37132 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaIAPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:44:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 4/8] staging: rtl8188eu: Rename Hal8188EPwrSeq.c to pwrseq.c
Date: Mon,  1 Sep 2014 21:13:39 +0530
Message-Id: <1409586223-5915-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
References: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile             |    2 +-
 drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c |  102 ------------------------
 drivers/staging/rtl8188eu/hal/pwrseq.c         |  102 ++++++++++++++++++++++++
 3 files changed, 103 insertions(+), 103 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
 create mode 100644 drivers/staging/rtl8188eu/hal/pwrseq.c

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index af919c3..a309451 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -23,7 +23,7 @@ r8188eu-y :=				\
 		hal/rf_cfg.o \
 		hal/HalPhyRf_8188e.o	\
 		hal/HalPwrSeqCmd.o	\
-		hal/Hal8188EPwrSeq.o	\
+		hal/pwrseq.o \
 		hal/Hal8188ERateAdaptive.o\
 		hal/hal_intf.o		\
 		hal/hal_com.o		\
diff --git a/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c b/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
deleted file mode 100644
index 4c29e63..0000000
--- a/drivers/staging/rtl8188eu/hal/Hal8188EPwrSeq.c
+++ /dev/null
@@ -1,102 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- *
- ******************************************************************************/
-
-#include "Hal8188EPwrSeq.h"
-#include <rtl8188e_hal.h>
-
-/*
-    drivers should parse below arrays and do the corresponding actions
-*/
-/* 3 Power on  Array */
-struct wl_pwr_cfg rtl8188E_power_on_flow[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS +
-					 RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_CARDEMU_TO_ACT
-	RTL8188E_TRANS_END
-};
-
-/* 3Radio off Array */
-struct wl_pwr_cfg rtl8188E_radio_off_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
-					  RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_ACT_TO_CARDEMU
-	RTL8188E_TRANS_END
-};
-
-/* 3Card Disable Array */
-struct wl_pwr_cfg rtl8188E_card_disable_flow
-	[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
-	 RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
-	 RTL8188E_TRANS_END_STEPS] = {
-		RTL8188E_TRANS_ACT_TO_CARDEMU
-		RTL8188E_TRANS_CARDEMU_TO_CARDDIS
-		RTL8188E_TRANS_END
-};
-
-/* 3 Card Enable Array */
-struct wl_pwr_cfg rtl8188E_card_enable_flow
-	[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
-	 RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
-	 RTL8188E_TRANS_END_STEPS] = {
-		RTL8188E_TRANS_CARDDIS_TO_CARDEMU
-		RTL8188E_TRANS_CARDEMU_TO_ACT
-		RTL8188E_TRANS_END
-};
-
-/* 3Suspend Array */
-struct wl_pwr_cfg rtl8188E_suspend_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
-					RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
-					RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_ACT_TO_CARDEMU
-	RTL8188E_TRANS_CARDEMU_TO_SUS
-	RTL8188E_TRANS_END
-};
-
-/* 3 Resume Array */
-struct wl_pwr_cfg rtl8188E_resume_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
-				       RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
-				       RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_SUS_TO_CARDEMU
-	RTL8188E_TRANS_CARDEMU_TO_ACT
-	RTL8188E_TRANS_END
-};
-
-/* 3HWPDN Array */
-struct wl_pwr_cfg rtl8188E_hwpdn_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
-				      RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
-				      RTL8188E_TRANS_END_STEPS] = {
-	RTL8188E_TRANS_ACT_TO_CARDEMU
-	RTL8188E_TRANS_CARDEMU_TO_PDN
-	RTL8188E_TRANS_END
-};
-
-/* 3 Enter LPS */
-struct wl_pwr_cfg rtl8188E_enter_lps_flow[RTL8188E_TRANS_ACT_TO_LPS_STEPS +
-					  RTL8188E_TRANS_END_STEPS] = {
-	/* FW behavior */
-	RTL8188E_TRANS_ACT_TO_LPS
-	RTL8188E_TRANS_END
-};
-
-/* 3 Leave LPS */
-struct wl_pwr_cfg rtl8188E_leave_lps_flow[RTL8188E_TRANS_LPS_TO_ACT_STEPS +
-					  RTL8188E_TRANS_END_STEPS] = {
-	/* FW behavior */
-	RTL8188E_TRANS_LPS_TO_ACT
-	RTL8188E_TRANS_END
-};
diff --git a/drivers/staging/rtl8188eu/hal/pwrseq.c b/drivers/staging/rtl8188eu/hal/pwrseq.c
new file mode 100644
index 0000000..4c29e63
--- /dev/null
+++ b/drivers/staging/rtl8188eu/hal/pwrseq.c
@@ -0,0 +1,102 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ *
+ ******************************************************************************/
+
+#include "Hal8188EPwrSeq.h"
+#include <rtl8188e_hal.h>
+
+/*
+    drivers should parse below arrays and do the corresponding actions
+*/
+/* 3 Power on  Array */
+struct wl_pwr_cfg rtl8188E_power_on_flow[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS +
+					 RTL8188E_TRANS_END_STEPS] = {
+	RTL8188E_TRANS_CARDEMU_TO_ACT
+	RTL8188E_TRANS_END
+};
+
+/* 3Radio off Array */
+struct wl_pwr_cfg rtl8188E_radio_off_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+					  RTL8188E_TRANS_END_STEPS] = {
+	RTL8188E_TRANS_ACT_TO_CARDEMU
+	RTL8188E_TRANS_END
+};
+
+/* 3Card Disable Array */
+struct wl_pwr_cfg rtl8188E_card_disable_flow
+	[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+	 RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+	 RTL8188E_TRANS_END_STEPS] = {
+		RTL8188E_TRANS_ACT_TO_CARDEMU
+		RTL8188E_TRANS_CARDEMU_TO_CARDDIS
+		RTL8188E_TRANS_END
+};
+
+/* 3 Card Enable Array */
+struct wl_pwr_cfg rtl8188E_card_enable_flow
+	[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+	 RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+	 RTL8188E_TRANS_END_STEPS] = {
+		RTL8188E_TRANS_CARDDIS_TO_CARDEMU
+		RTL8188E_TRANS_CARDEMU_TO_ACT
+		RTL8188E_TRANS_END
+};
+
+/* 3Suspend Array */
+struct wl_pwr_cfg rtl8188E_suspend_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+					RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
+					RTL8188E_TRANS_END_STEPS] = {
+	RTL8188E_TRANS_ACT_TO_CARDEMU
+	RTL8188E_TRANS_CARDEMU_TO_SUS
+	RTL8188E_TRANS_END
+};
+
+/* 3 Resume Array */
+struct wl_pwr_cfg rtl8188E_resume_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+				       RTL8188E_TRANS_CARDEMU_TO_SUS_STEPS +
+				       RTL8188E_TRANS_END_STEPS] = {
+	RTL8188E_TRANS_SUS_TO_CARDEMU
+	RTL8188E_TRANS_CARDEMU_TO_ACT
+	RTL8188E_TRANS_END
+};
+
+/* 3HWPDN Array */
+struct wl_pwr_cfg rtl8188E_hwpdn_flow[RTL8188E_TRANS_ACT_TO_CARDEMU_STEPS +
+				      RTL8188E_TRANS_CARDEMU_TO_PDN_STEPS +
+				      RTL8188E_TRANS_END_STEPS] = {
+	RTL8188E_TRANS_ACT_TO_CARDEMU
+	RTL8188E_TRANS_CARDEMU_TO_PDN
+	RTL8188E_TRANS_END
+};
+
+/* 3 Enter LPS */
+struct wl_pwr_cfg rtl8188E_enter_lps_flow[RTL8188E_TRANS_ACT_TO_LPS_STEPS +
+					  RTL8188E_TRANS_END_STEPS] = {
+	/* FW behavior */
+	RTL8188E_TRANS_ACT_TO_LPS
+	RTL8188E_TRANS_END
+};
+
+/* 3 Leave LPS */
+struct wl_pwr_cfg rtl8188E_leave_lps_flow[RTL8188E_TRANS_LPS_TO_ACT_STEPS +
+					  RTL8188E_TRANS_END_STEPS] = {
+	/* FW behavior */
+	RTL8188E_TRANS_LPS_TO_ACT
+	RTL8188E_TRANS_END
+};
-- 
1.7.10.4

