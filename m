Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaKWQko (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:40:44 -0500
Received: from mout.web.de ([212.227.15.4]:63873 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaKWQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:40:41 -0500
Message-ID: <54720DEB.4060109@users.sourceforge.net>
Date: Sun, 23 Nov 2014 17:40:11 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] backlight: lp8788: Deletion of an unnecessary check before
 the function call "backlight_device_unregister"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:oEfsIkn5ILx5q52ya2o4f58FKTv4fhv6V0dhou7HYaguKYLqNCW
 OFQiO4HFIt5vEMq1mtDT1itAIEzsCw/qeFpY5xZbFV3/5sRFROh3BdMOJEMs59c4QLPYPvp
 AUgirEPOdL60f52KdJbU5JJqpvdIMyB3j3uMQN7eB1TyYDfWSSd1ga4kkEpIHASJbza9J3D
 m0+OHOjXiwwx36xJXqdcw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 17:33:08 +0100

The backlight_device_unregister() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/backlight/lp8788_bl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index d6c4f6a..24a055c 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -221,8 +221,7 @@ static void lp8788_backlight_unregister(struct lp8788_bl *bl)
 {
 	struct backlight_device *bl_dev = bl->bl_dev;
 
-	if (bl_dev)
-		backlight_device_unregister(bl_dev);
+	backlight_device_unregister(bl_dev);
 }
 
 static ssize_t lp8788_get_bl_ctl_mode(struct device *dev,
-- 
2.1.3

