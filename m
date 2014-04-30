Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028AbaD3PQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:16:50 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44109 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933831AbaD3PQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:16:42 -0400
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v5 1/3] ARM: sunxi: Add documentation for sunxi consumer infrared devices
Date: Wed, 30 Apr 2014 21:16:48 +0600
Message-Id: <1398871010-30681-2-git-send-email-bay@hackerdom.ru>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
References: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds documentation for Device-Tree bindings for sunxi IR
controller.

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
---
 .../devicetree/bindings/media/sunxi-ir.txt         | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt

diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
new file mode 100644
index 0000000..d502cf4
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
@@ -0,0 +1,23 @@
+Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
+
+Required properties:
+- compatible	    : should be "allwinner,sun7i-a20-ir";
+- clocks	    : list of clock specifiers, corresponding to
+		      entries in clock-names property;
+- clock-names	    : should contain "apb0_ir0" and "ir0" entries;
+- interrupts	    : should contain IR IRQ number;
+- reg		    : should contain IO map address for IR.
+
+Optional properties:
+- linux,rc-map-name : Remote control map name.
+
+Example:
+
+ir0: ir@01c21800 {
+       	compatible = "allwinner,sun7i-a20-ir";
+       	clocks = <&apb0_gates 6>, <&ir0_clk>;
+       	clock-names = "apb0_ir0", "ir0";
+       	interrupts = <0 5 1>;
+       	reg = <0x01C21800 0x40>;
+       	linux,rc-map-name = "rc-rc6-mce";
+};
-- 
1.9.2

