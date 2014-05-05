Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaEEF2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:28:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35596 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754578AbaEEF1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:27:37 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] Documentation: add the Marvell Berlin pinctrl documentation
Date: Mon,  5 May 2014 07:27:28 +0200
Message-Id: <1399267649-20218-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the documentation related to the Berlin pin-controller driver and
explain how to configure this group based controller.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 .../bindings/pinctrl/marvell,berlin-pinctrl.txt    | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
new file mode 100644
index 000000000000..4ca92ab2c1de
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/marvell,berlin-pinctrl.txt
@@ -0,0 +1,45 @@
+* Pin-controller driver for the Marvell Berlin SoCs
+
+The pins controlled by the Marvell Berlin controller are organized in groups.
+Configuration is done by group, so no actual pin information is needed.
+
+Be aware the Marvell Berlin datasheets use the keyword 'mode' for what is called
+a 'function' in the pin-controller subsystem.
+
+Required properties:
+- compatible: should be one of:
+	"marvell,berlin2-soc-pinctrl",
+	"marvell,berlin2-sysmgr-pinctrl",
+	"marvell,berlin2cd-soc-pinctrl",
+	"marvell,berlin2cd-sysmgr-pinctrl",
+	"marvell,berlin2q-soc-pinctrl",
+	"marvell,berlin2q-sysmgr-pinctrl"
+- reg: registers physical address and length of the pin controller.
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pin-controller bindings used by client devices.
+
+A pin-controller node should contain subnodes representing the pin group
+configurations, one per function. Each subnode has the group name and the muxing
+function used.
+
+Required subnode-properties:
+- marvell,groups: a list of strings describing the group names.
+- marvell,function: a string describing the function used to mux the groups.
+
+Example:
+
+sm_pinctrl: pin-controller@0 {
+	compatible = "marvell,berlin2q-sysmgr-pinctrl";
+	reg = <0xfc0000 0x44>;
+
+	uart0_pmux: uart0-pmux {
+		marvell,groups = "GSM12", "GSM13";
+		marvell,function = "uart0";
+	};
+}
+
+&uart0 {
+	pinctrl-0 = <&uart0_pmux>;
+	pinctrl-names = "default";
+};
-- 
1.8.3.2

