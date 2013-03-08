Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3CHMc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:32:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:51476 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3CHMc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:32:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,807,1355126400"; 
   d="scan'208";a="266787721"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH] gpio-lynxpoint: Add X86 dependency and io-port handling header.
Date: Fri,  8 Mar 2013 14:38:12 +0200
Message-Id: <1362746292-4385-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lynxpoint gpio driver uses X86 specific io-ports to control gpios

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/Kconfig          |    2 +-
 drivers/gpio/gpio-lynxpoint.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..704d01d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -303,7 +303,7 @@ config GPIO_GE_FPGA
 
 config GPIO_LYNXPOINT
 	bool "Intel Lynxpoint GPIO support"
-	depends on ACPI
+	depends on ACPI && X86
 	select IRQ_DOMAIN
 	help
 	  driver for GPIO functionality on Intel Lynxpoint PCH chipset
diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index 3472b05..86c17de 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -32,6 +32,7 @@
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/io.h>
 
 /* LynxPoint chipset has support for 94 gpio pins */
 
-- 
1.7.4.1

