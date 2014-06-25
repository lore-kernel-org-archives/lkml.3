Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaFYJoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:44:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:19082 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFYJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:44:00 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <pebolle@tiscali.nl>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] misc: atmel_pwm: fix Kconfig symbols
Date: Wed, 25 Jun 2014 11:43:56 +0200
Message-ID: <1403689436-6664-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <20140618093109.GQ19375@piout.net>
References: <20140618093109.GQ19375@piout.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AT91 symbols AT91SAM9263, AT91SAM9RL, and AT91SAM9G45 do not exist and this
patch change them their correct ARCH_* version.
These symbols are chosen instead of the SOC_* one because this driver is not
converted to DT.
Anyway, the ATMEL_PWM symbol and the associated driver will be removed soon
during the move to the PWM sub-system.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Guys,

The rework is delayed to 3.17. So, in the meantime, I send this little patch
as a fix for 3.16.

Bye,

 drivers/misc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a43d0c467274..ee9402324a23 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -54,7 +54,7 @@ config AD525X_DPOT_SPI
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
 	depends on HAVE_CLK
-	depends on AVR32 || AT91SAM9263 || AT91SAM9RL || AT91SAM9G45
+	depends on AVR32 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel processors.  Pulse Width Modulation is used for
-- 
1.8.2.2

