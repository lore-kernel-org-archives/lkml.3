Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaJ0QXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:23:54 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41259 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaJ0QXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:23:48 -0400
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: devicetree@vger.kernel.org, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh@kernel.org,
        mark.rutland@arm.com, johan@kernel.org, linux-pm@vger.kernel.org,
        linux@roeck-us.net, lee.jones@linaro.org, balbi@ti.com,
        robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, gnurou@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: [PATCH v1 02/10] dt-bindings: Document the standard property "system-power-controller"
Date: Mon, 27 Oct 2014 16:26:47 +0000
Message-Id: <1414427215-14380-2-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simply renames the previous documentation to something more generic and adds
updates according to last changes.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 .../devicetree/bindings/power/power-controller.txt     | 18 ++++++++++++++++++
 Documentation/devicetree/bindings/power/poweroff.txt   | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power-controller.txt
 delete mode 100644 Documentation/devicetree/bindings/power/poweroff.txt

diff --git a/Documentation/devicetree/bindings/power/power-controller.txt b/Documentation/devicetree/bindings/power/power-controller.txt
new file mode 100644
index 0000000..e0a1abe
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/power-controller.txt
@@ -0,0 +1,18 @@
+* Generic system power control capability
+
+Power-management integrated circuits or miscellaneous harware components are
+sometimes able to control the system power. The device driver associated to these
+components might needs to define this capability, which tells to the kernel
+how to switch off the system. The corresponding driver must have the standard
+property "system-power-controller" in its device node. This property marks the device as
+able to controller the system-power. In order to test if this property is found
+programmatically, use the helper function "of_is_system_power_controller" from
+of.h .
+
+Example:
+
+act8846: act8846@5 {
+	 compatible = "active-semi,act8846";
+	 status = "okay";
+	 system-power-controller;
+}
diff --git a/Documentation/devicetree/bindings/power/poweroff.txt b/Documentation/devicetree/bindings/power/poweroff.txt
deleted file mode 100644
index 845868b..0000000
--- a/Documentation/devicetree/bindings/power/poweroff.txt
+++ /dev/null
@@ -1,18 +0,0 @@
-* Generic Poweroff capability
-
-Power-management integrated circuits or miscellaneous harware components are
-sometimes able to control the system power. The device driver associated to these
-components might needs to define poweroff capability, which tells to the kernel
-how to switch off the system. The corresponding driver must have the standard
-property "poweroff-source" in its device node. This property marks the device as
-able to shutdown the system. In order to test if this property is found
-programmatically, use the helper function "of_system_has_poweroff_source" from
-of.h .
-
-Example:
-
-act8846: act8846@5 {
-	 compatible = "active-semi,act8846";
-	 status = "okay";
-	 poweroff-source;
-}
-- 
1.9.1

