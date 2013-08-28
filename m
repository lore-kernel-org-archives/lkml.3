Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3H1EGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 00:06:43 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62024 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3H1EGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 00:06:42 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-xtensa@linux-xtensa.org
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        Guenter Roeck <linux@roeck-us.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] xtensa: Fix broken allmodconfig build
Date: Tue, 27 Aug 2013 21:06:37 -0700
Message-Id: <1377662797-21770-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtansa allmodbuild fails with:

arch/xtensa/kernel/xtensa_ksyms.c:129:1: error: '_mcount' undeclared here (not in a function)
make[2]: *** [arch/xtensa/kernel/xtensa_ksyms.o] Error 1
make[1]: *** [arch/xtensa/kernel] Error 2

The breakage is due to commit 478ba61af (xtensa: add static function tracer
support) which exports _mcount without declaring it.

Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/xtensa/kernel/xtensa_ksyms.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index d8507f8..74a60c7 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -25,6 +25,7 @@
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
+#include <asm/ftrace.h>
 #ifdef CONFIG_BLK_DEV_FD
 #include <asm/floppy.h>
 #endif
-- 
1.7.9.7

