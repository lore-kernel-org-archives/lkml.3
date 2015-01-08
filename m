Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbbAHWzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:55:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43617 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbbAHWzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:55:02 -0500
From: Andy Gross <agross@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/2] soc: qcom: Add device tree binding for TCSR
Date: Thu,  8 Jan 2015 16:52:57 -0600
Message-Id: <1420757577-20425-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
References: <1420757577-20425-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding support for the QCOM TCSR driver.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/soc/qcom/qcom,tcsr.txt     |   33 +++++++++++++++++++
 include/dt-bindings/soc/qcom,tcsr.h                |   34 ++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,tcsr.txt
 create mode 100644 include/dt-bindings/soc/qcom,tcsr.h

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,tcsr.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,tcsr.txt
new file mode 100644
index 0000000..782a307
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,tcsr.txt
@@ -0,0 +1,33 @@
+QCOM TCSR (Top Control and Status Register) Driver
+
+The TCSR provides miscellaneous control functions and status registers for
+Qualcomm processors.
+
+Required properties:
+- compatible: must contain "qcom,tcsr" for IPQ806x and APQ8064
+- reg: Address range for TCSR registers
+
+Optional properties:
+- qcom,usb-ctrl-select : indicates USB port type selection.  Please reference
+  dt-bindings/soc/qcom,tcsr.h for valid USB port selection values.
+- qcom,adm-a-crci-mux-sel : indicates the CRCI mux settings for peripherals.
+  Please reference dt-bindings/soc/qcom,tcsr.h for valid selection values.
+- qcom,adm-b-crci-mux-sel : indicates the CRCI mux settings for peripherals.
+  Please reference dt-bindings/soc/qcom,tcsr.h for valid selection values.
+
+Example for IPQ8064:
+
+#include <dt-bindings/soc/qcom,tcsr.h>
+
+		tcsr: tcsr@1a400000 {
+			compatible = "qcom,tcsr";
+			reg = <0x1a400000 0x100>;
+
+			qcom,usb-ctrl-select = <TCSR_USB_SELECT_USB3_DUAL>;
+			qcom,adm-a-crci-mux-sel =
+				< TCSR_ADM_CRCI_SEL(GSBI1, ADM_CRCI_QUP)>;
+			qcom,adm-b-crci-mux-sel =
+				< TCSR_ADM_CRCI_SEL(GSBI1, ADM_CRCI_QUP)>;
+		};
+
+
diff --git a/include/dt-bindings/soc/qcom,tcsr.h b/include/dt-bindings/soc/qcom,tcsr.h
new file mode 100644
index 0000000..8e18354
--- /dev/null
+++ b/include/dt-bindings/soc/qcom,tcsr.h
@@ -0,0 +1,34 @@
+/* Copyright (c) 2015, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __DT_BINDINGS_QCOM_TCSR_H
+#define __DT_BINDINGS_QCOM_TCSR_H
+
+#define TCSR_USB_SELECT_USB3_P0		0x1
+#define TCSR_USB_SELECT_USB3_P1		0x2
+#define TCSR_USB_SELECT_USB3_DUAL	0x3
+
+#define GSBI1				1
+#define GSBI2				2
+#define GSBI3				3
+#define GSBI4				4
+#define GSBI5				5
+#define GSBI6				6
+#define GSBI7				7
+
+/* values are in pairs - RX/TX.  So both are 0 or both are 1 */
+#define ADM_CRCI_QUP			0
+#define ADM_CRCI_UART			3
+
+/* calculate CRCI value by shifting the value by correct shift */
+#define TCSR_ADM_CRCI_SEL(gsbi, val)	(val << (gsbi-1)*2)
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

