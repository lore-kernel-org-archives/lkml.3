Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaGCNR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:17:26 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35219 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbaGCNRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:17:04 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [RFC PATCH v2 5/5] dt: rtc: add binding document for qpnp rtc
Date: Thu,  3 Jul 2014 16:14:03 +0300
Message-Id: <1404393243-7324-6-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
References: <1404393243-7324-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding document which describes the qpnp-rtc.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/rtc/qcom,rtc-qpnp.txt      |   24 ++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/qcom,rtc-qpnp.txt

diff --git a/Documentation/devicetree/bindings/rtc/qcom,rtc-qpnp.txt b/Documentation/devicetree/bindings/rtc/qcom,rtc-qpnp.txt
new file mode 100644
index 0000000..a64e194
--- /dev/null
+++ b/Documentation/devicetree/bindings/rtc/qcom,rtc-qpnp.txt
@@ -0,0 +1,24 @@
+Qualcomm RTC QPNP
+
+The RTC device supports 32bit RTC module housed inside QPNP PMIC's.
+The driver utilizes SPMI interface to communicate with the RTC module.
+RTC device is divided into two sub-peripherals one which controls
+basic RTC and other for controlling alarm.
+
+Required properties :
+ - compatible:  Should be "qcom,qpnp-rtc".
+ - reg:         Specify the peripheral id for device. Currently there
+                are two sub-peripherals - rtc base and alarm base.
+ - reg-names:   Specify the reg property as strings. Should be "rtc"
+                and "alarm", defining the rtc and alarm bases.
+ - interrupts:  Specifies alarm interrupt, only for alarm sub-peripheral.
+                For more info about interrupt cells see
+                Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
+
+Example:
+	rtc@6000 {
+		compatible = "qcom,qpnp-rtc";
+		reg = <0x6000 0x6100>;
+		reg-names = "rtc", "alarm";
+		interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
+	};
-- 
1.7.0.4

