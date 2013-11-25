Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3KYI4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:56:06 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36428 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3KYIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH 15/24] cris: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:25 +0100
Message-Id: <1385369734-24893-16-git-send-email-geert@linux-m68k.org>
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
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/include/asm/Kbuild  |    1 +
 arch/cris/include/asm/types.h |   12 ------------
 2 files changed, 1 insertion(+), 12 deletions(-)
 delete mode 100644 arch/cris/include/asm/types.h

diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 44e7d0dbcf32..2433df443890 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -13,3 +13,4 @@ generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
 generic-y += preempt.h
+generic-y += types.h
diff --git a/arch/cris/include/asm/types.h b/arch/cris/include/asm/types.h
deleted file mode 100644
index a3cac7757c7f..000000000000
--- a/arch/cris/include/asm/types.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ETRAX_TYPES_H
-#define _ETRAX_TYPES_H
-
-#include <uapi/asm/types.h>
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-
-#define BITS_PER_LONG 32
-
-#endif
-- 
1.7.9.5

