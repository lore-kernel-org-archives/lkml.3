Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaFYRK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:10:57 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:54746 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbaFYRJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:57 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 12/13] leds: lp55xx-common: fix sysfs entry leak
Date: Wed, 25 Jun 2014 19:08:55 +0200
Message-Id: <1403716136-32694-13-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the sysfs group is removed when the LEDs are unregistered.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-lp55xx-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 88317b4f7bf3..3fbfb31602c7 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -520,6 +520,8 @@ void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
 
 	for (i = 0; i < chip->num_leds; i++) {
 		each = led + i;
+		sysfs_remove_group(&each->cdev.dev->kobj,
+						&lp55xx_led_attr_group);
 		led_classdev_unregister(&each->cdev);
 		flush_work(&each->brightness_work);
 	}
-- 
1.8.5.5

