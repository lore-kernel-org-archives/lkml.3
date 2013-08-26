Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3HZK0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:26:42 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45378 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3HZK0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:26:40 -0400
X-Spam-Score: -101.0
Message-ID: <521B2D1F.8080402@asianux.com>
Date: Mon, 26 Aug 2013 18:25:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300/kernel/h8300_ksyms.c: add "asm/gpio-internal.h" to
 pass compiling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need add "asm/gpio-internal.h" to pass compiling.

The related error (allmodconfig for h8300):

  In file included from include/linux/linkage.h:6:0,
                   from include/linux/kernel.h:6,
                   from include/linux/cache.h:4,
                   from include/linux/time.h:4,
                   from include/linux/stat.h:18,
                   from include/linux/module.h:10,
                   from arch/h8300/kernel/h8300_ksyms.c:1:
  arch/h8300/kernel/h8300_ksyms.c: At top level:
  arch/h8300/kernel/h8300_ksyms.c:98:15: error: 'h8300_reserved_gpio' undeclared here (not in a function)
   EXPORT_SYMBOL(h8300_reserved_gpio);
                 ^
  include/linux/export.h:57:16: note: in definition of macro '__EXPORT_SYMBOL'
    extern typeof(sym) sym;     \
                  ^
  arch/h8300/kernel/h8300_ksyms.c:98:1: note: in expansion of macro 'EXPORT_SYMBOL'
   EXPORT_SYMBOL(h8300_reserved_gpio);
   ^
  arch/h8300/kernel/h8300_ksyms.c:99:15: error: 'h8300_free_gpio' undeclared here (not in a function)
   EXPORT_SYMBOL(h8300_free_gpio);
                 ^
  include/linux/export.h:57:16: note: in definition of macro '__EXPORT_SYMBOL'
    extern typeof(sym) sym;     \
                  ^
  arch/h8300/kernel/h8300_ksyms.c:99:1: note: in expansion of macro 'EXPORT_SYMBOL'
   EXPORT_SYMBOL(h8300_free_gpio);
   ^
  arch/h8300/kernel/h8300_ksyms.c:100:15: error: 'h8300_set_gpio_dir' undeclared here (not in a function)
   EXPORT_SYMBOL(h8300_set_gpio_dir);
                 ^
  include/linux/export.h:57:16: note: in definition of macro '__EXPORT_SYMBOL'
    extern typeof(sym) sym;     \
                  ^
  arch/h8300/kernel/h8300_ksyms.c:100:1: note: in expansion of macro 'EXPORT_SYMBOL'
   EXPORT_SYMBOL(h8300_set_gpio_dir);
   ^
  cc1: some warnings being treated as errors
  make[1]: *** [arch/h8300/kernel/h8300_ksyms.o] Error 1
  make: *** [arch/h8300/kernel] Error 2


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/kernel/h8300_ksyms.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/kernel/h8300_ksyms.c b/arch/h8300/kernel/h8300_ksyms.c
index 53d7c0e..a21900f 100644
--- a/arch/h8300/kernel/h8300_ksyms.c
+++ b/arch/h8300/kernel/h8300_ksyms.c
@@ -14,6 +14,7 @@
 #include <asm/io.h>
 #include <asm/checksum.h>
 #include <asm/current.h>
+#include <asm/gpio-internal.h>
 #include <asm/gpio.h>
 
 //asmlinkage long long __ashrdi3 (long long, int);
-- 
1.7.7.6
