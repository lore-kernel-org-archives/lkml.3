Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaB0NlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:41:18 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:34810 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaB0NlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:41:17 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-xtensa@linux-xtensa.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] xtensa: Export __invalidate_icache_range
Date: Thu, 27 Feb 2014 14:41:14 +0100
Message-Id: <1393508474-16710-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When modular code calls flush_icache_range():

    ERROR: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!
    make[1]: *** [__modpost] Error 1

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/10663772/

 arch/xtensa/kernel/xtensa_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index 80b33ed51f31..88eab32be29e 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -105,6 +105,7 @@ EXPORT_SYMBOL(csum_partial_copy_generic);
  * Architecture-specific symbols
  */
 EXPORT_SYMBOL(__xtensa_copy_user);
+EXPORT_SYMBOL(__invalidate_icache_range);
 
 /*
  * Kernel hacking ...
-- 
1.7.9.5

