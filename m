Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3IJQmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:42:05 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:35305 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3IJQmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:42:02 -0400
From: Ben Gardiner <ben.l.gardiner@gmail.com>
To: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org
Cc: Johan Rudholm <johan.rudholm@stericsson.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: core: make SPI CRC flag readable from /sys/module
Date: Tue, 10 Sep 2013 12:41:53 -0400
Message-Id: <1378831313-28089-1-git-send-email-ben.l.gardiner@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the use_spi_crc module parameter read only in sysfs.

Signed-off-by: Ben Gardiner <ben.l.gardiner@gmail.com>
---
 drivers/mmc/core/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 49a5bca..93f64b3 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -60,7 +60,7 @@ static const unsigned freqs[] = { 400000, 300000, 200000, 100000 };
  * So we allow it it to be disabled.
  */
 bool use_spi_crc = 1;
-module_param(use_spi_crc, bool, 0);
+module_param(use_spi_crc, bool, 0444);
 
 /*
  * We normally treat cards as removed during suspend if they are not
-- 
1.8.1.2

