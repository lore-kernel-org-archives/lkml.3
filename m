Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3BOXge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:36:34 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13338 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3BOXgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:36:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Feb 2013 15:32:22 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [RFC 1/3] power_supply: Define Binding for supplied-nodes
Date: Fri, 15 Feb 2013 18:36:54 -0500
Message-ID: <1360971416-30717-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
References: <1360971416-30717-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This property is meant to be used in device nodes which represent
power_supply devices that wish to provide a list of supplies to
which they provide power. A common case is a AC Charger with
the batteries it powers.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 .../bindings/power_supply/power_supply.txt         |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/power_supply.txt

diff --git a/Documentation/devicetree/bindings/power_supply/power_supply.txt b/Documentation/devicetree/bindings/power_supply/power_supply.txt
new file mode 100644
index 0000000..1c58d4ff
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/power_supply.txt
@@ -0,0 +1,17 @@
+Power Supply Core Support
+
+Optional Properties:
+ - power-supply,supplied-nodes : This property is added to a supply
+   in order to specify the list of supplicant devices directly by their
+   phandles.
+
+Example:
+
+	charger@e {
+		compatible = "some,charger";
+		...
+
+		power-supply,supplied-nodes = <&some_battery>,
+					      <&another_battery>;
+		...
+	};
-- 
1.7.9.5

