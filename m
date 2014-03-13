Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaCMN1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:27:25 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44301 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaCMN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:27:24 -0400
Message-ID: <5321B230.6030109@gmail.com>
Date: Thu, 13 Mar 2014 21:27:12 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/kernel/ksyms.c: remove several undefined exported
 symbols
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 'csum_partial_copy_nocheck()', it has default definition in
'asm-generic'.

For '__raw_reads?()' and '__raw_writes?()' are used by the drivers
which no relationship with allmodconfig for unicode32, the related
modules are:

  drivers/mmc/host/omap.c
  drivers/mtd/nand/atmel_nand.c
  drivers/mtd/nand/pxa3xx_nand.c
  drivers/usb/gadget/at91_udc.c

Others are only within some architectures (not kernel wide).


The related error with allmodconfig for unicode32:

    CC      arch/unicore32/kernel/ksyms.o
  arch/unicore32/kernel/ksyms.c:29: error: ‘__backtrace’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:29: error: type defaults to ‘int’ in declaration of ‘__backtrace’
  arch/unicore32/kernel/ksyms.c:38: error: ‘csum_partial_copy_nocheck’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:38: error: type defaults to ‘int’ in declaration of ‘csum_partial_copy_nocheck’
  arch/unicore32/kernel/ksyms.c:39: error: ‘__csum_ipv6_magic’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:39: error: type defaults to ‘int’ in declaration of ‘__csum_ipv6_magic’
  arch/unicore32/kernel/ksyms.c:43: error: ‘__raw_readsb’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:43: error: type defaults to ‘int’ in declaration of ‘__raw_readsb’
  arch/unicore32/kernel/ksyms.c:46: error: ‘__raw_readsw’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:46: error: type defaults to ‘int’ in declaration of ‘__raw_readsw’
  arch/unicore32/kernel/ksyms.c:49: error: ‘__raw_readsl’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:49: error: type defaults to ‘int’ in declaration of ‘__raw_readsl’
  arch/unicore32/kernel/ksyms.c:52: error: ‘__raw_writesb’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:52: error: type defaults to ‘int’ in declaration of ‘__raw_writesb’
  arch/unicore32/kernel/ksyms.c:55: error: ‘__raw_writesw’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:55: error: type defaults to ‘int’ in declaration of ‘__raw_writesw’
  arch/unicore32/kernel/ksyms.c:58: error: ‘__raw_writesl’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:58: error: type defaults to ‘int’ in declaration of ‘__raw_writesl’
  arch/unicore32/kernel/ksyms.c:79: error: ‘__get_user_1’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:79: error: type defaults to ‘int’ in declaration of ‘__get_user_1’
  arch/unicore32/kernel/ksyms.c:80: error: ‘__get_user_2’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:80: error: type defaults to ‘int’ in declaration of ‘__get_user_2’
  arch/unicore32/kernel/ksyms.c:81: error: ‘__get_user_4’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:81: error: type defaults to ‘int’ in declaration of ‘__get_user_4’
  arch/unicore32/kernel/ksyms.c:83: error: ‘__put_user_1’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:83: error: type defaults to ‘int’ in declaration of ‘__put_user_1’
  arch/unicore32/kernel/ksyms.c:84: error: ‘__put_user_2’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:84: error: type defaults to ‘int’ in declaration of ‘__put_user_2’
  arch/unicore32/kernel/ksyms.c:85: error: ‘__put_user_4’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:85: error: type defaults to ‘int’ in declaration of ‘__put_user_4’
  arch/unicore32/kernel/ksyms.c:86: error: ‘__put_user_8’ undeclared here (not in a function)
  arch/unicore32/kernel/ksyms.c:86: error: type defaults to ‘int’ in declaration of ‘__put_user_8’


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/ksyms.c |   33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index d285d71..63afc7f 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -26,8 +26,6 @@
 EXPORT_SYMBOL(find_next_zero_bit);
 EXPORT_SYMBOL(find_next_bit);
 
-EXPORT_SYMBOL(__backtrace);
-
 	/* platform dependent support */
 EXPORT_SYMBOL(__udelay);
 EXPORT_SYMBOL(__const_udelay);
@@ -35,28 +33,6 @@ EXPORT_SYMBOL(__const_udelay);
 	/* networking */
 EXPORT_SYMBOL(csum_partial);
 EXPORT_SYMBOL(csum_partial_copy_from_user);
-EXPORT_SYMBOL(csum_partial_copy_nocheck);
-EXPORT_SYMBOL(__csum_ipv6_magic);
-
-	/* io */
-#ifndef __raw_readsb
-EXPORT_SYMBOL(__raw_readsb);
-#endif
-#ifndef __raw_readsw
-EXPORT_SYMBOL(__raw_readsw);
-#endif
-#ifndef __raw_readsl
-EXPORT_SYMBOL(__raw_readsl);
-#endif
-#ifndef __raw_writesb
-EXPORT_SYMBOL(__raw_writesb);
-#endif
-#ifndef __raw_writesw
-EXPORT_SYMBOL(__raw_writesw);
-#endif
-#ifndef __raw_writesl
-EXPORT_SYMBOL(__raw_writesl);
-#endif
 
 	/* string / mem functions */
 EXPORT_SYMBOL(strchr);
@@ -76,15 +52,6 @@ EXPORT_SYMBOL(__copy_from_user);
 EXPORT_SYMBOL(__copy_to_user);
 EXPORT_SYMBOL(__clear_user);
 
-EXPORT_SYMBOL(__get_user_1);
-EXPORT_SYMBOL(__get_user_2);
-EXPORT_SYMBOL(__get_user_4);
-
-EXPORT_SYMBOL(__put_user_1);
-EXPORT_SYMBOL(__put_user_2);
-EXPORT_SYMBOL(__put_user_4);
-EXPORT_SYMBOL(__put_user_8);
-
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__divsi3);
-- 
1.7.9.5
