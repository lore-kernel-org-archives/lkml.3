Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3EGCQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:16:12 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33106 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab3EGCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:16:08 -0400
Date: Tue, 7 May 2013 10:15:56 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Xiong Zhou <jencce.kernel@gmail.com>, anton@enomsg.org,
        dwmw2@infradead.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] power: fix bq27x00_battery kconfig
In-Reply-To: <5184E2CD.8040900@metafoo.de>
Message-ID: <alpine.DEB.2.02.1305071013410.9830@M2420>
References: <alpine.DEB.2.02.1305031743190.6400@M2420> <51838C3E.5090303@metafoo.de> <CADJHv_s7TqdfULQKA6eTVEHkxBKqr44c9qeP8KCFXJuBxMmsYQ@mail.gmail.com> <5184E2CD.8040900@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

This patch fixes build failure(randconfig) of next-20130501.
When config I2C as m, BATTERY_BQ27x00 as y, here comes the failure.
The driver depends on I2C only if I2C is not disabled, as Lars
commented. Last version of this patch make the driver depend on I2C
unconditionally.

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
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
drivers/power/Kconfig |    1 +
1 file changed, 1 insertion(+)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0d0b5d7..f11bacd 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -152,6 +152,7 @@ config BATTERY_SBS
 
 config BATTERY_BQ27x00
 	tristate "BQ27x00 battery driver"
+	depends on I2C || I2C=n
 	help
 	  Say Y here to enable support for batteries with BQ27x00 (I2C/HDQ) chips.
 
