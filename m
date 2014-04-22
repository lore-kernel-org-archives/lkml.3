Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaDVAEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:04:12 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63335 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaDVAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:04:06 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Cc: Milo.Kim@ti.com, Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Doug Anderson <dianders@chromium.org>, lee.jones@linaro.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com,
        alexandre.belloni@free-electrons.com, oleksandr.kozaruk@ti.com,
        B38611@freescale.com, johannes.thumshirn@men.de, sre@debian.org,
        sachin.kamat@linaro.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: Nothing in ADC should be a bool CONFIG
Date: Mon, 21 Apr 2014 17:03:51 -0700
Message-Id: <1398125031-5826-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole IIO subsystem can be moved to a module.  If you make it a
module then stuff marked as "Y" in the adc directory simply won't be
linked in properly.

The two configs that were wrong were EXYNOS_ADC and LP8788_ADC.  I
know for a fact that EXYNOS_ADC will work as a module (though it
appears to crash when you unload it--that needs to be addressed
separately).  I assume LP8788_ADC will also be fine..

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/iio/adc/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index d86196c..24c28e3 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -106,7 +106,7 @@ config AT91_ADC
 	  Say yes here to build support for Atmel AT91 ADC.
 
 config EXYNOS_ADC
-	bool "Exynos ADC driver support"
+	tristate "Exynos ADC driver support"
 	depends on OF
 	help
 	  Core support for the ADC block found in the Samsung EXYNOS series
@@ -114,7 +114,7 @@ config EXYNOS_ADC
 	  this resource.
 
 config LP8788_ADC
-	bool "LP8788 ADC driver"
+	tristate "LP8788 ADC driver"
 	depends on MFD_LP8788
 	help
 	  Say yes here to build support for TI LP8788 ADC.
-- 
1.9.1.423.g4596e3a

