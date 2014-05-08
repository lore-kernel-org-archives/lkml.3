Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaEHO5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:57:01 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:61440 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaEHO46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-iio@vger.kernel.org, Josh Wu <josh.wu@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] iio:adc: at91 requires the input subsystem
Date: Thu,  8 May 2014 16:56:24 +0200
Message-Id: <1399560990-1402858-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hvimhkRqb2KVvDU7KFPrrfawPyPyM6auvpE/akwRNeo
 Hr46NzaX1hLNUYhztyyPDTBBLCsBjtQjtipvFBqAVEdnZq1ar0
 BFiKO30VvH9tAt9f1Sil/YEo18clqGG+w4OXSoyKsJlsaNb25V
 Rm8hmTUe9fdqkt5rwgA31ssrlvh4jBBmRPcvlSlA7pPswPwqDR
 tqWo2GMWPGhmKxsv+VD1KPH15Sl8fUXGURgugMC9gzOWuZ0cjn
 toep21WX8VUAGCsImIlabCoCS1aaXmDs3z/d0TtuwOklpuj6SN
 +IH+qV09WT8dgeRq1Ev+AZ7oL0PUoWnT4d98CNZlXYmqaGKJuW
 Hrh9PsIHS/WyxpdaJ4RLPJU97M3cdfLXvcAwUlz2/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the at91 adc driver with CONFIG_INPUT disabled results in this
build error:

ERROR: "input_event" [drivers/iio/adc/at91_adc.ko] undefined!
ERROR: "input_unregister_device" [drivers/iio/adc/at91_adc.ko] undefined!
ERROR: "input_free_device" [drivers/iio/adc/at91_adc.ko] undefined!
ERROR: "input_register_device" [drivers/iio/adc/at91_adc.ko] undefined!
ERROR: "input_set_abs_params" [drivers/iio/adc/at91_adc.ko] undefined!
ERROR: "input_allocate_device" [drivers/iio/adc/at91_adc.ko] undefined!

To make sure we can build random configurations, this turns on CONFIG_INPUT
whenever CONFIG_AT91_ADC is enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-iio@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 90f596d..a80d236 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -110,6 +110,7 @@ config AD799X
 config AT91_ADC
 	tristate "Atmel AT91 ADC"
 	depends on ARCH_AT91
+	depends on INPUT
 	select IIO_BUFFER
 	select IIO_TRIGGERED_BUFFER
 	select SYSFS
-- 
1.8.3.2

