Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaHRRIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:08:35 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36617 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaHRRI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:08:29 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
        linux-usb@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 1/9] of: Add NVIDIA Tegra XUSB mailbox binding
Date: Mon, 18 Aug 2014 10:08:17 -0700
Message-Id: <1408381705-3623-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree bindings for the Tegra XUSB mailbox which will be used
for communication between the Tegra xHCI controller's firmware and the
host processor.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - Updated to use common mailbox bindings.
---
 .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt | 30 ++++++++++++++++++++++
 include/dt-bindings/mailbox/tegra-xusb-mailbox.h   |  7 +++++
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
 create mode 100644 include/dt-bindings/mailbox/tegra-xusb-mailbox.h

diff --git a/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt b/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
new file mode 100644
index 0000000..c46219b
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
@@ -0,0 +1,30 @@
+NVIDIA Tegra XUSB mailbox
+=========================
+
+The Tegra XUSB mailbox is used by the Tegra xHCI controller's firmware to
+communicate requests to the host and PHY drivers.
+
+Required properties:
+--------------------
+ - compatible: Should be "nvidia,tegra124-xusb-mbox".
+ - reg: Address and length of the XUSB FPCI registers.
+ - interrupts: XUSB mailbox interrupt.
+ - #mbox-cells: Should be 1.  The specifier is the index of the mailbox to
+   reference.  See <dt-bindings/mailbox/tegra-xusb-mailbox.h> for the list
+   of valid values.
+
+Example:
+--------
+	mbox: mailbox@0,70098000 {
+		compatible = "nvidia,tegra124-xusb-mbox";
+		reg = <0x0 0x70098000 0x0 0x1000>;
+		interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
+
+		#mbox-cells = <1>;
+	};
+
+	usb@0,70090000 {
+		...
+		mboxes = <&mbox TEGRA_XUSB_MBOX_CHAN_HOST>;
+		...
+	};
diff --git a/include/dt-bindings/mailbox/tegra-xusb-mailbox.h b/include/dt-bindings/mailbox/tegra-xusb-mailbox.h
new file mode 100644
index 0000000..59de6b0
--- /dev/null
+++ b/include/dt-bindings/mailbox/tegra-xusb-mailbox.h
@@ -0,0 +1,7 @@
+#ifndef _DT_BINDINGS_TEGRA_XUSB_MAILBOX_H
+#define _DT_BINDINGS_TEGRA_XUSB_MAILBOX_H
+
+#define TEGRA_XUSB_MBOX_CHAN_HOST	0
+#define TEGRA_XUSB_MBOX_CHAN_PHY	1
+
+#endif /* _DT_BINDINGS_TEGRA_XUSB_MAILBOX_H */
-- 
2.1.0.rc2.206.gedb03e5

