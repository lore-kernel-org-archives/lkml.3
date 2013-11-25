Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3KYI4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:56:10 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36424 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3KYIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 14/24] avr32: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:24 +0100
Message-Id: <1385369734-24893-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The extra definition for BITS_PER_LONG is also indirectly provided
by <asm-generic/types.h>, via <asm-generic/int-ll64.h> and
<asm/bitsperlong.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/include/asm/Kbuild  |    1 +
 arch/avr32/include/asm/types.h |   19 -------------------
 2 files changed, 1 insertion(+), 19 deletions(-)
 delete mode 100644 arch/avr32/include/asm/types.h

diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 658001b52400..129f4ff68066 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -17,4 +17,5 @@ generic-y       += scatterlist.h
 generic-y       += sections.h
 generic-y       += topology.h
 generic-y	+= trace_clock.h
+generic-y	+= types.h
 generic-y       += xor.h
diff --git a/arch/avr32/include/asm/types.h b/arch/avr32/include/asm/types.h
deleted file mode 100644
index 59324058069c..000000000000
--- a/arch/avr32/include/asm/types.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (C) 2004-2006 Atmel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __ASM_AVR32_TYPES_H
-#define __ASM_AVR32_TYPES_H
-
-#include <uapi/asm/types.h>
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-
-#define BITS_PER_LONG 32
-
-#endif /* __ASM_AVR32_TYPES_H */
-- 
1.7.9.5

