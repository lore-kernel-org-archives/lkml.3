Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbbAIAAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:00:16 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50456 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbbAIAAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:00:01 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH v3 2/3] doc: dt: Add documentation for e3x0-button bindings.
Date: Fri,  9 Jan 2015 00:59:30 +0100
Message-Id: <1420761571-22903-3-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
References: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
---
 .../devicetree/bindings/input/e3x0-button.txt      | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/e3x0-button.txt b/Documentation/devicetree/bindings/input/e3x0-button.txt
new file mode 100644
index 0000000..751665e
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/e3x0-button.txt
@@ -0,0 +1,25 @@
+National Instruments Ettus Research USRP E3x0 button driver
+
+This module is part of the NI Ettus Research USRP E3x0 SDR.
+
+This module provides a simple power button event via two interrupts.
+
+Required properties:
+- compatible: should be one of the following
+  - "ettus,e3x0-button": For devices such as the NI Ettus Research USRP E3x0
+- interrupt-parent:
+  - a phandle to the interrupt controller that it is attached to.
+- interrupts: should be one of the following
+  - <0 30 1>, <0 31 1>: For devices such as the NI Ettus Research USRP E3x0
+- interrupt-names: should be one of the following
+  - "press", "release": For devices such as the NI Ettus Research USRP E3x0
+
+Note: Interrupt numbers might vary depending on the FPGA configuration.
+
+Example:
+	button {
+		compatible = "ettus,e3x0-button";
+		interrupt-parent = <&intc>;
+		interrupts = <0 30 1>, <0 31 1>;
+		interrupt-names = "press", "release";
+	}
-- 
1.9.3

