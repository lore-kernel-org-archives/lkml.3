Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030304Ab3BNWuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:50:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61473 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105Ab3BNWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:48:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 9/9] [media] davinci: do not include mach/hardware.h
Date: Thu, 14 Feb 2013 23:47:51 +0100
Message-Id: <1360882071-4072668-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NtB0PjOIcD61j1QZKPGmn9QUPf9K7gEQHSJp0GimSOt
 pOeKz8pVFpeSHvUEYBjR8tM9pEQsWQmGq5V3yyDToIEOp/GM6E
 Hz1WzFAjCZ3nktGIZn5T13xDkB0VwMUpm1rMxxyl9gTBYJ3PCQ
 hlo/MJ7g891TEdy8p8ET8P9qZYtnsH0c8B7S9mCXHYGfN9Hz41
 3Abh0lz4KqgxzMfW5D/J8y/ZLFGBNUZ7i3Y4wlosemNGk8R3bb
 3K/OO5fTaf0PgHi6p7Xf1tiMUjFbDjXp/P3QcwxAJe7x6+oMEN
 XkEw9ViwHBk/GlgF2ZDoetyVrWAT8L8Fb2FvuPefs8xH+KVQph
 cD3mtY/mvS0QEUXBZeiSOp5Ih0lJ9fODrdHnJQGtU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now possible to build the davinci vpss code
on multiplatform kernels, which causes a problem
since the driver tries to incude the davinci
platform specific mach/hardware.h file. Fortunately
that file is not required at all in the driver,
so we can simply remove the #include statement.

Without this patch, building allyesconfig results in:

drivers/media/platform/davinci/vpss.c:28:27: fatal error: mach/hardware.h: No such file or directory
compilation terminated.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Lad, Prabhakar" <prabhakar.lad@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 drivers/media/platform/davinci/vpss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 494d322..a19c552 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -25,7 +25,6 @@
 #include <linux/spinlock.h>
 #include <linux/compiler.h>
 #include <linux/io.h>
-#include <mach/hardware.h>
 #include <media/davinci/vpss.h>
 
 MODULE_LICENSE("GPL");
-- 
1.8.1.2

