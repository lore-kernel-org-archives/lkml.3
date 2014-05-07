Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbaEGQTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:19:39 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:36580 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932324AbaEGQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:19:33 -0400
From: Feng Kan <fkan@apm.com>
To: dbaryshkov@gmail.com, catalin.marinas@arm.com, dwmw2@infradead.org,
        arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V6 3/5] Documentation: power: reset: Add documentation for generic SYSCON reboot driver
Date: Wed,  7 May 2014 09:18:02 -0700
Message-Id: <1399479484-2605-4-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1399479484-2605-1-git-send-email-fkan@apm.com>
References: <1399479484-2605-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for generic SYSCON reboot driver.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 .../bindings/power/reset/syscon-reboot.txt         |   27 ++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt

diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
new file mode 100644
index 0000000..79942a3
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
@@ -0,0 +1,27 @@
+Generic SYSCON mapped register reset driver
+
+This is a generic reset driver using syscon to map the reset register.
+The reset is generally performed with a write to the reset register
+defined by the register map pointed by syscon reference plus the offset
+with the mask defined in the reboot node.
+
+Required properties:
+- compatible: should contain "syscon-reboot"
+- regmap: this is phandle to the register map node 
+- offset: offset in the register map for the reboot register (in bytes)
+- mask: the reset value written to the reboot register (32 bit access)
+
+Default will be little endian mode, 32 bit access only.
+
+Examples:
+	regmapnode {
+		compatible = "apm,xgene-scu","syscon";
+		reg = <0xXXXXXXXX 0xXXXXXXXX>;
+	}
+
+	reboot {
+	   compatible = "syscon-reboot";
+	   regmap = <&regmapnode>;
+	   offset = <0x0>;
+	   mask = <0x1>;
+	};
-- 
1.7.6.1

