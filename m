Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaEOLaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:30:15 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:55194 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaEOLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:30:13 -0400
Message-ID: <1400153411.9119.7.camel@x220>
Subject: [PATCH] ARM: msm: rename two Kconfig macros
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 13:30:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 11:30:11.0646 (UTC) FILETIME=[0890F5E0:01CF7031]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 650e3f0d66ad ("ARM: msm: Consolidate and move DEBUG_LL to
DEBUG_LL choice") appears to have renamed
    MSM_DEBUG_UART1
    MSM_DEBUG_UART2
    MSM_DEBUG_UART3

to
    DEBUG_MSM_UART1
    DEBUG_MSM_UART2
    DEBUG_MSM_UART3

It missed a check for CONFIG_MSM_DEBUG_UART1 and a check for
CONFIG_MSM_DEBUG_UART3 in the code. Rename these too.

Fixes: 650e3f0d66ad ("ARM: msm: Consolidate and move DEBUG_LL to DEBUG_LL choice")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

These few lines were, well, broken since v3.3. Did no one notice?

 arch/arm/mach-msm/board-trout-gpio.c | 2 +-
 arch/arm/mach-msm/board-trout.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
index 87e1d01edecc..a92efc83cdb7 100644
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
index 015d544aa017..27121b391275 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -90,7 +90,7 @@ static void __init trout_map_io(void)
 	msm_map_common_io();
 	iotable_init(trout_io_desc, ARRAY_SIZE(trout_io_desc));
 
-#ifdef CONFIG_MSM_DEBUG_UART3
+#ifdef CONFIG_DEBUG_MSM_UART3
 	/* route UART3 to the "H2W" extended usb connector */
 	writeb(0x80, TROUT_CPLD_BASE + 0x00);
 #endif
-- 
1.9.0

