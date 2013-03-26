Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3CZEeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:34:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49897 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3CZEes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:34:48 -0400
Message-ID: <1364272469.18836.1.camel@phoenix>
Subject: [PATCH] clocksource: Fix build error when !CONFIG_CLKSRC_OF
From: Axel Lin <axel.lin@ingics.com>
To: Arnd Bergmann <arnd@arndb.de>, Rob Herring <rob.herring@calxeda.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 12:34:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC      drivers/clocksource/exynos_mct.o
drivers/clocksource/exynos_mct.c:557:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__unused'
drivers/clocksource/exynos_mct.c:558:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__unused'
make[2]: *** [drivers/clocksource/exynos_mct.o] Error 1
make[1]: *** [drivers/clocksource] Error 2
make: *** [drivers] Error 2

This build error is introduced by commit 4d10f054
"clocksource: make CLOCKSOURCE_OF_DECLARE type safe".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/clocksource.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index ac33184..b84a2f3 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -344,11 +344,7 @@ extern void clocksource_of_init(void);
 		     .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
 #else
 static inline void clocksource_of_init(void) {}
-#define CLOCKSOURCE_OF_DECLARE(name, compat, fn)			\
-	static const struct of_device_id __clksrc_of_table_##name	\
-		__unused __section(__clksrc_of_table)			\
-		 = { .compatible = compat,				\
-		     .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
+#define CLOCKSOURCE_OF_DECLARE(name, compat, fn)
 #endif
 
 #endif /* _LINUX_CLOCKSOURCE_H */
-- 
1.7.10.4



