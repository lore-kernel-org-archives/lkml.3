Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaIQMec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:34:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58135 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaIQMe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:34:28 -0400
From: Nishanth Menon <nm@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: Sebastian Reichel <sre@kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/2] mfd: twl4030-power: use 'ti,system-power-controller' as alternative way to support system power off
Date: Wed, 17 Sep 2014 07:34:12 -0500
Message-ID: <1410957252-764-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410957252-764-1-git-send-email-nm@ti.com>
References: <1410957252-764-1-git-send-email-nm@ti.com>
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
Acked-by: Tony Lindgren <tony@atomide.com>
---

V2: no change, picked up Tony's ack.
V1: https://patchwork.kernel.org/patch/4836371/
 drivers/mfd/twl4030-power.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 3bc969a..1c129ba 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -627,6 +627,9 @@ static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
 	if (pdata && pdata->use_poweroff)
 		return true;
 
+	if (of_property_read_bool(node, "ti,system-power-controller"))
+		return true;
+
 	if (of_property_read_bool(node, "ti,use_poweroff"))
 		return true;
 
-- 
1.7.9.5

