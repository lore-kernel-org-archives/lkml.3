Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3KXKl6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:41:58 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39481 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab3KXKlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:41:55 -0500
Date: Sun, 24 Nov 2013 21:41:49 +1100
From: Austin Boyle <boyle.austin@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] max17042: Fix build errors caused by missing REGMAP_I2C
 config
Message-Id: <20131124214149.cf1b6444d6e43d637ea7e34b@gmail.com>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max17042 now uses regmap interface but does not enable config option. This patch fixes the following build errors:

drivers/power/max17042_battery.c:661:15: error: variable ‘max17042_regmap_config’ has initializer but incomplete type
drivers/power/max17042_battery.c:662:2: error: unknown field ‘reg_bits’ specified in initializer
drivers/power/max17042_battery.c:662:2: warning: excess elements in struct initializer
drivers/power/max17042_battery.c:662:2: warning: (near initialization for ‘max17042_regmap_config’)
drivers/power/max17042_battery.c:663:2: error: unknown field ‘val_bits’ specified in initializer
drivers/power/max17042_battery.c:663:2: warning: excess elements in struct initializer
drivers/power/max17042_battery.c:663:2: warning: (near initialization for ‘max17042_regmap_config’)
drivers/power/max17042_battery.c:664:2: error: unknown field ‘val_format_endian’ specified in initializer
drivers/power/max17042_battery.c:664:23: error: ‘REGMAP_ENDIAN_NATIVE’ undeclared here (not in a function)
drivers/power/max17042_battery.c:664:2: warning: excess elements in struct initializer
drivers/power/max17042_battery.c:664:2: warning: (near initialization for ‘max17042_regmap_config’)
drivers/power/max17042_battery.c: In function ‘max17042_probe’:
drivers/power/max17042_battery.c:684:2: error: implicit declaration of function ‘devm_regmap_init_i2c’

Signed-off-by: Austin Boyle <boyle.austin@gmail.com>
---
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 5e2054a..85ad58c 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -196,6 +196,7 @@ config BATTERY_MAX17040
 config BATTERY_MAX17042
 	tristate "Maxim MAX17042/17047/17050/8997/8966 Fuel Gauge"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  MAX17042 is fuel-gauge systems for lithium-ion (Li+) batteries
 	  in handheld and portable equipment. The MAX17042 is configured
