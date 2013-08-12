Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3HLNHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:07:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14734 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab3HLNHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:07:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Aug 2013 06:05:20 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 4/6] Documentation: New DT parameters for tegra30-usb-phy
Date: Mon, 12 Aug 2013 16:06:52 +0300
Message-ID: <1376312814-18992-5-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
References: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the new device tree parameters for Tegra30 USB PHY.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 .../devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt    | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
index 4c8ade8..ba797d3 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
@@ -3,7 +3,7 @@ Tegra SOC USB PHY
 The device node for Tegra SOC USB PHY:
 
 Required properties :
- - compatible : Should be "nvidia,tegra20-usb-phy".
+ - compatible : Should be "nvidia,tegra<chip>-usb-phy".
  - reg : Defines the following set of registers, in the order listed:
    - The PHY's own register set.
      Always present.
@@ -24,17 +24,26 @@ Required properties :
 Required properties for phy_type == ulpi:
   - nvidia,phy-reset-gpio : The GPIO used to reset the PHY.
 
-Required PHY timing params for utmi phy:
+Required PHY timing params for utmi phy, for all chips:
   - nvidia,hssync-start-delay : Number of 480 Mhz clock cycles to wait before
     start of sync launches RxActive
   - nvidia,elastic-limit : Variable FIFO Depth of elastic input store
   - nvidia,idle-wait-delay : Number of 480 Mhz clock cycles of idle to wait
     before declare IDLE.
   - nvidia,term-range-adj : Range adjusment on terminations
-  - nvidia,xcvr-setup : HS driver output control
+  - Either one of the following for HS driver output control:
+    - nvidia,xcvr-setup : integer, uses the provided value.
+    - nvidia,xcvr-setup-use-fuses : boolean, indicates that the value is read
+      from the on-chip fuses
+    If both are provided, nvidia,xcvr-setup-use-fuses takes precedence.
   - nvidia,xcvr-lsfslew : LS falling slew rate control.
   - nvidia,xcvr-lsrslew :  LS rising slew rate control.
 
+Required PHY timing params for utmi phy, only on Tegra30 and above:
+  - nvidia,xcvr-hsslew : HS slew rate control.
+  - nvidia,hssquelch-level : HS squelch detector level.
+  - nvidia,hsdiscon-level : HS disconnect detector level.
+
 Optional properties:
   - nvidia,has-legacy-mode : boolean indicates whether this controller can
     operate in legacy mode (as APX 2500 / 2600). In legacy mode some
-- 
1.8.1.5

