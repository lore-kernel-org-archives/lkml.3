Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaLELUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:20:39 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:42985 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbaLELU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:20:28 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc32: fix warning from include/asm-generic/termios-base.h
Message-Id: <20141205112025.330971A5D4F@localhost.localdomain>
Date: Fri,  5 Dec 2014 12:20:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When size is equal to 1, the test is always true so lets eliminate both 0 and 1
at first.

include/asm-generic/termios-base.h: In function 'user_termio_to_kernel_termios':
include/asm-generic/termios-base.h:35:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  if (get_user(termios->c_line, &termio->c_line) < 0)
  ^
include/asm-generic/termios-base.h: In function 'kernel_termios_to_user_termio':
include/asm-generic/termios-base.h:57:6: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
      put_user(termios->c_line,  &termio->c_line) < 0 ||
      ^

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 9485b43..f3028d2 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -54,7 +54,7 @@
 
 #define __access_ok(addr, size, segment)	\
 	(((addr) <= (segment).seg) &&		\
-	 (((size) == 0) || (((size) - 1) <= ((segment).seg - (addr)))))
+	 (((size) <= 1) || (((size) - 1) <= ((segment).seg - (addr)))))
 
 #endif
 
-- 
2.1.0

