Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaA3AIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:08:48 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:57509 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540AbaA3AIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:08:46 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V5 5/5] Documentation: power: reset: Add documentation for generic SYSCON reboot driver
Date: Wed, 29 Jan 2014 16:03:18 -0800
Message-Id: <1391040198-14185-6-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1391040198-14185-1-git-send-email-fkan@apm.com>
References: <1391040198-14185-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for generic SYSCON reboot driver.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 .../bindings/power/reset/syscon-reboot.txt         |   23 ++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/reset/syscon-reboot.txt

diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
new file mode 100644
index 0000000..963f3c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
@@ -0,0 +1,23 @@
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
+
+	reboot {
+	   compatible = "syscon-reboot";
+	   regmap = <&regmapnode>;
+	   offset = <0x0>;
+	   mask = <0x1>;
+	};
-- 
1.7.6.1

