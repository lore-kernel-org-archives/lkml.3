Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaBQKEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:04:34 -0500
Received: from kolab.o2s.ch ([77.109.136.180]:59895 "EHLO kolab.o2s.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507AbaBQKEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:04:32 -0500
Subject: [PATCH v7 8/8] ARM: sunxi: Add documentation for driver for SD/MMC
 hosts found on Allwinner sunxi SoCs
To: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Emilio =?utf-8?b?TMOzcGV6?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-sunxi@googlegroups.com, Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Date: Mon, 17 Feb 2014 11:03:02 +0100
Message-ID: <20140217100302.15040.56273.stgit@pagira.o2s.ch>
In-Reply-To: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
References: <20140217095907.15040.81893.stgit@pagira.o2s.ch>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
---
 .../devicetree/bindings/mmc/sunxi-mmc.txt          |   32 ++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sunxi-mmc.txt

diff --git a/Documentation/devicetree/bindings/mmc/sunxi-mmc.txt b/Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
new file mode 100644
index 0000000..5ce8c5e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sunxi-mmc.txt
@@ -0,0 +1,32 @@
+* Allwinner sunxi MMC controller
+
+The highspeed MMC host controller on Allwinner SoCs provides an interface
+for MMC, SD and SDIO types of memory cards.
+
+Supported maximum speeds are the ones of the eMMC standard 4.5 as well
+as the speed of SD standard 3.0.
+Absolute maximum transfer rate is 200MB/s
+
+Required properties:
+- compatible: Should be "allwinner,<revision>-<chip>-mmc".
+  The supported chips include a10, a10s, 13, a20 and a31.
+- base registers are 0x1000 appart, so the base of mmc1
+  would be 0x01c0f000+0x1000=0x01c10000(see example)
+  and so on.
+- clocks requires the reference at the ahb clock gate
+  with the correct index (mmc0 -> 8, mmc1 -> 9, and so on)
+  as well as the reference to the correct mod0 clock.
+- interrupts requires the correct IRQ line
+  (mmc0 -> 32, mmc1 -> 33, and so on)
+
+Examples:
+
+mmc0: mmc@01c0f000 {
+	compatible = "allwinner,sun5i-a13-mmc";
+	reg = <0x01c0f000 0x1000>;
+	clocks = <&ahb_gates 8>, <&mmc0_clk>;
+	clock-names = "ahb", "mod";
+	interrupts = <0 32 4>;
+	bus-width = <4>;
+	status = "disabled";
+};

