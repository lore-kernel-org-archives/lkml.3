Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaGOOSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:18:08 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50089 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaGOOSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:18:06 -0400
Message-ID: <53B95102.3030001@gmail.com>
Date: Sun, 06 Jul 2014 21:37:06 +0800
From: vv <zhengdi05@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com, zhengdi05@gmail.com
Subject: [PATCH]staging: media: lirc_parallel.c: fix coding style
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9d2c680fb573985588d33e31379d50ef3fb6e2fd Mon Sep 17 00:00:00 2001
From: Zheng Di <zhengdi05@gmail.com>
Date: Sun, 6 Jul 2014 20:41:53 +0800
Subject: [PATCH] staging: media: lirc_parallel.c: fix coding style

This patch fix checkpatch:
WARNING: else is not generally useful after a break or return
WARNING: line over 80 characters

Signed-off-by: Zheng Di <zhengdi05@gmail.com>
---
 drivers/staging/media/lirc/lirc_parallel.c |   32
++++++++++++++--------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c
b/drivers/staging/media/lirc/lirc_parallel.c
index 1394f02..d7eb2a4 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -169,23 +169,23 @@ static unsigned int init_lirc_timer(void)
            newtimer = (1000000*count)/timeelapsed;
            pr_info("%u Hz timer detected\n", newtimer);
            return newtimer;
-       }  else {
-           newtimer = (1000000*count)/timeelapsed;
-           if (abs(newtimer - default_timer) > default_timer/10) {
-               /* bad timer */
-               pr_notice("bad timer: %u Hz\n", newtimer);
-               pr_notice("using default timer: %u Hz\n",
-                     default_timer);
-               return default_timer;
-           } else {
-               pr_info("%u Hz timer detected\n", newtimer);
-               return newtimer; /* use detected value */
-           }
        }
-   } else {
-       pr_notice("no timer detected\n");
-       return 0;
+
+       newtimer = (1000000*count)/timeelapsed;
+       if (abs(newtimer - default_timer) > default_timer/10) {
+           /* bad timer */
+           pr_notice("bad timer: %u Hz\n", newtimer);
+           pr_notice("using default timer: %u Hz\n",
+                 default_timer);
+           return default_timer;
+       }
+
+       pr_info("%u Hz timer detected\n", newtimer);
+       return newtimer; /* use detected value */
    }
+
+   pr_notice("no timer detected\n");
+   return 0;
 }

 static int lirc_claim(void)
@@ -661,7 +661,7 @@ static int __init lirc_parallel_init(void)
        goto exit_device_put;
    }
    ppdevice = parport_register_device(pport, LIRC_DRIVER_NAME,
-                      pf, kf, lirc_lirc_irq_handler, 0, NULL);
+                  pf, kf, lirc_lirc_irq_handler, 0, NULL);
    parport_put_port(pport);
    if (ppdevice == NULL) {
        pr_notice("parport_register_device() failed\n");
-- 
1.7.9.5
