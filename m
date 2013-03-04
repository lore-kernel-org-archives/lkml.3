Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3CDULX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 15:11:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10203 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3CDULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 15:11:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 12:11:14 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>, Anton Vorontsov <cbou@mail.ru>
CC: David Woodhouse <dwmw2@infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v1 1/3] power_supply: Define Binding for power-supplies
Date: Mon, 4 Mar 2013 15:11:56 -0500
Message-ID: <1362427918-14504-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362427918-14504-1-git-send-email-rklein@nvidia.com>
References: <1362427918-14504-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property is meant to be used in device nodes which represent
power_supply devices that wish to provide a list of supplies which
provide them power, such as a battery listing its chargers.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
v1:
 - changed from RFC v2 -> patch v1
 - made poropery plural as it can be a list
 - update example with plural & changed once charger address

v2 (RFC):
 - changed property to "power-supply" which should be contained in the
   battery rather than the charger. Also updated example to match

 .../bindings/power_supply/power_supply.txt         |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/power_supply.txt

diff --git a/Documentation/devicetree/bindings/power_supply/power_supply.txt b/Documentation/devicetree/bindings/power_supply/power_supply.txt
new file mode 100644
index 0000000..8391bfa
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/power_supply.txt
@@ -0,0 +1,23 @@
+Power Supply Core Support
+
+Optional Properties:
+ - power-supplies : This property is added to a supply in order to list the
+   devices which supply it power, referenced by their phandles.
+
+Example:
+
+	usb-charger: power@e {
+		compatible = "some,usb-charger";
+		...
+	};
+
+	ac-charger: power@c {
+		compatible = "some,ac-charger";
+		...
+	};
+
+	battery@b {
+		compatible = "some,battery";
+		...
+		power-supplies = <&usb-charger>, <&ac-charger>;
+	};
-- 
1.7.9.5

