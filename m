Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3CNWNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:13:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3CNWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:12:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@vger.kernel.org
Cc: patches@linaro.org, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6] ARM: l7200: remove zombie file
Date: Thu, 14 Mar 2013 23:12:06 +0100
Message-Id: <1363299128-8192-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363299128-8192-1-git-send-email-arnd@arndb.de>
References: <1363299128-8192-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AuK7GhgCBOer8cJUQMHrujl0TaWdkY6D3pRqk2Wvh12
 aW1nKjwWPNyShycHRRi8NLyC+9tiorRO/qH+aG6tMBWBKuaEzE
 i66uiyoqtxGeCGjSHW+skJ5yfJeGNuqWzz8IYpSV1LTN7AGhmz
 trV475uwk6RpH0tjPUCQS68fVX6aBHpxOv/77vt1xKU0A8kdD6
 yAyD2DA0n9u5p+/5YhpXnRmNaWlipOjvwScEGMbheAlO1jwor6
 /M3E1elm2MQNwHXUKiS5joBYWFr+N/ls1cpjDKfBVlDSDffUtf
 qva/wI12i4jRQnAoO3/cX7v49G0UOZOp8uahhVKf2ylkfnfcGG
 T7crttrtAHSP7oUyX4ZZu5/w3WOH5wOH7Somf+Uud
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The l7200 platform was removed in 2.6.35, but one file came
back due to a failed merge conflict resolution. Let's kill
it again.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-l7200/include/mach/debug-macro.S | 38 --------------------------
 1 file changed, 38 deletions(-)
 delete mode 100644 arch/arm/mach-l7200/include/mach/debug-macro.S

diff --git a/arch/arm/mach-l7200/include/mach/debug-macro.S b/arch/arm/mach-l7200/include/mach/debug-macro.S
deleted file mode 100644
index 0b4e760..0000000
--- a/arch/arm/mach-l7200/include/mach/debug-macro.S
+++ /dev/null
@@ -1,38 +0,0 @@
-/* arch/arm/mach-l7200/include/mach/debug-macro.S
- *
- * Debugging macro include header
- *
- *  Copyright (C) 1994-1999 Russell King
- *  Moved from linux/arch/arm/kernel/debug.S by Ben Dooks
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-
-		.equ	io_virt, IO_BASE
-		.equ	io_phys, IO_START
-
-		.macro	addruart, rp, rv, tmp
-		mov	\rp, #0x00044000	@ UART1
-@		mov	\rp, #0x00045000	@ UART2
-		add	\rv, \rp, #io_virt	@ virtual address
-		add	\rp, \rp, #io_phys	@ physical base address
-		.endm
-
-		.macro	senduart,rd,rx
-		str	\rd, [\rx, #0x0]	@ UARTDR
-		.endm
-
-		.macro	waituart,rd,rx
-1001:		ldr	\rd, [\rx, #0x18]	@ UARTFLG
-		tst	\rd, #1 << 5		@ UARTFLGUTXFF - 1 when full
-		bne	1001b
-		.endm
-
-		.macro	busyuart,rd,rx
-1001:		ldr	\rd, [\rx, #0x18]	@ UARTFLG
-		tst	\rd, #1 << 3		@ UARTFLGUBUSY - 1 when busy
-		bne	1001b
-		.endm
-- 
1.8.1.2

