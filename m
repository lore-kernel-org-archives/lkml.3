Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaBDG5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:57:43 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55840 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaBDG5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:57:36 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] spi: fix pointer-integer size mismatch warning
Date: Tue,  4 Feb 2014 15:58:09 +0900
Message-Id: <1391497089-6831-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the pointer-integer size mismatch warning below:
	drivers/spi/spi-gpio.c: In function ‘spi_gpio_setup’:
	drivers/spi/spi-gpio.c:252:8: warning: cast from pointer to integer of
			different size [-Wpointer-to-int-cast]
	   cs = (unsigned int) spi->controller_data;
	        ^

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/spi/spi-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index cfc9fb3..406bbd7 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -249,7 +249,7 @@ static int spi_gpio_setup(struct spi_device *spi)
 		/*
 		 * ... otherwise, take it from spi->controller_data
 		 */
-		cs = (unsigned int) spi->controller_data;
+		cs = (unsigned int)(uintptr_t) spi->controller_data;
 	}
 
 	if (!spi->controller_state) {
-- 
1.8.3.2

