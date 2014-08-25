Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaHYPdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:33:09 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:32980 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbaHYPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:33:05 -0400
Message-ID: <53FB572F.1030803@bluespec.com>
Date: Mon, 25 Aug 2014 11:33:03 -0400
From: Darius Rad <darius@bluespec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] include/linux/atomic.h: include asm-generic/atomic-long.h
 after asm-generic/atomic64.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the include of asm-generic/atomic-long.h to after the conditional
include of asm-generic/atomic64.h.  This is necessary if
CONFIG_GENERIC_ATOMIC64 is y and BITS_PER_LONG == 64, because
atomic-long.h uses functions declared in atomic64.h.

Signed-off-by: Darius Rad <darius@bluespec.com>

---
It does not appear that this is relevant to architectures that are in the
kernel tree (i.e., no architectures use GENERIC_ATOMIC64 on 64-bit).  It
is relevant, however, to certain combinations of options for the RISC-V
architecture currently in development.

Patch generated against 3.17-rc1.

 include/linux/atomic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.17-rc1.orig/include/linux/atomic.h	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17-rc1/include/linux/atomic.h	2014-08-22 16:07:55.297515936 -0400
@@ -160,8 +160,8 @@ static inline void atomic_or(int i, atom
 }
 #endif /* #ifndef CONFIG_ARCH_HAS_ATOMIC_OR */
 
-#include <asm-generic/atomic-long.h>
 #ifdef CONFIG_GENERIC_ATOMIC64
 #include <asm-generic/atomic64.h>
 #endif
+#include <asm-generic/atomic-long.h>
 #endif /* _LINUX_ATOMIC_H */
