Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459AbaDKOft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:35:49 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54300 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758994AbaDKOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:35:12 -0400
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
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Giuseppe Condorelli <giuseppe.condorelli@st.com>
Subject: [PATCH v3 6/7] ARM: STi: DT: add keyscan for stih41x-b2000
Date: Fri, 11 Apr 2014 16:33:37 +0200
Message-Id: <1397226820-5604-11-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397226820-5604-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1397226820-5604-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-11_04:2014-04-11,2014-04-11,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add keyscan setup for stih415/h416 b2000.
Both have same raw/column lines number, debounce time and keymap.

Signed-off-by: Giuseppe Condorelli <giuseppe.condorelli@st.com>
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih41x-b2000.dtsi | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/stih41x-b2000.dtsi b/arch/arm/boot/dts/stih41x-b2000.dtsi
index bf65c49..403bf1b 100644
--- a/arch/arm/boot/dts/stih41x-b2000.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2000.dtsi
@@ -6,6 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * publishhed by the Free Software Foundation.
  */
+#include <dt-bindings/input/input.h>
 / {
 
 	memory{
@@ -68,5 +69,27 @@
 			snps,reset-active-low;
 			snps,reset-delays-us 	= <0 10000 10000>;
 		};
+
+		keyscan: keyscan@fe4b0000 {
+			keypad,num-rows = <4>;
+			keypad,num-columns = <4>;
+			st,debounce-us = <5000>;
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
1.9.1

