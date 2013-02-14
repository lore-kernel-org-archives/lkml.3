Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041Ab3BNW1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:27:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030267Ab3BNW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:27:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/9] ARM: sa1100/assabet: include platform_device.h directly
Date: Thu, 14 Feb 2013 23:26:50 +0100
Message-Id: <1360880818-4071454-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NqEUdCyeO/LaZ7dXVZRDHbvjTkMZcsVbx1RxV849Rc8
 WB1Qpj/A6DAUQLcTo8Kxn4VkEupRkbzWl970zLW3/VuTk10r5G
 Xfyci5LXuNxnggRfqjyJ3q52RRXDGdwJKkP1PFPQjnZOR4PeoO
 AsTwYx/QjveU8etPp8JSMpgyfpjrJv2TR2OLiliRHA8Q8TOc3I
 mGYsnigzm3sa/QUb/kEYigKb2GCkkkFHRS2ctgLA600WF1Z7Gq
 LV+cQLAtmaA+6EKViTwg9gV2Kj4A/JiZgDZn+aWEuyKpSkpmwR
 kcCl+pfz8OOM21XSrPC+j/NyIIsyKJXVUj0UOQ3ra1FvM0wEUw
 8cnMeF0Lsa1bDnr7IPpueSNrkG4PvsUMiqel4Jky6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch "16559ae kgdb: remove #include <linux/serial_8250.h> from kgdb.h
caused assabet_defconfig to fail, since assabet.c did not
itself include linux/platform_device.h, although it needs it:

In file included from include/linux/mfd/ucb1x00.h:13:0,
                 from arch/arm/mach-sa1100/assabet.c:19:
include/linux/mfd/mcp.h:22:16: error: field 'attached_device' has incomplete type
include/linux/mfd/mcp.h:48:23: error: field 'drv' has incomplete type
In file included from arch/arm/mach-sa1100/assabet.c:19:0:
include/linux/mfd/ucb1x00.h:137:16: error: field 'dev' has incomplete type
arch/arm/mach-sa1100/assabet.c: In function 'assabet_init':
arch/arm/mach-sa1100/assabet.c:343:3: error: implicit declaration of function 'platform_device_register_simple' [-Wimplicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-sa1100/assabet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index b38d252..e838ba2 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -16,6 +16,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_data/sa11x0-serial.h>
 #include <linux/serial_core.h>
+#include <linux/platform_device.h>
 #include <linux/mfd/ucb1x00.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
-- 
1.8.1.2

