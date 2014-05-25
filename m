Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaEYNJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 09:09:09 -0400
Received: from mout.gmx.net ([212.227.17.20]:56578 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaEYNJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 09:09:07 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: gregkh@linuxfoundation.org
Cc: peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        khoroshilov@ispras.ru, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] gdm72xx: use time_before()
Date: Sun, 25 May 2014 15:08:59 +0200
Message-Id: <1401023339-29712-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:Hjyxylgr1p5B7SkJTEMYsskwMfLynEwLWjU9RE8y0cib/r14jdu
 Uub+5C/IjsOAjdSDa4ka1mgrzxuzymC2BvnpUTh31M4mDztU7koBWsPwYEaeY1UgxLwg+fd
 JbACJy1Z4dftuKXloIyQ8si04dE4sia12EE1d2JeGiI3PC41b5/FNuCgm230fOAAyriPEWw
 xW5VqGSfP7VcRhSF0B+nA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/staging/gdm72xx/gdm_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 20539d8..9ddf8f5 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -730,7 +730,7 @@ static int k_mode_thread(void *arg)
 			spin_unlock_irqrestore(&k_lock, flags2);
 
 			expire = jiffies + K_WAIT_TIME;
-			while (jiffies < expire)
+			while (time_before(jiffies, expire))
 				schedule_timeout(K_WAIT_TIME);
 
 			spin_lock_irqsave(&rx->lock, flags);
-- 
1.7.10.4

