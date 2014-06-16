Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaFPVMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:12:31 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:62165 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaFPVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:12:29 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, Andrew Bresticker <abrestic@chromium.org>,
        swarren@wwwdotorg.org, olof@lixom.net,
        Sonny Rao <sonnyrao@chromium.org>, linux-samsung-soc@vger.kernel.org,
        Prathyush K <prathyush.k@samsung.com>,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: cros_ec_spi: set wakeup capability
Date: Mon, 16 Jun 2014 14:12:23 -0700
Message-Id: <1402953143-24681-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prathyush K <prathyush.k@samsung.com>

Set the device as wakeup capable and register the wakeup source.

Note: Though it makes more sense to have the SPI framework do this,
(either via device tree or by board_info)
this change is as per an existing mail chain:
https://lkml.org/lkml/2009/8/27/291

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Note that I don't have suspend/resume actually working upstream, but I
see that /sys/bus/spi/drivers/cros-ec-spi/spi2.0/power/wakeup exists
with this patch and doesn't exist without it.

 drivers/mfd/cros_ec_spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 0b8d328..ef22dd5 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -385,6 +385,8 @@ static int cros_ec_spi_probe(struct spi_device *spi)
 		return err;
 	}
 
+	device_init_wakeup(&spi->dev, true);
+
 	return 0;
 }
 
-- 
2.0.0.526.g5318336

