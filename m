Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaGBP3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:29:42 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54399 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbaGBP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:29:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/12] mfd: 88pm805: msleep(1ms ~ 20ms) may not do what the caller intends
Date: Wed,  2 Jul 2014 16:28:39 +0100
Message-Id: <1404314924-23564-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
References: <1404314924-23564-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code has been working since 2012, as limiting the time between
1ms and 3ms is unlikely to do any harm.

Soothes checkpatch warning:

  WARNING: msleep < 20ms can sleep for up to 20ms;
      see Documentation/timers/timers-howto.txt
  #161: FILE: drivers/mfd/88pm805.c:161:
  +	msleep(1);

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/88pm805.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 64751c2..e9d5064 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -158,7 +158,7 @@ static int device_irq_init_805(struct pm80x_chip *chip)
 	 * PM805_INT_STATUS is under 32K clock domain, so need to
 	 * add proper delay before the next I2C register access.
 	 */
-	msleep(1);
+	usleep_range(1000, 3000);
 
 	if (ret < 0)
 		goto out;
-- 
1.8.3.2

