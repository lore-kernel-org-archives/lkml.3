Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3FDJiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:38:25 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57496 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3FDJiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:38:21 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH v2 3/4] clocksource: dw_apb_timer_of: select DW_APB_TIMER
Date: Tue, 4 Jun 2013 11:38:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
References: <201306041136.09566.heiko@sntech.de>
In-Reply-To: <201306041136.09566.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041138.11447.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw_apb_timer_of is the driver part facing devicetree platforms and
calls into dw_apb_timer with the data gathered from the dt.

Currently the two platforms using the dw_apb_timer_of select both
the options for the core timer and the dt addon.

As dw_apb_timer_of always depends on dw_apb_timer let it select
DW_APB_TIMER itself without the need for every platform to do it.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/mach-picoxcell/Kconfig |    1 -
 arch/arm/mach-socfpga/Kconfig   |    1 -
 drivers/clocksource/Kconfig     |    1 +
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-picoxcell/Kconfig b/arch/arm/mach-picoxcell/Kconfig
index 13bae78..b1022f4 100644
--- a/arch/arm/mach-picoxcell/Kconfig
+++ b/arch/arm/mach-picoxcell/Kconfig
@@ -4,7 +4,6 @@ config ARCH_PICOXCELL
 	select ARM_PATCH_PHYS_VIRT
 	select ARM_VIC
 	select CPU_V6K
-	select DW_APB_TIMER
 	select DW_APB_TIMER_OF
 	select GENERIC_CLOCKEVENTS
 	select HAVE_TCM
diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
index 566e804..a279fb3 100644
--- a/arch/arm/mach-socfpga/Kconfig
+++ b/arch/arm/mach-socfpga/Kconfig
@@ -7,7 +7,6 @@ config ARCH_SOCFPGA
 	select CLKDEV_LOOKUP
 	select COMMON_CLK
 	select CPU_V7
-	select DW_APB_TIMER
 	select DW_APB_TIMER_OF
 	select GENERIC_CLOCKEVENTS
 	select GPIO_PL061 if GPIOLIB
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index f151c6c..48a0f2e 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -21,6 +21,7 @@ config DW_APB_TIMER
 
 config DW_APB_TIMER_OF
 	bool
+	select DW_APB_TIMER
 
 config ARMADA_370_XP_TIMER
 	bool
-- 
1.7.2.3

