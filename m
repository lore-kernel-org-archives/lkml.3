Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaJBNlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:41:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52044 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbaJBNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:41:03 -0400
Message-ID: <542D5747.1060100@gmail.com>
Date: Thu, 02 Oct 2014 21:46:47 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: daniel.lezcano@linaro.org, tglx@linutronix.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] drivers/clocksource/Kconfig: Let SH_TIMER_CMT depend on
 HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH_TIMER_CMT will use IO memory features which needs HAS_IOMEM, so need
depend on it. One of the related error (with allmodconfig under um):

    CC      drivers/clocksource/sh_cmt.o
  drivers/clocksource/sh_cmt.c: In function 'sh_cmt_map_memory':
  drivers/clocksource/sh_cmt.c:920:2: error: implicit declaration of function 'ioremap_nocache' [-Werror=implicit-function-declaration]
    cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
    ^
  drivers/clocksource/sh_cmt.c:920:15: warning: assignment makes pointer from integer without a cast [enabled by default]
    cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
                 ^
  drivers/clocksource/sh_cmt.c: In function 'sh_cmt_setup':
  drivers/clocksource/sh_cmt.c:1034:2: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
    iounmap(cmt->mapbase);
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/clocksource/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 82a2ebe..2ad6d4e 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -172,7 +172,7 @@ config SYS_SUPPORTS_EM_STI
 
 config SH_TIMER_CMT
 	bool "Renesas CMT timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_SH_CMT
 	help
 	  This enables build of a clocksource and clockevent driver for
@@ -181,7 +181,7 @@ config SH_TIMER_CMT
 
 config SH_TIMER_MTU2
 	bool "Renesas MTU2 timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_SH_MTU2
 	help
 	  This enables build of a clockevent driver for the Multi-Function
@@ -190,7 +190,7 @@ config SH_TIMER_MTU2
 
 config SH_TIMER_TMU
 	bool "Renesas TMU timer driver" if COMPILE_TEST
-	depends on GENERIC_CLOCKEVENTS
+	depends on GENERIC_CLOCKEVENTS && HAS_IOMEM
 	default SYS_SUPPORTS_SH_TMU
 	help
 	  This enables build of a clocksource and clockevent driver for
-- 
1.9.3
