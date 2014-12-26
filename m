Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaLZOtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:49:20 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4736 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885AbaLZOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:42:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,647,1413237600"; 
   d="scan'208";a="114895464"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Bryan Wu <cooloney@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/27] leds: Use setup_timer
Date: Fri, 26 Dec 2014 15:35:45 +0100
Message-Id: <1419604558-29743-15-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419604558-29743-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression t,f,d;
@@

-init_timer(&t);
+setup_timer(&t,f,d);
-t.function = f;
-t.data = d;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/leds/led-class.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index dbeebac..291ca45 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -239,9 +239,8 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 
 	INIT_WORK(&led_cdev->set_brightness_work, set_brightness_delayed);
 
-	init_timer(&led_cdev->blink_timer);
-	led_cdev->blink_timer.function = led_timer_function;
-	led_cdev->blink_timer.data = (unsigned long)led_cdev;
+	setup_timer(&led_cdev->blink_timer, led_timer_function,
+		    (unsigned long)led_cdev);
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_set_default(led_cdev);

