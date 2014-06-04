Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaFDQD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:03:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52930 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752244AbaFDQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:03:51 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] Documentation: bindings: add the marvell,berlin-smp CPU enable method
Date: Wed,  4 Jun 2014 18:03:44 +0200
Message-Id: <1401897826-11711-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401897826-11711-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401897826-11711-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the CPU enable method used by Marvell Berlin SoCs.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../arm/cpu-enable-method/marvell,berlin-smp       | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,berlin-smp

diff --git a/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,berlin-smp b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,berlin-smp
new file mode 100644
index 000000000000..cd236b727e2a
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/cpu-enable-method/marvell,berlin-smp
@@ -0,0 +1,41 @@
+========================================================
+Secondary CPU enable-method "marvell,berlin-smp" binding
+========================================================
+
+This document describes the "marvell,berlin-smp" method for enabling secondary
+CPUs. To apply to all CPUs, a single "marvell,berlin-smp" enable method should
+be defined in the "cpus" node.
+
+Enable method name:	"marvell,berlin-smp"
+Compatible machines:	"marvell,berlin2" and "marvell,berlin2q"
+Compatible CPUs:	"marvell,pj4b" and "arm,cortex-a9"
+Related properties:	(none)
+
+Note:
+This enable method needs valid nodes compatible with "arm,cortex-a9-scu" and
+"marvell,berlin-cpu-ctrl"[1].
+
+Example:
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		enable-method = "marvell,berlin-smp";
+
+		cpu@0 {
+			compatible = "marvell,pj4b";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <0>;
+		};
+
+		cpu@1 {
+			compatible = "marvell,pj4b";
+			device_type = "cpu";
+			next-level-cache = <&l2>;
+			reg = <1>;
+		};
+	};
+
+--
+[1] arm/marvell,berlin.txt
-- 
1.9.1

