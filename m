Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3LUC7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 21:59:07 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:51776 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752114Ab3LUC5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 21:57:43 -0500
From: Ravi Patel <rapatel@apm.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jcm@redhat.com, patches@apm.com, Ravi Patel <rapatel@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: [PATCH V2 1/4] Documentation: Add documentation for APM X-Gene SoC Queue Manager/Traffic Manager DTS binding
Date: Fri, 20 Dec 2013 18:57:28 -0800
Message-Id: <1387594651-25771-2-git-send-email-rapatel@apm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387594651-25771-1-git-send-email-rapatel@apm.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for APM X-Gene SoC
 Queue Manager/Traffic Manager.

Signed-off-by: Ravi Patel <rapatel@apm.com>
Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
---
 .../devicetree/bindings/misc/apm-xgene-qmtm.txt    |   51 ++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/apm-xgene-qmtm.txt

diff --git a/Documentation/devicetree/bindings/misc/apm-xgene-qmtm.txt b/Documentation/devicetree/bindings/misc/apm-xgene-qmtm.txt
new file mode 100644
index 0000000..c3fcbd2
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/apm-xgene-qmtm.txt
@@ -0,0 +1,51 @@
+* APM X-Gene SoC Queue Manager/Traffic Manager nodes
+
+QMTM nodes are defined to describe on-chip Queue Managers in APM X-Gene SoC.
+APM X-Gene SoC Ethernet, PktDMA (XOR Engine), and Security Engine subsystems
+communicate with a central Queue Manager using messages which include
+information about the work to be performed and the location of the associated
+data buffers. There are multiple instances of QMTM. Each QMTM instance has its
+own node. Its corresponding clock nodes are shown below.
+
+Required properties:
+- compatible		: Shall be "apm,xgene-qmtm-lite" for QMLite instance
+- reg			: First memory resource shall be the QMTM CSR memory
+			  resource.
+			  Second memory resource shall be the QMTM IO-Fabric
+			  memory resource.
+- slave-name		: Shall be "CPU_QMTM3" which is receiver for ingress
+			  work messages for the QMTM. Here receiver is CPU.
+- interrupts		: First interrupt resource shall be the QMTM Error
+			  interrupt.
+			  Remaining interrupt resources shall be the Ingress
+			  work message interrupt mapping for receiver,
+			  receiving work messages for the QMTM.
+- clocks		: Reference to the clock entry.
+
+Optional properties:
+- status		: Shall be "ok" if enabled or "disabled" if disabled.
+			  Default is "ok".
+
+Example:
+		qmlclk: qmlclk {
+			compatible = "apm,xgene-device-clock";
+			#clock-cells = <1>;
+			clock-names = "qmlclk";
+			status = "ok";
+			csr-offset = <0x0>;
+			csr-mask = <0x3>;
+			enable-offset = <0x8>;
+			enable-mask = <0x3>;
+		};
+
+		qmlite: qmtm@17030000 {
+			compatible = "apm,xgene-qmtm-lite";
+			reg = <0x0 0x17030000 0x0 0x10000>,
+			      <0x0 0x10000000 0x0 0x400000>;
+			slave-name = "CPU_QMTM3";
+			interrupts = <0x0 0x40 0x4>,
+				     <0x0 0x3c 0x4>;
+			status = "ok";
+			#clock-cells = <1>;
+			clocks = <&qmlclk 0>;
+		};
-- 
1.7.9.5

