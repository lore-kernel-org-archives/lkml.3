Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaJBN4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:56:02 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44289 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaJBNz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:55:59 -0400
Message-ID: <542D5AC6.4010404@gmail.com>
Date: Thu, 02 Oct 2014 22:01:42 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: wg@grandegger.com, mkl@pengutronix.de, Richard Weinberger <richard@nod.at>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/can/Kconfig: Let CAN_AT91 depend on HAS_IOMEM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAN_AT91 needs HAS_IOMEM, so depends on it. The related error (with
allmodconfig under um):

    CC [M]  drivers/net/can/at91_can.o
  drivers/net/can/at91_can.c: In function ‘at91_can_probe’:
  drivers/net/can/at91_can.c:1329:2: error: implicit declaration of function ‘ioremap_nocache’ [-Werror=implicit-function-declaration]
  addr = ioremap_nocache(res->start, resource_size(res));
    ^
  drivers/net/can/at91_can.c:1329:7: warning: assignment makes pointer from integer without a cast [enabled by default]
    addr = ioremap_nocache(res->start, resource_size(res));
         ^
  drivers/net/can/at91_can.c:1384:2: error: implicit declaration of function ‘iounmap’ [-Werror=implicit-function-declaration]
    iounmap(addr);
    ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/net/can/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index e78d6b3..98d73aa 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -65,7 +65,7 @@ config CAN_LEDS
 
 config CAN_AT91
 	tristate "Atmel AT91 onchip CAN controller"
-	depends on ARCH_AT91 || COMPILE_TEST
+	depends on (ARCH_AT91 || COMPILE_TEST) && HAS_IOMEM
 	---help---
 	  This is a driver for the SoC CAN controller in Atmel's AT91SAM9263
 	  and AT91SAM9X5 processors.
-- 
1.9.3
