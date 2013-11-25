Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3KYI5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:54 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:50565 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3KYIzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [PATCH 08/24] parisc/uapi: Use Kbuild logic to provide <asm/types.h>
Date: Mon, 25 Nov 2013 09:55:18 +0100
Message-Id: <1385369734-24893-9-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/include/uapi/asm/Kbuild  |    3 ++-
 arch/parisc/include/uapi/asm/types.h |    6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)
 delete mode 100644 arch/parisc/include/uapi/asm/types.h

diff --git a/arch/parisc/include/uapi/asm/Kbuild b/arch/parisc/include/uapi/asm/Kbuild
index a580642555b6..e0da93254186 100644
--- a/arch/parisc/include/uapi/asm/Kbuild
+++ b/arch/parisc/include/uapi/asm/Kbuild
@@ -1,6 +1,8 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
 
+generic-y += types.h
+
 header-y += bitsperlong.h
 header-y += byteorder.h
 header-y += errno.h
@@ -27,5 +29,4 @@ header-y += statfs.h
 header-y += swab.h
 header-y += termbits.h
 header-y += termios.h
-header-y += types.h
 header-y += unistd.h
diff --git a/arch/parisc/include/uapi/asm/types.h b/arch/parisc/include/uapi/asm/types.h
deleted file mode 100644
index 8866f9bbdeaf..000000000000
--- a/arch/parisc/include/uapi/asm/types.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _PARISC_TYPES_H
-#define _PARISC_TYPES_H
-
-#include <asm-generic/int-ll64.h>
-
-#endif
-- 
1.7.9.5

