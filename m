Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006Ab3ECJ5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:57:03 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51748 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3ECJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:57:02 -0400
Date: Fri, 3 May 2013 17:56:43 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
To: anton@enomsg.org, dwmw2@infradead.org
cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] power: fix bq27x00_battery kconfig
Message-ID: <alpine.DEB.2.02.1305031743190.6400@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

This patch fixes build failure(randconfig) of next-20130501.
When config I2C as m, BATTERY_BQ27x00 as y, here comes the failure.
BATTERY_BQ27x00 depends on I2C according to the code.

Failure message:
drivers/built-in.o: In function `bq27x00_read_i2c':
bq27x00_battery.c:(.text+0x1082a7): undefined reference to `i2c_transfer'
drivers/built-in.o: In function `bq27x00_battery_init':
bq27x00_battery.c:(.init.text+0x6085): undefined reference to `i2c_register_driver'
bq27x00_battery.c:(.init.text+0x60c7): undefined reference to `i2c_del_driver'
drivers/built-in.o: In function `bq27x00_battery_exit':
bq27x00_battery.c:(.exit.text+0xbf0): undefined reference to `i2c_del_driver'
make: *** [vmlinux] Error 1

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
drivers/power/Kconfig |    1 +
1 file changed, 1 insertion(+)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0d0b5d7..89e5ebd 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -152,6 +152,7 @@ config BATTERY_SBS
 
 config BATTERY_BQ27x00
 	tristate "BQ27x00 battery driver"
+	depends on I2C
 	help
 	  Say Y here to enable support for batteries with BQ27x00 (I2C/HDQ) chips.
 
