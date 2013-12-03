Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3LCMuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:50:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:10686 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3LCMuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:50:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,817,1378882800"; 
   d="scan'208";a="443793774"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCHv4] ARM: tegra: add gpiod_lookup table for paz00
Date: Tue,  3 Dec 2013 14:49:58 +0200
Message-Id: <1386074998-17833-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to request the gpio descriptors in
rfkill_gpio driver regardless of the platform.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 arch/arm/mach-tegra/board-paz00.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

Changes since v3:
-----------------
Rebased on top of Alexandre's patch "gpio: better lookup method for
platform GPIOs".

diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 06f0240..e4dec9f 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/gpio/driver.h>
 #include <linux/rfkill-gpio.h>
 #include "board.h"
 
@@ -36,7 +37,17 @@ static struct platform_device wifi_rfkill_device = {
 	},
 };
 
+static struct gpiod_lookup_table wifi_gpio_lookup = {
+	.dev_id = "rfkill_gpio",
+	.table = {
+		GPIO_LOOKUP_IDX("tegra-gpio", 25, NULL, 0, 0),
+		GPIO_LOOKUP_IDX("tegra-gpio", 85, NULL, 1, 0),
+		{ },
+	},
+};
+
 void __init tegra_paz00_wifikill_init(void)
 {
+	gpiod_add_lookup_table(&wifi_gpio_lookup);
 	platform_device_register(&wifi_rfkill_device);
 }
-- 
1.8.4.4

