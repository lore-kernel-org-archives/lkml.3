Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaKSRjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:39:05 -0500
Received: from mout.web.de ([212.227.15.4]:57447 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbaKSRjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:39:02 -0500
Message-ID: <546CD595.3090508@users.sourceforge.net>
Date: Wed, 19 Nov 2014 18:38:29 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] HID-picoLCD: Deletion of unnecessary checks before three
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:e2EXRj1yxJ2KwuZLKzPxFCSnJn+wDnjipVoDwb2y+8nGWcKQrxR
 3EdWvMFNpL8GH1CPhl3ZuhNdexdWHbYGln7PKZyJ2qUIVFobRY/edMg1oCDs45dMqZDmvf+
 Yws8qyvmZ3expmZbbZ2VrNg5UW46Q4alaeqxQXBUkagNj7U8d4nksYAt66cnSyIaE4aIZf1
 uDL/3tbUm7eoV9oCoLQyA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 18:30:22 +0100

The functions backlight_device_unregister(), lcd_device_unregister() and
rc_unregister_device() test whether their argument is NULL and then
return immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/hid/hid-picolcd_backlight.c | 3 +--
 drivers/hid/hid-picolcd_cir.c       | 3 +--
 drivers/hid/hid-picolcd_lcd.c       | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-picolcd_backlight.c b/drivers/hid/hid-picolcd_backlight.c
index a32c5f8..808807a 100644
--- a/drivers/hid/hid-picolcd_backlight.c
+++ b/drivers/hid/hid-picolcd_backlight.c
@@ -94,8 +94,7 @@ void picolcd_exit_backlight(struct picolcd_data *data)
 	struct backlight_device *bdev = data->backlight;
 
 	data->backlight = NULL;
-	if (bdev)
-		backlight_device_unregister(bdev);
+	backlight_device_unregister(bdev);
 }
 
 int picolcd_resume_backlight(struct picolcd_data *data)
diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
index 045f8eb..9628651 100644
--- a/drivers/hid/hid-picolcd_cir.c
+++ b/drivers/hid/hid-picolcd_cir.c
@@ -145,7 +145,6 @@ void picolcd_exit_cir(struct picolcd_data *data)
 	struct rc_dev *rdev = data->rc_dev;
 
 	data->rc_dev = NULL;
-	if (rdev)
-		rc_unregister_device(rdev);
+	rc_unregister_device(rdev);
 }
 
diff --git a/drivers/hid/hid-picolcd_lcd.c b/drivers/hid/hid-picolcd_lcd.c
index 89821c2..22dcbe1 100644
--- a/drivers/hid/hid-picolcd_lcd.c
+++ b/drivers/hid/hid-picolcd_lcd.c
@@ -92,8 +92,7 @@ void picolcd_exit_lcd(struct picolcd_data *data)
 	struct lcd_device *ldev = data->lcd;
 
 	data->lcd = NULL;
-	if (ldev)
-		lcd_device_unregister(ldev);
+	lcd_device_unregister(ldev);
 }
 
 int picolcd_resume_lcd(struct picolcd_data *data)
-- 
2.1.3

