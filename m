Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3C2WBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 18:01:42 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:61225 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab3C2WBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 18:01:41 -0400
Message-ID: <1364594498.1345.100.camel@x61.thuisdomein>
Subject: [PATCH] ARM: msm: rename two Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 29 Mar 2013 23:01:38 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2013 22:01:38.0915 (UTC) FILETIME=[FCF26B30:01CE2CC8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 650e3f0d66ade2a614d854765dae3bbc9a87f58d ("ARM: msm: Consolidate
and move DEBUG_LL to DEBUG_LL choice") renamed the Kconfig symbols
MSM_DEBUG_UART1, MSM_DEBUG_UART2, and MSM_DEBUG_UART3 to
DEBUG_MSM_UART1, etc. It also added some references to
CONFIG_DEBUG_MSM_UART1, etc. It did not, however, rename the two
existing references to CONFIG_MSM_DEBUG_UART1 and
CONFIG_MSM_DEBUG_UART3. Do so now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Would there actually be a readable way to write this commit
explanation? This explanation even confuses me! I guess it's just a
confusing matter.

 arch/arm/mach-msm/board-trout-gpio.c | 2 +-
 arch/arm/mach-msm/board-trout.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
index 87e1d01..a92efc8 100644
--- a/arch/arm/mach-msm/board-trout-gpio.c
+++ b/arch/arm/mach-msm/board-trout-gpio.c
@@ -94,7 +94,7 @@ static int trout_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	}
 
 static struct msm_gpio_chip msm_gpio_banks[] = {
-#if defined(CONFIG_MSM_DEBUG_UART1)
+#if defined(CONFIG_DEBUG_MSM_UART1)
 	/* H2W pins <-> UART1 */
 	TROUT_GPIO_BANK("MISC2", 0x00,   TROUT_GPIO_MISC2_BASE, 0x40),
 #else
diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index 919bfa3..02e0dd7 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -89,7 +89,7 @@ static void __init trout_map_io(void)
 	msm_map_common_io();
 	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
 
-#ifdef CONFIG_MSM_DEBUG_UART3
+#ifdef CONFIG_DEBUG_MSM_UART3
 	/* route UART3 to the "H2W" extended usb connector */
 	writeb(0x80, TROUT_CPLD_BASE + 0x00);
 #endif
-- 
1.7.11.7

