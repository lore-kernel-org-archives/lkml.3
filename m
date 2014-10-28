Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaJ1L1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:27:22 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:13711 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaJ1L1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:20 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH 02/11] dt: bindings: add AXD Audio Processing IP binding document
Date: Tue, 28 Oct 2014 11:26:20 +0000
Message-ID: <1414495589-8579-3-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for AXD Audio Processing IP

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
Cc: <alsa-devel@alsa-project.org>
---
 Documentation/devicetree/bindings/axd.txt | 39 +++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/axd.txt

diff --git a/Documentation/devicetree/bindings/axd.txt b/Documentation/devicetree/bindings/axd.txt
new file mode 100644
index 000000000000..694fc40613fb
--- /dev/null
+++ b/Documentation/devicetree/bindings/axd.txt
@@ -0,0 +1,39 @@
+* AXD Audio Processing IP Binding *
+
+Required properties:
+- compatible: "img,axd"
+- clocks: phandle for the clock that drives AXD.
+- interrupts: the GIC interrupt where AXD is connected or software interrupt
+  1 (not recommended).
+
+Optional properties:
+- gic-irq: it takes two non-zero values, the first one is the host hwirq and
+           the second one is axd's. Host's hwirq should match the value in
+           interrupts.
+           If not using GIC, then axd will revert to using software interrupt 1
+           which is a fallback mechanism for systems without GIC. It is
+           recommended to use GIC whenever possible. Some systems will only work
+           with GIC so this property will not be optional then.
+- vpe: VPE number on which axd should start. Must be provided if axd is
+       running as a single VPE along Linux on the same core.
+       It can't be VPE0.
+       The VPE must be offlined by Linux before axd is loaded.
+- inbuf-size: size of shared input buffers area. by default it's 0x7800 bytes.
+- outbuf-size: size of shared output buffers area. by default it's 0x3c000 bytes.
+
+
+Example:
+
+		axdclk: axdclk@400M {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <400000000>;
+		};
+
+		axd: axd@07800000 {
+			compatible = "img,axd";
+			clocks = <&axdclk>;
+			interrupts = <36 IRQ_TYPE_EDGE_RISING>
+			gic-irq = <36 37>;
+			vpe = <1>;
+		};
-- 
2.1.0

