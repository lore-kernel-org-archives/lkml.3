Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaIQUD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:03:59 -0400
Received: from mail-ie0-f201.google.com ([209.85.223.201]:63665 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbaIQT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:59:35 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v4 1/9] of: Add NVIDIA Tegra XUSB mailbox binding
Date: Wed, 17 Sep 2014 12:59:22 -0700
Message-Id: <1410983970-7043-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410983970-7043-1-git-send-email-abrestic@chromium.org>
References: <1410983970-7043-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree bindings for the Tegra XUSB mailbox which will be used
for communication between the Tegra xHCI controller's firmware and the
host processor.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
No changes from v3.
Changes from v2:
 - Dropped channel specifier.
 - Added pointer to mailbox documentation.
Changes from v1:
 - Updated to use common mailbox bindings.
---
 .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt b/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
new file mode 100644
index 0000000..b35ea6e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
@@ -0,0 +1,32 @@
+NVIDIA Tegra XUSB mailbox
+=========================
+
+The Tegra XUSB mailbox is used by the Tegra xHCI controller's firmware to
+communicate requests to the host and PHY drivers.
+
+Refer to ./mailbox.txt for generic information about mailbox device-tree
+bindings.
+
+Required properties:
+--------------------
+ - compatible: Should be "nvidia,tegra124-xusb-mbox".
+ - reg: Address and length of the XUSB FPCI registers.
+ - interrupts: XUSB mailbox interrupt.
+ - #mbox-cells: Should be 0.  There is only one physical channel.
+
+Example:
+--------
+	xusb_mbox: mailbox@0,70098000 {
+		compatible = "nvidia,tegra124-xusb-mbox";
+		reg = <0x0 0x70098000 0x0 0x1000>;
+		interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
+
+		#mbox-cells = <0>;
+	};
+
+	usb@0,70090000 {
+		...
+		mboxes = <&xusb_mbox>;
+		mbox-names = "xusb";
+		...
+	};
-- 
2.1.0.rc2.206.gedb03e5

