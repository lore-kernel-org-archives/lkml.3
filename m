Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaANAU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:20:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33840 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbaANAUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:20:53 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCHv4 7/7] hwspinlock/omap: enable build for AM33xx, AM43xx & DRA7xx
Date: Mon, 13 Jan 2014 18:19:24 -0600
Message-ID: <1389658764-39199-8-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389658764-39199-1-git-send-email-s-anna@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HwSpinlocks are supported on AM33xx, AM43xx and DRA7xx SoC
device families as well. The IPs are identical to that of
OMAP4/OMAP5, except for the number of locks.

Add a depends on to the above family of SoCs to enable the
build support for OMAP hwspinlock driver for any of the above
SoC configs.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/hwspinlock/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
index 70637d2..3612cb5 100644
--- a/drivers/hwspinlock/Kconfig
+++ b/drivers/hwspinlock/Kconfig
@@ -10,7 +10,7 @@ menu "Hardware Spinlock drivers"
 
 config HWSPINLOCK_OMAP
 	tristate "OMAP Hardware Spinlock device"
-	depends on ARCH_OMAP4 || SOC_OMAP5
+	depends on ARCH_OMAP4 || SOC_OMAP5 || SOC_DRA7XX || SOC_AM33XX || SOC_AM43XX
 	select HWSPINLOCK
 	help
 	  Say y here to support the OMAP Hardware Spinlock device (firstly
-- 
1.8.4.3

