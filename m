Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaEHO6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:58:18 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65243 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaEHO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 2/2] input: atmel-wm97xx: only build for AVR32
Date: Thu,  8 May 2014 16:56:27 +0200
Message-Id: <1399560990-1402858-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:L4QXb7j6IHmnA46D81Zq4FdezrZbGrbiCiICeC8eRAR
 oODgvjvKa13XRRPH9FsFhhnQLq91CqY6mHh9RD/pojazfky9FT
 +Pvb9z3geuKe9u2bxbBV46bCC+2ssm9LItQUrHoPyS/ZhpZ9jK
 ekeSi1D7Zv7ZkeGT+ssCG/2pGB+j2zJgZrRnuAC0h8AY+tBF69
 eiYKAUKO+yu69UTdk8GIhJ22/b2a0yci/D89ts7IK0Yup7HEm1
 DH26PT1H6fjyamGLFHrtxi4/YfrFwrr8n8x01720V8Dgfnap57
 D5ifeXb0VjlsMmbOdMBzPFTk3nPOoOU+9u2D6FOpmpdX8GccMn
 O5oxgFSxVfxvn3KMKUrumLJ5sbWOB6GwIXEJYNl5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building this driver on ARM/at91 always gives us this error message:

drivers/input/touchscreen/atmel-wm97xx.c:63:2: error: #error Unknown CPU, this driver only supports AT32AP700X CPUs.

Clearly this configuration is not meant to work, so let's just prevent
it in Kconfig. If we ever want to use it on another platform, we should
also pass proper resources for GPIO, IRQ and memory, which are hardcoded
to AT32AP700X at the moment.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/touchscreen/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index e2f0264..fe4c264 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -640,7 +640,7 @@ config TOUCHSCREEN_WM9713
 
 config TOUCHSCREEN_WM97XX_ATMEL
 	tristate "WM97xx Atmel accelerated touch"
-	depends on TOUCHSCREEN_WM97XX && (AVR32 || ARCH_AT91)
+	depends on TOUCHSCREEN_WM97XX && AVR32
 	help
 	  Say Y here for support for streaming mode with WM97xx touchscreens
 	  on Atmel AT91 or AVR32 systems with an AC97C module.
-- 
1.8.3.2

