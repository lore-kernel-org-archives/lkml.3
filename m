Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbaIOXwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:52:19 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:40280 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbaIOXvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:51:39 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>, Jonas Gorski <jogo@openwrt.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/24] MIPS: sead3: Remove sead3-serial.c
Date: Mon, 15 Sep 2014 16:51:12 -0700
Message-Id: <1410825087-5497-10-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a duplicate of sead3-platform.c and is not even compiled.
Remove it before we start fixing up IRQ assignments.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/mti-sead3/sead3-serial.c | 45 --------------------------------------
 1 file changed, 45 deletions(-)
 delete mode 100644 arch/mips/mti-sead3/sead3-serial.c

diff --git a/arch/mips/mti-sead3/sead3-serial.c b/arch/mips/mti-sead3/sead3-serial.c
deleted file mode 100644
index bc52705..0000000
--- a/arch/mips/mti-sead3/sead3-serial.c
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2012 MIPS Technologies, Inc.  All rights reserved.
- */
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/serial_8250.h>
-
-#define UART(base, int)							\
-{									\
-	.mapbase	= base,						\
-	.irq		= int,						\
-	.uartclk	= 14745600,					\
-	.iotype		= UPIO_MEM32,					\
-	.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_IOREMAP, \
-	.regshift	= 2,						\
-}
-
-static struct plat_serial8250_port uart8250_data[] = {
-	UART(0x1f000900, MIPS_CPU_IRQ_BASE + 4),   /* ttyS0 = USB   */
-	UART(0x1f000800, MIPS_CPU_IRQ_BASE + 4),   /* ttyS1 = RS232 */
-	{ },
-};
-
-static struct platform_device uart8250_device = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= uart8250_data,
-	},
-};
-
-static int __init uart8250_init(void)
-{
-	return platform_device_register(&uart8250_device);
-}
-
-module_init(uart8250_init);
-
-MODULE_AUTHOR("Chris Dearman <chris@mips.com>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("8250 UART probe driver for the SEAD-3 platform");
-- 
2.1.0.rc2.206.gedb03e5

