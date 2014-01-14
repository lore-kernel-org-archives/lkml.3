Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaANPq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:46:28 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1679 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751962AbaANPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:46:21 -0500
From: Richard Weinberger <richard@nod.at>
To: kishon@ti.com, anton@enomsg.org, dwmw2@infradead.org,
        richardcochran@gmail.com, lidza.louina@gmail.com,
        gregkh@linuxfoundation.org, jic23@kernel.org, davem@davemloft.net
Cc: sebastian.hesselbarth@gmail.com, florian@openwrt.org,
        thomas.petazzoni@free-electrons.com, lars@metafoo.de, marex@denx.de,
        acourbot@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-iio@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] staging,lpc32xx_adc: Add dependency on HAS_IOMEM
Date: Tue, 14 Jan 2014 16:45:45 +0100
Message-Id: <1389714345-20165-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389714345-20165-1-git-send-email-richard@nod.at>
References: <1389714345-20165-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On archs like S390 or um this driver cannot build nor work.
Make it depend on HAS_IOMEM to bypass build failures.

drivers/built-in.o: In function `lpc32xx_adc_probe':
drivers/staging/iio/adc/lpc32xx_adc.c:149: undefined reference to `devm_ioremap'

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/staging/iio/adc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index 7d5d675..3633298 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -103,6 +103,7 @@ config AD7280
 config LPC32XX_ADC
 	tristate "NXP LPC32XX ADC"
 	depends on ARCH_LPC32XX || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Say yes here to build support for the integrated ADC inside the
 	  LPC32XX SoC. Note that this feature uses the same hardware as the
-- 
1.8.1.4

