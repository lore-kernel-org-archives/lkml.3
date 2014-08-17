Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaHQKJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:09:19 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33057 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHQKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:09:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] extcon: sm5502: EXTCON_SM5502 should depend on I2C
Date: Sun, 17 Aug 2014 12:08:58 +0200
Message-Id: <1408270138-29811-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
References: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXTCON_SM5502 selects REGMAP_I2C, but if I2C=n:

drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_byte_reg_read’:
drivers/base/regmap/regmap-i2c.c:28: error: implicit declaration of function ‘i2c_smbus_read_byte_data’
drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_byte_reg_write’:
drivers/base/regmap/regmap-i2c.c:46: error: implicit declaration of function ‘i2c_smbus_write_byte_data’
drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_word_reg_read’:
drivers/base/regmap/regmap-i2c.c:64: error: implicit declaration of function ‘i2c_smbus_read_word_data’
drivers/base/regmap/regmap-i2c.c: In function ‘regmap_smbus_word_reg_write’:
drivers/base/regmap/regmap-i2c.c:82: error: implicit declaration of function ‘i2c_smbus_write_word_data’
drivers/base/regmap/regmap-i2c.c: In function ‘regmap_i2c_write’:
drivers/base/regmap/regmap-i2c.c:96: error: implicit declaration of function ‘i2c_master_send’
drivers/base/regmap/regmap-i2c.c: In function ‘regmap_i2c_gather_write’:
drivers/base/regmap/regmap-i2c.c:117: error: implicit declaration of function ‘i2c_check_functionality’
drivers/base/regmap/regmap-i2c.c:130: error: implicit declaration of function ‘i2c_transfer’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/extcon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 6f2f4727de2c..764f3a113e0a 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -72,6 +72,7 @@ config EXTCON_PALMAS
 
 config EXTCON_SM5502
 	tristate "SM5502 EXTCON support"
+	depends on I2C
 	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ
-- 
1.9.1

