Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbbAVJfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:35:23 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:45322 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbAVJej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:34:39 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Olof Johansson <olof@lixom.net>, Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v3/resend 3/4] drivers: bus: Add Simple Power-Managed Bus DT Bindings
Date: Thu, 22 Jan 2015 10:34:12 +0100
Message-Id: <1421919253-4784-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421919253-4784-1-git-send-email-geert+renesas@glider.be>
References: <1421919253-4784-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
---
v3:
  - Add Tested-by,
  - Document required properties inherited from "simple-bus",
  - Document required "reg" property for "renesas,bsc",
  - Move "ranges" before "reg" in the example,

v2:
  - New.
---
 .../devicetree/bindings/bus/simple-pm-bus.txt      | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/simple-pm-bus.txt

diff --git a/Documentation/devicetree/bindings/bus/simple-pm-bus.txt b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
new file mode 100644
index 0000000000000000..d03abf7fd8e3997a
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
@@ -0,0 +1,52 @@
+Simple Power-Managed Bus
+========================
+
+A Simple Power-Managed Bus is a transparent bus that doesn't need a real
+driver, as it's typically initialized by the boot loader.
+
+However, its bus controller is part of a PM domain, or under the control of a
+functional clock.  Hence, the bus controller's PM domain and/or clock must be
+enabled for child devices connected to the bus (either on-SoC or externally)
+to function.
+
+
+Generic compatible values and properties
+----------------------------------------
+
+Required properties:
+  - compatible: Must be at least one of the vendor-specific compatible values
+		from a vendor-specific section below, and "simple-bus" as a
+		fallback.
+  - #address-cells, #size-cells, ranges: Must describe the mapping between
+		parent address and child address spaces.
+
+Optional platform-specific properties for clock or PM domain control (at least
+one of them is required):
+  - clocks: Must contain a reference to the functional clock(s),
+  - power-domains: Must contain a reference to the PM domain.
+
+
+Vendor-specific compatible values and properties
+------------------------------------------------
+
+Renesas Bus State Controller (BSC):
+  - compatible: Must be an SoC-specific value, and "renesas,bsc" as a fallback.
+                SoC-specific values can be:
+		"renesas,bsc-r8a73a4" for R-Mobile APE6 (r8a73a4)
+		"renesas,bsc-sh73a0" for SH-Mobile AG5 (sh73a0)
+  - reg: Must contain the base address and length to access the bus controller.
+  - interrupts: Must contain a reference to the BSC interrupt, if available.
+
+
+Example:
+
+	bsc: bus@fec10000 {
+		compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges = <0 0 0x20000000>;
+		reg = <0xfec10000 0x400>;
+		interrupts = <0 39 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&zb_clk>;
+		power-domains = <&pd_a4s>;
+	};
-- 
1.9.1

