Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaEHNw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:52:59 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:51926 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaEHNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:52:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 1/8] usb/gadget: s3c2410_udc: don't use pr_debug return value
Date: Thu,  8 May 2014 15:52:14 +0200
Message-Id: <1399557141-1346645-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Akbpa5qCtjX8w3cmTKU3SIf3PhQtN5SlLdoKDEqG5VK
 rmJcBsVybQi45CHJgQQDddlTaT81cXzAQYsZfcxixIV2uLnrbr
 1qjsnfsrnguPdoYl87Pg9CxojIaHECQeN0h9Gdf5vGDvZkZQX+
 vdD6UmfC8K8zegntNC4lXiOGT6sluxK+6v92YEgZ6NNjJ6L0fL
 ENDeHQUZybH9takW4y8uD3KMWBHdSpCONyVnW0H9MlZH+abLqo
 GAwbkycTflK4erdeqmKE5zZbV/WPz/0KdyYluN/gnM1HQuUqBc
 l9GZSNvcU0eLmllA4VPL3UQDmENhpWT0095eAKh5R708+96MCC
 NAQrhG4oSzzvQpU3582oMaApQZWQqQMvVZUWDkKLk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_debug() may be defined as "do { } while (0)" in some configurations,
which means one cannot rely on the return value to be available.

In the dprintk function in this driver, we can work around the
resulting build error trivially by returning the length that
this function already knows and ignoring the return value of
pr_debug.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
---
 drivers/usb/gadget/s3c2410_udc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index dd9678f..7987aa0 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -117,7 +117,8 @@ static int dprintk(int level, const char *fmt, ...)
 			sizeof(printk_buf)-len, fmt, args);
 	va_end(args);
 
-	return pr_debug("%s", printk_buf);
+	pr_debug("%s", printk_buf);
+	return len;
 }
 #else
 static int dprintk(int level, const char *fmt, ...)
-- 
1.8.3.2

