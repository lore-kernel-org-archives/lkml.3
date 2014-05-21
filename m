Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaEUBhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:37:15 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63909 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaEUBhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:37:13 -0400
Message-ID: <537C0344.5010509@gmail.com>
Date: Wed, 21 May 2014 09:37:08 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: unicore32: kernel: ksyms: remove 'bswapsi2' and 'muldi3'
 to avoid compiling failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After check the code, 'bswapsi2' and 'muldi3' are useless for
unicore32, so can remove them to avoid compiling failure.

The related error (with allmodconfig under unicore32):

    LD      init/built-in.o
  arch/unicore32/kernel/built-in.o:(___ksymtab+__muldi3+0x0): undefined reference to `__muldi3'
  arch/unicore32/kernel/built-in.o:(___ksymtab+__bswapsi2+0x0): undefined reference to `__bswapsi2'


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/ksyms.c | 2 --
 arch/unicore32/kernel/ksyms.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index bc06140..e78911a 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -53,9 +53,7 @@ EXPORT_SYMBOL(__ashrdi3);
 EXPORT_SYMBOL(__divsi3);
 EXPORT_SYMBOL(__lshrdi3);
 EXPORT_SYMBOL(__modsi3);
-EXPORT_SYMBOL(__muldi3);
 EXPORT_SYMBOL(__ucmpdi2);
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
-EXPORT_SYMBOL(__bswapsi2);
 
diff --git a/arch/unicore32/kernel/ksyms.h b/arch/unicore32/kernel/ksyms.h
index 185cdc7..31472ad 100644
--- a/arch/unicore32/kernel/ksyms.h
+++ b/arch/unicore32/kernel/ksyms.h
@@ -8,8 +8,6 @@ extern void __ashrdi3(void);
 extern void __divsi3(void);
 extern void __lshrdi3(void);
 extern void __modsi3(void);
-extern void __muldi3(void);
 extern void __ucmpdi2(void);
 extern void __udivsi3(void);
 extern void __umodsi3(void);
-extern void __bswapsi2(void);
-- 
1.9.2.459.g68773ac
