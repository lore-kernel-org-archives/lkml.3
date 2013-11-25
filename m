Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab3KYI5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:46 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39828 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab3KYIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH 18/24] mn10300: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:28 +0100
Message-Id: <1385369734-24893-19-git-send-email-geert@linux-m68k.org>
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
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
---
 arch/mn10300/include/asm/Kbuild  |    1 +
 arch/mn10300/include/asm/types.h |   22 ----------------------
 2 files changed, 1 insertion(+), 22 deletions(-)
 delete mode 100644 arch/mn10300/include/asm/types.h

diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index cd33bcfc49d8..289ff285f1f9 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += exec.h
 generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += preempt.h
+generic-y += types.h
diff --git a/arch/mn10300/include/asm/types.h b/arch/mn10300/include/asm/types.h
deleted file mode 100644
index 3d6e48311bef..000000000000
--- a/arch/mn10300/include/asm/types.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* MN10300 Basic type definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
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

