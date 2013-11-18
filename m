Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab3KRKcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:32:24 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:63907 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3KRKbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:31:16 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH 2/3] mfd: cros ec: spi: Increase EC transaction delay
Date: Mon, 18 Nov 2013 11:30:48 +0100
Message-Id: <1384770649-8593-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384770649-8593-1-git-send-email-treding@nvidia.com>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Derek Basehore <dbasehore@chromium.org>

50 us is not a long enough delay between EC transactions. At least 70 us
are needed for the 16 MHz STM32L part. Increase the delay to 200 us for
an extra safety margin.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Randall Spangler <rspangler@chromium.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mfd/cros_ec_spi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index d05349a7381e..af5c2f6601cf 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -51,10 +51,11 @@
 /*
   * Time between raising the SPI chip select (for the end of a
   * transaction) and dropping it again (for the next transaction).
-  * If we go too fast, the EC will miss the transaction. It seems
-  * that 50us is enough with the 16MHz STM32 EC.
+  * If we go too fast, the EC will miss the transaction. We know that we
+  * need at least 70 us with the 16 MHz STM32 EC, so go with 200 us to be
+  * safe.
   */
-#define EC_SPI_RECOVERY_TIME_NS	(50 * 1000)
+#define EC_SPI_RECOVERY_TIME_NS	(200 * 1000)
 
 /**
  * struct cros_ec_spi - information about a SPI-connected EC
-- 
1.8.4.2

