Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaICTGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:06:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46330 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbaICTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:06:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] Documentation: devicetree: mfd: twl4030-power: Use the standard 'ti,system-power-controller' to mark power control
Date: Wed, 3 Sep 2014 14:06:47 -0500
Message-ID: <1409771208-21867-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409771208-21867-1-git-send-email-nm@ti.com>
References: <1409771208-21867-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ti,system-power-controller is more or less the standard way of
indicating that the PMIC is the system wide power controller and hence
may be used to switch off the system. Almost ALL TI PMIC drivers and
many Maxim PMIC drivers follow the same style.

So support 'ti,system-power-controller' in addition to the usual
'ti,use_poweroff' to indicate that the PMIC instance has control for
switching off the system.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../devicetree/bindings/mfd/twl4030-power.txt      |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/twl4030-power.txt b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
index b9ee7b9..e1dff57 100644
--- a/Documentation/devicetree/bindings/mfd/twl4030-power.txt
+++ b/Documentation/devicetree/bindings/mfd/twl4030-power.txt
@@ -23,8 +23,11 @@ down during off-idle. Note that this does not work on all boards
 depending on how the external oscillator is wired.
 
 Optional properties:
-- ti,use_poweroff: With this flag, the chip will initiates an ACTIVE-to-OFF or
-		   SLEEP-to-OFF transition when the system poweroffs.
+
+- ti,system-power-controller OR ti,use_poweroff: This indicates that
+  TWL4030 is the power supply master of the system. With this flag, the
+  chip will initiates an ACTIVE-to-OFF or SLEEP-to-OFF transition when
+  the system poweroffs.
 
 Example:
 &i2c1 {
-- 
1.7.9.5

