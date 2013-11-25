Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3KYI4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:56:21 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36426 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3KYIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 16/24] frv: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:26 +0100
Message-Id: <1385369734-24893-17-git-send-email-geert@linux-m68k.org>
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
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/Kbuild  |    1 +
 arch/frv/include/asm/types.h |   22 ----------------------
 2 files changed, 1 insertion(+), 22 deletions(-)
 delete mode 100644 arch/frv/include/asm/types.h

diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 74742dc6a3da..28abdd0b8287 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += clkdev.h
 generic-y += exec.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += types.h
diff --git a/arch/frv/include/asm/types.h b/arch/frv/include/asm/types.h
deleted file mode 100644
index 6bc63650d832..000000000000
--- a/arch/frv/include/asm/types.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* types.h: FRV types
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_TYPES_H
-#define _ASM_TYPES_H
-
-#include <uapi/asm/types.h>
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-
-#define BITS_PER_LONG 32
-
-#endif /* _ASM_TYPES_H */
-- 
1.7.9.5

