Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaCDSfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:35:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54981 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaCDSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:34:56 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>, linux-input@vger.kernel.org,
        <devicetree@vger.kernel.org>
Subject: [PATCH v5 7/9] devicetree: bindings: Document PM8921/8058 keypads
Date: Tue,  4 Mar 2014 10:34:46 -0800
Message-Id: <1393958088-1456-8-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
References: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the keypad device found on PM8921 and PM8058 PMICs.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../bindings/input/qcom,pm8xxx-keypad.txt          | 89 ++++++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt

diff --git a/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
new file mode 100644
index 000000000000..7d8cb92831d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
@@ -0,0 +1,89 @@
+Qualcomm PM8xxx PMIC Keypad
+
+PROPERTIES
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8058-keypad"
+		    "qcom,pm8921-keypad"
+
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: address of keypad control register
+
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: the first interrupt specifies the key sense interrupt
+		    and the second interrupt specifies the key stuck interrupt.
+		    The format of the specifier is defined by the binding
+		    document describing the node's interrupt parent.
+
+- linux,keymap:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: the linux keymap. More information can be found in
+		    input/matrix-keymap.txt.
+
+- linux,keypad-no-autorepeat:
+	Usage: optional
+	Value type: <bool>
+	Definition: don't enable autorepeat feature.
+
+- linux,keypad-wakeup:
+	Usage: optional
+	Value type: <bool>
+	Definition: use any event on keypad as wakeup event.
+
+- keypad,num-rows:
+	Usage: required
+	Value type: <u32>
+	Definition: number of rows in the keymap. More information can be found
+		    in input/matrix-keymap.txt.
+
+- keypad,num-columns:
+	Usage: required
+	Value type: <u32>
+	Definition: number of columns in the keymap. More information can be
+		    found in input/matrix-keymap.txt.
+
+- debounce:
+	Usage: optional
+	Value type: <u32>
+	Definition: time in microseconds that key must be pressed or release
+		    for key sense interrupt to trigger.
+
+- scan-delay:
+	Usage: optional
+	Value type: <u32>
+	Definition: time in microseconds to pause between successive scans
+		    of the matrix array.
+
+- row-hold:
+	Usage: optional
+	Value type: <u32>
+	Definition: time in nanoseconds to pause between scans of each row in
+		    the matrix array.
+
+EXAMPLE
+
+	keypad@148 {
+		compatible = "qcom,pm8921-keypad";
+		reg = <0x148>;
+		interrupt-parent = <&pmicintc>;
+		interrupts = <74 1>, <75 1>;
+		linux,keymap = <
+			MATRIX_KEY(0, 0, KEY_VOLUMEUP)
+			MATRIX_KEY(0, 1, KEY_VOLUMEDOWN)
+			MATRIX_KEY(0, 2, KEY_CAMERA_FOCUS)
+			MATRIX_KEY(0, 3, KEY_CAMERA)
+			>;
+		keypad,num-rows = <1>;
+		keypad,num-columns = <5>;
+		debounce = <15>;
+		scan-delay = <32>;
+		row-hold = <91500>;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

