Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3EZSHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 14:07:07 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40986 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3EZSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 14:07:05 -0400
From: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH] w1: add family based automatic module loading
Date: Sun, 26 May 2013 20:06:50 +0200
Message-Id: <1369591610-7588-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
X-Mailer: git-send-email 1.8.2.1
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1369591619-000004FE-0850016D/0-0/0-0
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-05-26 20:06:59;adb7588065d099bde973967e624a6a21
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-05-26 20:07:01;8a0c830b6afc243b3095cb2db7c8ff6a
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 TVD_RCVD_IP TVD_RCVD_IP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the 1-wire bus to autoload the corresponding module
for each slave being attached.
This works similar to bluetooth protocols.

Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
---
 Documentation/w1/w1.generic    | 4 ++--
 drivers/w1/slaves/w1_ds2408.c  | 1 +
 drivers/w1/slaves/w1_ds2413.c  | 1 +
 drivers/w1/slaves/w1_ds2423.c  | 1 +
 drivers/w1/slaves/w1_ds2431.c  | 1 +
 drivers/w1/slaves/w1_ds2433.c  | 1 +
 drivers/w1/slaves/w1_ds2760.c  | 1 +
 drivers/w1/slaves/w1_ds2780.c  | 1 +
 drivers/w1/slaves/w1_ds2781.c  | 1 +
 drivers/w1/slaves/w1_ds28e04.c | 1 +
 drivers/w1/slaves/w1_smem.c    | 2 ++
 drivers/w1/slaves/w1_therm.c   | 5 +++++
 drivers/w1/w1.c                | 2 ++
 13 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/w1/w1.generic b/Documentation/w1/w1.generic
index 212f4ac..a31c5a2 100644
--- a/Documentation/w1/w1.generic
+++ b/Documentation/w1/w1.generic
@@ -25,8 +25,8 @@ When a w1 master driver registers with the w1 subsystem, the following occurs:
  - sysfs entries for that w1 master are created
  - the w1 bus is periodically searched for new slave devices
 
-When a device is found on the bus, w1 core checks if driver for its family is
-loaded. If so, the family driver is attached to the slave.
+When a device is found on the bus, w1 core tries to load the driver for its family
+and check if it is loaded. If so, the family driver is attached to the slave.
 If there is no driver for the family, default one is assigned, which allows to perform
 almost any kind of operations. Each logical operation is a transaction
 in nature, which can contain several (two or one) low-level operations.
diff --git a/drivers/w1/slaves/w1_ds2408.c b/drivers/w1/slaves/w1_ds2408.c
index e45eca1..91cc2cd 100644
--- a/drivers/w1/slaves/w1_ds2408.c
+++ b/drivers/w1/slaves/w1_ds2408.c
@@ -22,6 +22,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jean-Francois Dagenais <dagenaisj@sonatest.com>");
 MODULE_DESCRIPTION("w1 family 29 driver for DS2408 8 Pin IO");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2408));
 
 
 #define W1_F29_RETRIES		3
diff --git a/drivers/w1/slaves/w1_ds2413.c b/drivers/w1/slaves/w1_ds2413.c
index 8297862..8593777 100644
--- a/drivers/w1/slaves/w1_ds2413.c
+++ b/drivers/w1/slaves/w1_ds2413.c
@@ -23,6 +23,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mariusz Bialonczyk <manio@skyboo.net>");
 MODULE_DESCRIPTION("w1 family 3a driver for DS2413 2 Pin IO");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2413));
 
 #define W1_F3A_RETRIES                     3
 #define W1_F3A_FUNC_PIO_ACCESS_READ        0xF5
diff --git a/drivers/w1/slaves/w1_ds2423.c b/drivers/w1/slaves/w1_ds2423.c
index 40a10b5..7f86aec 100644
--- a/drivers/w1/slaves/w1_ds2423.c
+++ b/drivers/w1/slaves/w1_ds2423.c
@@ -164,3 +164,4 @@ module_exit(w1_f1d_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mika Laitio <lamikr@pilppa.org>");
 MODULE_DESCRIPTION("w1 family 1d driver for DS2423, 4 counters and 4kb ram");
+MODULE_ALIAS("w1-family-" __stringify(W1_COUNTER_DS2423));
diff --git a/drivers/w1/slaves/w1_ds2431.c b/drivers/w1/slaves/w1_ds2431.c
index 984b303..cef8605 100644
--- a/drivers/w1/slaves/w1_ds2431.c
+++ b/drivers/w1/slaves/w1_ds2431.c
@@ -310,3 +310,4 @@ module_exit(w1_f2d_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bernhard Weirich <bernhard.weirich@riedel.net>");
 MODULE_DESCRIPTION("w1 family 2d driver for DS2431, 1kb EEPROM");
+MODULE_ALIAS("w1-family-" __stringify(W1_EEPROM_DS2431));
diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 85f2cdb..10cc1b6 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -29,6 +29,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
 MODULE_DESCRIPTION("w1 family 23 driver for DS2433, 4kb EEPROM");
+MODULE_ALIAS("w1-family-" __stringify(W1_EEPROM_DS2433));
 
 #define W1_EEPROM_SIZE		512
 #define W1_PAGE_COUNT		16
diff --git a/drivers/w1/slaves/w1_ds2760.c b/drivers/w1/slaves/w1_ds2760.c
index e86a69d..93719d2 100644
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -203,3 +203,4 @@ module_exit(w1_ds2760_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>");
 MODULE_DESCRIPTION("1-wire Driver Dallas 2760 battery monitor chip");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2760));
diff --git a/drivers/w1/slaves/w1_ds2780.c b/drivers/w1/slaves/w1_ds2780.c
index 98ed9c4..0cd7a27 100644
--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -188,3 +188,4 @@ module_exit(w1_ds2780_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
 MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2780 Stand-Alone Fuel Gauge IC");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2780));
diff --git a/drivers/w1/slaves/w1_ds2781.c b/drivers/w1/slaves/w1_ds2781.c
index 5140d7b..1aba8e4 100644
--- a/drivers/w1/slaves/w1_ds2781.c
+++ b/drivers/w1/slaves/w1_ds2781.c
@@ -186,3 +186,4 @@ module_exit(w1_ds2781_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Renata Sayakhova <renata@oktetlabs.ru>");
 MODULE_DESCRIPTION("1-wire Driver for Maxim/Dallas DS2781 Stand-Alone Fuel Gauge IC");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS2781));
diff --git a/drivers/w1/slaves/w1_ds28e04.c b/drivers/w1/slaves/w1_ds28e04.c
index 98117db..cd30a6d 100644
--- a/drivers/w1/slaves/w1_ds28e04.c
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -27,6 +27,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Markus Franke <franke.m@sebakmt.com>, <franm@hrz.tu-chemnitz.de>");
 MODULE_DESCRIPTION("w1 family 1C driver for DS28E04, 4kb EEPROM and PIO");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_DS28E04));
 
 /* Allow the strong pullup to be disabled, but default to enabled.
  * If it was disabled a parasite powered device might not get the required
diff --git a/drivers/w1/slaves/w1_smem.c b/drivers/w1/slaves/w1_smem.c
index 8465562..ed4c875 100644
--- a/drivers/w1/slaves/w1_smem.c
+++ b/drivers/w1/slaves/w1_smem.c
@@ -34,6 +34,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, 64bit memory family.");
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_SMEM_01));
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_SMEM_81));
 
 static struct w1_family w1_smem_family_01 = {
 	.fid = W1_FAMILY_SMEM_01,
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index c1a702f..8978360 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -36,6 +36,11 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <zbr@ioremap.net>");
 MODULE_DESCRIPTION("Driver for 1-wire Dallas network protocol, temperature family.");
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS18S20));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS1822));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS18B20));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS1825));
+MODULE_ALIAS("w1-family-" __stringify(W1_THERM_DS28EA00));
 
 /* Allow the strong pullup to be disabled, but default to enabled.
  * If it was disabled a parasite powered device might not get the require
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 7ce277d..0459df8 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -680,6 +680,8 @@ static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
 	atomic_set(&sl->refcnt, 0);
 	init_completion(&sl->released);
 
+	request_module("w1-family-0x%0x", rn->family);
+
 	spin_lock(&w1_flock);
 	f = w1_family_registered(rn->family);
 	if (!f) {
-- 
1.8.2.1

