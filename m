Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaEHO5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:57:11 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61984 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaEHO5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] misc: atmel_pwm: only build for supported platforms
Date: Thu,  8 May 2014 16:56:28 +0200
Message-Id: <1399560990-1402858-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:x0bi2kko0o8YTCWIXqgHJ9PmUL67a+dsEXzF6ENy8UR
 eDQm4WQmm3/nKFN3M19ez4g9IbpHJ5tMSCj4/bIw4KDd8wKHHb
 RVaXuzIE/3Q2wvIx38M1KNyabHJVfPEbT2HViwJb9jtaeflCp3
 WiIjfQzHXGcxsGUmdOwq1GDCix34hWLJLpslvgjz8/RxmsPr2U
 pTwNrx38loRxHBeY0pmcT78QHLKS9fWDBaZRLJ4ChKz8ZMBflW
 OdFXyBUbm8TkAZtD/brX+j8EvvKPnNr4KTzXm81aAQIAQEtgVF
 OMPVbScxmMmjnNVNegxJUVcxsxQegV/2B9jhz0Fj5pwgwONIdM
 zckaX8HdXzBe87FnfSJYeDG6PSOW/mQsIYht2JX+t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is architecture code in mach-at91 that depends on the
CONFIG_ATMEL_PWM symbol in order to call the soc-specific
at91_add_device_pwm function. While all of this is about code
that will be removed in the future, using DT probing and
the PWM framework, we currently get a build failure:

arch/arm/mach-at91/built-in.o: In function `at91_pwm_leds':
arch/arm/mach-at91/leds.c:88: undefined reference to `at91_add_device_pwm'

This patch ensures we only try to build this driver on
platforms on which it will build and work.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index fe2230c..ce29342 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -53,7 +53,8 @@ config AD525X_DPOT_SPI
 
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
-	depends on HAVE_CLK && (AVR32 || ARCH_AT91 || COMPILE_TEST)
+	depends on HAVE_CLK
+	depends on AVR32 || AT91SAM9263 || AT91SAM9RL || AT91SAM9G45
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel processors.  Pulse Width Modulation is used for
-- 
1.8.3.2

