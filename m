Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaENVHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:07:39 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:61942 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaENVHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:07:38 -0400
Message-ID: <1400101656.9826.4.camel@x220>
Subject: [PATCH] arm: msm: remove board file for Nexus One (ie. mahimahi)
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 23:07:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2014 21:07:36.0300 (UTC) FILETIME=[87F9E2C0:01CF6FB8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1b802ff79f03 ("arm: msm: add board file for Nexus One (ie.
mahimahi)") added just board-mahimahi.c. It did not add
board-mahimahi.h, Makefile changes or Kconfig changes.

Four years have passed and this file is still dangling. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. But what to test here?

 arch/arm/mach-msm/board-mahimahi.c | 88 --------------------------------------
 1 file changed, 88 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-mahimahi.c

diff --git a/arch/arm/mach-msm/board-mahimahi.c b/arch/arm/mach-msm/board-mahimahi.c
deleted file mode 100644
index 7d9981cb400e..000000000000
--- a/arch/arm/mach-msm/board-mahimahi.c
+++ /dev/null
@@ -1,88 +0,0 @@
-/* linux/arch/arm/mach-msm/board-mahimahi.c
- *
- * Copyright (C) 2009 Google, Inc.
- * Copyright (C) 2009 HTC Corporation.
- * Author: Dima Zavin <dima@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/delay.h>
-#include <linux/gpio.h>
-#include <linux/init.h>
-#include <linux/input.h>
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/platform_device.h>
-
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/setup.h>
-
-#include <mach/hardware.h>
-
-#include "board-mahimahi.h"
-#include "devices.h"
-#include "proc_comm.h"
-#include "common.h"
-
-static uint debug_uart;
-
-module_param_named(debug_uart, debug_uart, uint, 0);
-
-static struct platform_device *devices[] __initdata = {
-#if !defined(CONFIG_MSM_SERIAL_DEBUGGER)
-	&msm_device_uart1,
-#endif
-	&msm_device_uart_dm1,
-	&msm_device_nand,
-};
-
-static void __init mahimahi_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static void __init mahimahi_fixup(struct tag *tags, char **cmdline,
-				  struct meminfo *mi)
-{
-	mi->nr_banks = 2;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].node = PHYS_TO_NID(PHYS_OFFSET);
-	mi->bank[0].size = (219*1024*1024);
-	mi->bank[1].start = MSM_HIGHMEM_BASE;
-	mi->bank[1].node = PHYS_TO_NID(MSM_HIGHMEM_BASE);
-	mi->bank[1].size = MSM_HIGHMEM_SIZE;
-}
-
-static void __init mahimahi_map_io(void)
-{
-	msm_map_common_io();
-	msm_clock_init();
-}
-
-static void __init mahimahi_init_late(void)
-{
-	smd_debugfs_init();
-}
-
-void msm_timer_init(void);
-
-MACHINE_START(MAHIMAHI, "mahimahi")
-	.atag_offset	= 0x100,
-	.fixup		= mahimahi_fixup,
-	.map_io		= mahimahi_map_io,
-	.init_irq	= msm_init_irq,
-	.init_machine	= mahimahi_init,
-	.init_late	= mahimahi_init_late,
-	.init_time	= msm_timer_init,
-MACHINE_END
-- 
1.9.0

