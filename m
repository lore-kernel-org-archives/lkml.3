Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3KZKHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:07:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:21243 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3KZKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:06:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,773,1378882800"; 
   d="scan'208";a="415000264"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
Date: Tue, 26 Nov 2013 12:05:45 +0200
Message-Id: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

This makes it possible to request the gpio descriptors in
rfkill_gpio driver regardless of the platform.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/board-paz00.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 06f024070dab..a309795da665 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/gpio/driver.h>
 #include <linux/rfkill-gpio.h>
 #include "board.h"
 
@@ -36,7 +37,13 @@ static struct platform_device wifi_rfkill_device = {
 	},
 };
 
+static struct gpiod_lookup wifi_gpio_lookup[] = {
+	GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio", NULL, 0, 0),
+	GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio", NULL, 1, 0),
+};
+
 void __init tegra_paz00_wifikill_init(void)
 {
+	gpiod_add_table(wifi_gpio_lookup, ARRAY_SIZE(wifi_gpio_lookup));
 	platform_device_register(&wifi_rfkill_device);
 }
-- 
1.8.4.3

