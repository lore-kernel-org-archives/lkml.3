Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbaCRPDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:03:55 -0400
Received: from mx08-00178001.pphosted.com ([62.209.51.94]:44740 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932070AbaCRPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:03:51 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: [PATCH v2 4/5] ARM: STi: DT: add keyscan for stih41x-b2000
Date: Tue, 18 Mar 2014 16:00:05 +0100
Message-Id: <1395154806-2810-5-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395154806-2810-1-git-send-email-gabriel.fernandez@st.com>
References: <1395154806-2810-1-git-send-email-gabriel.fernandez@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-18_05:2014-03-18,2014-03-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add keyscan setup for stih415/h416 b2000.
Both have same raw/column lines number, debounce time and keymap.

Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
---
 arch/arm/boot/dts/stih41x-b2000.dtsi | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
index 1e6aa92..c5f2191 100644
--- a/arch/arm/boot/dts/stih41x-b2000.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
@@ -6,6 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * publishhed by the Free Software Foundation.
  */
+#include <dt-bindings/input/input.h>
 / {
 
 	memory{
@@ -46,5 +47,27 @@
 
 			status = "okay";
 		};
+
+		keyscan: keyscan@fe4b0000 {
+			keypad,num-rows = <4>;
+			keypad,num-columns = <4>;
+			st,debounce_us = <5000>;
+			linux,keymap = < MATRIX_KEY(0x00, 0x00, KEY_F13)
+					 MATRIX_KEY(0x00, 0x01, KEY_F9)
+					 MATRIX_KEY(0x00, 0x02, KEY_F5)
+					 MATRIX_KEY(0x00, 0x03, KEY_F1)
+					 MATRIX_KEY(0x01, 0x00, KEY_F14)
+					 MATRIX_KEY(0x01, 0x01, KEY_F10)
+					 MATRIX_KEY(0x01, 0x02, KEY_F6)
+					 MATRIX_KEY(0x01, 0x03, KEY_F2)
+					 MATRIX_KEY(0x02, 0x00, KEY_F15)
+					 MATRIX_KEY(0x02, 0x01, KEY_F11)
+					 MATRIX_KEY(0x02, 0x02, KEY_F7)
+					 MATRIX_KEY(0x02, 0x03, KEY_F3)
+					 MATRIX_KEY(0x03, 0x00, KEY_F16)
+					 MATRIX_KEY(0x03, 0x01, KEY_F12)
+					 MATRIX_KEY(0x03, 0x02, KEY_F8)
+					 MATRIX_KEY(0x03, 0x03, KEY_F4) >;
+		};
 	};
 };
-- 
1.9.0

