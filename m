Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaHMHWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:22:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaHMHWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:22:23 -0400
Message-ID: <53EB122E.3050407@infradead.org>
Date: Wed, 13 Aug 2014 00:22:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: [PATCH -next] extcon: fix extcon-sm5502 build when CONFIG_I2C=m
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors in extcon-sm5502.c by making EXTCON_SM5502 depend
on I2C since it selects REGMAP_I2C.  The build errors happen when
CONFIG_I2C=m and CONFIG_EXTCON_SM5502=y. This Kconfig change causes
CONFIG_EXTCON_SM5502 to be =m when CONFIG_I2C=m.

drivers/built-in.o: In function `regmap_smbus_byte_reg_read':
regmap-i2c.c:(.text+0x5030a): undefined reference to `i2c_smbus_read_byte_data'
drivers/built-in.o: In function `regmap_smbus_byte_reg_write':
regmap-i2c.c:(.text+0x50338): undefined reference to `i2c_smbus_write_byte_data'
drivers/built-in.o: In function `regmap_smbus_word_reg_read':
regmap-i2c.c:(.text+0x50356): undefined reference to `i2c_smbus_read_word_data'
drivers/built-in.o: In function `regmap_smbus_word_reg_write':
regmap-i2c.c:(.text+0x50384): undefined reference to `i2c_smbus_write_word_data'
drivers/built-in.o: In function `regmap_i2c_read':
regmap-i2c.c:(.text+0x503cf): undefined reference to `i2c_transfer'
drivers/built-in.o: In function `regmap_i2c_gather_write':
regmap-i2c.c:(.text+0x50442): undefined reference to `i2c_transfer'
drivers/built-in.o: In function `regmap_i2c_write':
regmap-i2c.c:(.text+0x50474): undefined reference to `i2c_master_send'
drivers/built-in.o: In function `sm5502_muic_i2c_init':
extcon-sm5502.c:(.init.text+0x6630): undefined reference to `i2c_register_driver'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	MyungJoo Ham <myungjoo.ham@samsung.com>
Cc:	Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-next-20140813/drivers/extcon/Kconfig
===================================================================
--- linux-next-20140813.orig/drivers/extcon/Kconfig
+++ linux-next-20140813/drivers/extcon/Kconfig
@@ -72,6 +72,7 @@ config EXTCON_PALMAS
 
 config EXTCON_SM5502
 	tristate "SM5502 EXTCON support"
+	depends on I2C
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ
