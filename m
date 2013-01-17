Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab3AQBG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:06:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59006 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab3AQBGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:06:25 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] leds: name change on the list of LED trigger
Thread-Topic: [PATCH 2/2] leds: name change on the list of LED trigger
Thread-Index: Ac30TtyDgQ55gRJBSfebghIluq6fmw==
Date: Thu, 17 Jan 2013 01:06:21 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E18708@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use general name, 'list' rather than 'next_trig'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/led-triggers.c |   12 ++++++------
 include/linux/leds.h        |    3 +--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 5aa0252..8ebef27 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -52,7 +52,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	down_read(&triggers_list_lock);
-	list_for_each_entry(trig, &trigger_list, next_trig) {
+	list_for_each_entry(trig, &trigger_list, list) {
 		if (!strcmp(trigger_name, trig->name)) {
 			down_write(&led_cdev->trigger_lock);
 			led_trigger_set(led_cdev, trig);
@@ -83,7 +83,7 @@ ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
 	else
 		len += sprintf(buf+len, "none ");
 
-	list_for_each_entry(trig, &trigger_list, next_trig) {
+	list_for_each_entry(trig, &trigger_list, list) {
 		if (led_cdev->trigger && !strcmp(led_cdev->trigger->name,
 							trig->name))
 			len += sprintf(buf+len, "[%s] ", trig->name);
@@ -149,7 +149,7 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
 
 	down_read(&triggers_list_lock);
 	down_write(&led_cdev->trigger_lock);
-	list_for_each_entry(trig, &trigger_list, next_trig) {
+	list_for_each_entry(trig, &trigger_list, list) {
 		if (!strcmp(led_cdev->default_trigger, trig->name))
 			led_trigger_set(led_cdev, trig);
 	}
@@ -182,14 +182,14 @@ int led_trigger_register(struct led_trigger *trig)
 
 	down_write(&triggers_list_lock);
 	/* Make sure the trigger's name isn't already in use */
-	list_for_each_entry(_trig, &trigger_list, next_trig) {
+	list_for_each_entry(_trig, &trigger_list, list) {
 		if (!strcmp(_trig->name, trig->name)) {
 			up_write(&triggers_list_lock);
 			return -EEXIST;
 		}
 	}
 	/* Add to the list of led triggers */
-	list_add_tail(&trig->next_trig, &trigger_list);
+	list_add_tail(&trig->list, &trigger_list);
 	up_write(&triggers_list_lock);
 
 	/* Register with any LEDs that have this as a default trigger */
@@ -213,7 +213,7 @@ void led_trigger_unregister(struct led_trigger *trig)
 
 	/* Remove from the list of led triggers */
 	down_write(&triggers_list_lock);
-	list_del(&trig->next_trig);
+	list_del(&trig->list);
 	up_write(&triggers_list_lock);
 
 	/* Remove anyone actively using this trigger */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 4c593c6..1c107b3 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -154,8 +154,7 @@ struct led_trigger {
 	/* LEDs under control by this trigger (for simple triggers) */
 	rwlock_t	  leddev_list_lock;
 
-	/* Link to next registered trigger */
-	struct list_head  next_trig;
+	struct list_head  list;
 };
 
 /* Registration functions for complex triggers */
-- 
1.7.9.5


Best Regards,
Milo


