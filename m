Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464Ab3BLO1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:27:40 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:40334 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760419Ab3BLO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:27:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] avr32: atmel_default_console_device depends on CONFIG_SERIAL_ATMEL
Date: Tue, 12 Feb 2013 15:27:35 +0100
Message-Id: <1360679255-11799-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allnoconfig:

arch/avr32/mach-at32ap/built-in.o: In function `at32_select_gpio':
(.init.text+0x548): undefined reference to `atmel_default_console_device'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index b323d8d..a2fe61b 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1060,7 +1060,9 @@ struct platform_device *__init at32_add_device_usart(unsigned int id)
 
 void __init at32_setup_serial_console(unsigned int usart_id)
 {
+#ifdef CONFIG_SERIAL_ATMEL
 	atmel_default_console_device = at32_usarts[usart_id];
+#endif
 }
 
 /* --------------------------------------------------------------------
-- 
1.7.0.4

