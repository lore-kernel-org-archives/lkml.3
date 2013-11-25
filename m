Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3KYI50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:26 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36478 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KYIzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:47 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org
Subject: [PATCH 23/24] xtensa: Separate kernel/userspace inclusion of <asm-generic/int-ll64.h>
Date: Mon, 25 Nov 2013 09:55:33 +0100
Message-Id: <1385369734-24893-24-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to rename the kernelspace version later.

Now arch/xtensa/include/asm/types.h includes the kernelspace version,
while arch/xtensa/include/uapi/asm/types.h includes the userspace version.
As arch/xtensa/include/uapi/asm/types.h is also included for kernelspace,
its inclusion of <asm-generic/int-ll64.h> needs to be protected by #ifndef
__KERNEL__.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/include/asm/types.h      |    1 +
 arch/xtensa/include/uapi/asm/types.h |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/xtensa/include/asm/types.h b/arch/xtensa/include/asm/types.h
index 44f411c75837..d873cb17d944 100644
--- a/arch/xtensa/include/asm/types.h
+++ b/arch/xtensa/include/asm/types.h
@@ -10,6 +10,7 @@
 #ifndef _XTENSA_TYPES_H
 #define _XTENSA_TYPES_H
 
+#include <asm-generic/int-ll64.h>
 #include <uapi/asm/types.h>
 
 #endif	/* _XTENSA_TYPES_H */
diff --git a/arch/xtensa/include/uapi/asm/types.h b/arch/xtensa/include/uapi/asm/types.h
index 87ec7ae73cb1..5340b9fdb395 100644
--- a/arch/xtensa/include/uapi/asm/types.h
+++ b/arch/xtensa/include/uapi/asm/types.h
@@ -11,7 +11,9 @@
 #ifndef _UAPI_XTENSA_TYPES_H
 #define _UAPI_XTENSA_TYPES_H
 
+#ifndef __KERNEL__
 #include <asm-generic/int-ll64.h>
+#endif
 
 #ifdef __ASSEMBLY__
 # define __XTENSA_UL(x)		(x)
-- 
1.7.9.5

