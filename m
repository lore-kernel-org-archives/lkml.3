Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab3KXABs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:01:48 -0500
Received: from forward18.mail.yandex.net ([95.108.253.143]:36023 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab3KXABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:01:46 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Nov 2013 19:01:45 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <5290F68C.4060900@roeck-us.net>
References: <5290F68C.4060900@roeck-us.net>
Subject: Re: New build failures in v3.13-rc1
MIME-Version: 1.0
Message-Id: <14411385250870@web21g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sun, 24 Nov 2013 03:54:30 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.11.2013, 22:40, "Guenter Roeck" <linux@roeck-us.net>:
> =======================
> Building sparc64:allmodconfig ... failed
> --------------
> Error log:
> arch/sparc/kernel/kgdb_64.c: In function 'kgdb_trap':
> arch/sparc/kernel/kgdb_64.c:162:7: error: implicit declaration of function 'exception_enter' [-Werror=implicit-function-declaration]
> arch/sparc/kernel/kgdb_64.c:176:2: error: implicit declaration of function 'exception_exit' [-Werror=implicit-function-declaration]
> cc1: all warnings being treated as errors
> make[2]: *** [arch/sparc/kernel/kgdb_64.o] Error 1
>
> Introduced by commit 812cb83a5 (sparc64: Implement HAVE_CONTEXT_TRACKING).
>
> Reverting that commit fixes the problem.
>

The patch below fixes the problem:

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
---
 arch/sparc/kernel/kgdb_64.c | 1 +
 1 file changed, 1 insertion(+)
diff --git a/arch/sparc/kernel/kgdb_64.c b/arch/sparc/kernel/kgdb_64.c
index 60b19f5..b45fe3f 100644
--- a/arch/sparc/kernel/kgdb_64.c
+++ b/arch/sparc/kernel/kgdb_64.c
@@ -6,6 +6,7 @@
 #include <linux/kgdb.h>
 #include <linux/kdebug.h>
 #include <linux/ftrace.h>
+#include <linux/context_tracking.h>
 
 #include <asm/cacheflush.h>
 #include <asm/kdebug.h>
