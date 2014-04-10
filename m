Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161114AbaDJNLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:11:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38956 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030861AbaDJNIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:08:09 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 4/5] Documentation: add the Marvell Berlin pinctrl documentation
Date: Thu, 10 Apr 2014 15:07:53 +0200
Message-Id: <1397135274-10764-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../bindings/pinctrl/marvell,berlin-pinctrl.txt    | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
new file mode 100644
index 000000000000..e21538a37734
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
@@ -0,0 +1,43 @@
+* Pinctrl driver for the Marvell Berlin SoCs
+
+The pins controlled by the Marvell Berlin controller are organized in groups.
+Configuration is done by group, so no actual pin information is needed.
+
+Required properties:
+- compatible:	"marvell-berlin2cd-pinctrl",
+		"marvell-berlin2-pinctrl",
+		"marvell-berlin2q-pinctrl"
+- reg: registers physical addresses and lengths of the pin controller.
+- reg-names: name of the register regions.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices.
+
+A pinctrl should contains subnodes representing the pinctrl pin group
+configurations, one per group. Each subnode has the group name and the muxing
+function used.
+
+Required subnode-properties:
+- berlin,group: a string describing the group's name.
+- berlin,function: the function used to mux the group.
+	0: function 0
+	1: function 1
+	...
+
+Example:
+
+pinctrl: pinctrl@0 {
+	compatible = "marvell,berlin2q-pinctrl";
+	reg = <0xea0000 0x08>, <0xfc0000 0x44>;
+	reg-names = "global_base", "sm_base";
+
+	uart0_pmux: uart0-pmux {
+		berlin,group = "GSM12";
+		berlin,function = <0>;
+	};
+}
+
+&uart0 {
+	pinctrl-0 = <&uart0_pmux>;
+	pinctrl-names = "default";
+};
-- 
1.8.3.2

