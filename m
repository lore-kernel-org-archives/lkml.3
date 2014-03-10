Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaCJNWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 09:22:17 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:58801 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaCJNWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:22:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-cris-kernel@axis.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] cris: Convert ffs from an object-like macro to a function-like macro
Date: Mon, 10 Mar 2014 14:22:13 +0100
Message-Id: <1394457733-7141-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids bad interactions with code using identifiers called "ffs":

drivers/usb/gadget/f_fs.c: In function 'ffsmod_init':
drivers/usb/gadget/f_fs.c:2693:494: error: 'ffsusb_func' undeclared (first use in this function)
drivers/usb/gadget/f_fs.c:2693:494: note: each undeclared identifier is reported only once for each function it appears in
drivers/usb/gadget/f_fs.c: In function 'ffsmod_exit':
drivers/usb/gadget/f_fs.c:2693:677: error: 'ffsusb_func' undeclared (first use in this function)
drivers/usb/gadget/f_fs.c: At top level:
drivers/usb/gadget/f_fs.c:2693:35: warning: 'kernel_ffsusb_func' defined but not used [-Wunused-variable]
drivers/usb/gadget/f_fs.c: In function 'ffsmod_init':
drivers/usb/gadget/f_fs.c:2693:15: warning: control reaches end of non-void function [-Wreturn-type]

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/10715817/

 arch/cris/include/asm/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index 184066ceb1f6..053c17b36559 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -144,7 +144,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
  * definition, which doesn't have the same semantics.  We don't want to
  * use -fno-builtin, so just hide the name ffs.
  */
-#define ffs kernel_ffs
+#define ffs(x) kernel_ffs(x)
 
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
-- 
1.7.9.5

