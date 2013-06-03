Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3FNFQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:16:10 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54546 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3FNFQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:16:08 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: giometti@linux.it
Cc: linux-kernel@vger.kernel.org, koen.kooi@gmail.com,
        pantelis.antoniou@gmail.com, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH] tsl2550: fix lux1_input error in low light
Date: Mon,  3 Jun 2013 22:38:49 +0000
Message-Id: <1370299129-29199-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.2.rc3.6.g407929c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADC channel 0 photodiode detects both infrared + visible light,
but ADC channel 1 just detects infrared. However, the latter is a bit
more sensitive in that range so complete darkness or low light causes
a error condition in which the chan0 - chan1 is negative that
results in a -EAGAIN.

This patch changes the resulting lux1_input sysfs attribute message from
"Resource temporarily unavailable" to a user-grokable lux value of 0.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 drivers/misc/tsl2550.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
index 1dfde4d..e58620b 100644
--- a/drivers/misc/tsl2550.c
+++ b/drivers/misc/tsl2550.c
@@ -178,7 +178,7 @@ static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
 		} else
 			lux = 0;
 	else
-		return -EAGAIN;
+		return 0;
 
 	/* LUX range check */
 	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
-- 
1.8.2.rc3.6.g407929c

