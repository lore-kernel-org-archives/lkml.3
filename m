Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3KYI51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:57:27 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39952 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KYIzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:48 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 21/24] powerpc: Separate kernel/userspace inclusion of <asm-generic/int-ll64.h>
Date: Mon, 25 Nov 2013 09:55:31 +0100
Message-Id: <1385369734-24893-22-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to rename the kernelspace version later.

Now arch/powerpc/include/asm/types.h includes the kernelspace version,
while arch/powerpc/include/uapi/asm/types.h includes the userspace version.
As arch/powerpc/include/uapi/asm/types.h is also included for kernelspace,
its inclusion of <asm-generic/int-ll64.h> needs to be protected by #ifndef
__KERNEL__.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/types.h      |    1 +
 arch/powerpc/include/uapi/asm/types.h |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/types.h b/arch/powerpc/include/asm/types.h
index bfb6ded38ffa..4b9c3530bb12 100644
--- a/arch/powerpc/include/asm/types.h
+++ b/arch/powerpc/include/asm/types.h
@@ -13,6 +13,7 @@
 #ifndef _ASM_POWERPC_TYPES_H
 #define _ASM_POWERPC_TYPES_H
 
+#include <asm-generic/int-ll64.h>
 #include <uapi/asm/types.h>
 
 #ifndef __ASSEMBLY__
diff --git a/arch/powerpc/include/uapi/asm/types.h b/arch/powerpc/include/uapi/asm/types.h
index 4b8ab990a3c1..7f8847b61d03 100644
--- a/arch/powerpc/include/uapi/asm/types.h
+++ b/arch/powerpc/include/uapi/asm/types.h
@@ -21,11 +21,13 @@
  * However, some user programs are fine with this.  They can
  * flag __SANE_USERSPACE_TYPES__ to get int-ll64.h here.
  */
-#if !defined(__SANE_USERSPACE_TYPES__) && defined(__powerpc64__) && !defined(__KERNEL__)
+#ifndef __KERNEL__
+#if !defined(__SANE_USERSPACE_TYPES__) && defined(__powerpc64__)
 # include <asm-generic/int-l64.h>
 #else
 # include <asm-generic/int-ll64.h>
 #endif
+#endif
 
 #ifndef __ASSEMBLY__
 
-- 
1.7.9.5

