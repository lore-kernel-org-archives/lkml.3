Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaGHMjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:39:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51056 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGHMjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:39:48 -0400
Message-ID: <53BBE68C.3010000@gmail.com>
Date: Tue, 08 Jul 2014 20:39:40 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: daniel.lezcano@linaro.org, tglx@linutronix.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH] drivers: clocksource: Kconfig: Let EM_TIMER_STI depend on
 HAS_IOMEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 'em_sti.c', it will call devm_ioremap_resource() which need
HAS_IOMEM. So need let EM_TIMER_STI depend on HAS_IOMEM, too.

The related error (with allmodconfig under score):

  LD      init/built-in.o
em_sti.c:(.text.em_sti_probe+0x84): undefined reference to `devm_ioremap_resource'
make: *** [vmlinux] Error 1


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/clocksource/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 8ad1eac..ce372d6 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -190,7 +190,7 @@ config SH_TIMER_TMU
 
 config EM_TIMER_STI
 	bool "Renesas STI timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_EM_STI
 	help
 	  This enables build of a clocksource and clockevent driver for
-- 
1.9.2.459.g68773ac
