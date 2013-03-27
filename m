Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3C0HQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:16:27 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45464 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3C0HQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:16:26 -0400
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        cbou@mail.ru, dwmw2@infradead.org
Cc: linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, Hongbo Zhang <hongbo.zhang@linaro.org>
Subject: [PATCH v7 1/5] ab8500_btemp: make ab8500_btemp_get* interfaces public
Date: Wed, 27 Mar 2013 15:13:28 +0800
Message-Id: <1364368412-12810-2-git-send-email-hongbo.zhang@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
References: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ab8500_btemp_get_temp interface public, export it and also export the
ab8500_btemp_get, ab8500_btemp_get_batctrl_temp interfaces, so that the ab8500
hwmon driver can use them.

Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
Acked-by: Anton Vorontsov <anton@enomsg.org>
---
 drivers/power/ab8500_btemp.c         | 5 ++++-
 include/linux/mfd/abx500/ab8500-bm.h | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 20e2a7d..3359075 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -123,6 +123,7 @@ struct ab8500_btemp *ab8500_btemp_get(void)
 
 	return btemp;
 }
+EXPORT_SYMBOL(ab8500_btemp_get);
 
 /**
  * ab8500_btemp_batctrl_volt_to_res() - convert batctrl voltage to resistance
@@ -727,7 +728,7 @@ static void ab8500_btemp_periodic(struct ab8500_btemp *di,
  *
  * Returns battery temperature
  */
-static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
+int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 {
 	int temp = 0;
 
@@ -763,6 +764,7 @@ static int ab8500_btemp_get_temp(struct ab8500_btemp *di)
 	}
 	return temp;
 }
+EXPORT_SYMBOL(ab8500_btemp_get_temp);
 
 /**
  * ab8500_btemp_get_batctrl_temp() - get the temperature
@@ -774,6 +776,7 @@ int ab8500_btemp_get_batctrl_temp(struct ab8500_btemp *btemp)
 {
 	return btemp->bat_temp * 1000;
 }
+EXPORT_SYMBOL(ab8500_btemp_get_batctrl_temp);
 
 /**
  * ab8500_btemp_get_property() - get the btemp properties
diff --git a/include/linux/mfd/abx500/ab8500-bm.h b/include/linux/mfd/abx500/ab8500-bm.h
index 44310c9..4dd79f6 100644
--- a/include/linux/mfd/abx500/ab8500-bm.h
+++ b/include/linux/mfd/abx500/ab8500-bm.h
@@ -427,6 +427,7 @@ void ab8500_fg_reinit(void);
 void ab8500_charger_usb_state_changed(u8 bm_usb_state, u16 mA);
 struct ab8500_btemp *ab8500_btemp_get(void);
 int ab8500_btemp_get_batctrl_temp(struct ab8500_btemp *btemp);
+int ab8500_btemp_get_temp(struct ab8500_btemp *btemp);
 struct ab8500_fg *ab8500_fg_get(void);
 int ab8500_fg_inst_curr_blocking(struct ab8500_fg *dev);
 int ab8500_fg_inst_curr_start(struct ab8500_fg *di);
@@ -451,6 +452,10 @@ static int ab8500_btemp_get_batctrl_temp(struct ab8500_btemp *btemp)
 {
 	return 0;
 }
+static int ab8500_btemp_get_temp(struct ab8500_btemp *btemp)
+{
+	return 0;
+}
 struct ab8500_fg *ab8500_fg_get(void)
 {
 	return NULL;
-- 
1.8.0

