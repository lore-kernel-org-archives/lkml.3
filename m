Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaGMLou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 07:44:50 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52947 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaGMLom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 07:44:42 -0400
Message-ID: <53C27126.50208@gmail.com>
Date: Sun, 13 Jul 2014 19:44:38 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: jic23@kernel.org
CC: Richard Weinberger <richard@nod.at>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lars@metafoo.de,
        knaack.h@gmx.de, Marek Vasut <marex@denx.de>, rdunlap@infradead.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/staging/iio/adc/Kconfig: Let MXS_LRADC depend on
 HAS_IOMEM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MXS_LRADC need HAS_IOMEM, so let it depend on HAS_IOMEM

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "devm_ioremap_resource" [drivers/staging/iio/adc/mxs-lradc.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/staging/iio/adc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index b87e382..4e927d2 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -94,7 +94,7 @@ config LPC32XX_ADC
 
 config MXS_LRADC
 	tristate "Freescale i.MX23/i.MX28 LRADC"
-	depends on ARCH_MXS || COMPILE_TEST
+	depends on (ARCH_MXS || COMPILE_TEST) && HAS_IOMEM
 	depends on INPUT
 	select STMP_DEVICE
 	select IIO_BUFFER
-- 
1.7.11.7
