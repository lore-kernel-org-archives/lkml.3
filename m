Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaLVQ2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:28:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24472 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaLVQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:36 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-74-549846b00c8c
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Kamil Debski <k.debski@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, Lukasz Majewski <l.majewski@majess.pl>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 2/8] thermal: Provide stub for thermal_cdev_update() function
Date: Mon, 22 Dec 2014 17:27:42 +0100
Message-id: <1419265668-32283-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd0NbjNCDG7ONrZ4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsniy
	8AyTxZ1pe9ksDr9pZ3Xg99g56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7F
	ZZOSmpNZllqkb5fAlXF9633Ggna+imd9j9kbGL9xdzFyckgImEgcPHyOEcIWk7hwbz1bFyMX
	h5DAIkaJwyu3MkI4XUwSN7fdYwapYhPQk/h89ykTSEJEYAajxP6mb+wgDrPAFWaJb6caWUCq
	hAUCJLrPLmMDsVkEVCXeT1kJVMTBwSvgJrF2txPEOkWJ7mcT2EDCnALuEr9f8UIsa2aUOLWg
	kXkCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFh+0x6B+OqBotDjAIcjEo8vJxp
	00OEWBPLiitzDzFKcDArifBetZwRIsSbklhZlVqUH19UmpNafIhRmoNFSZxXyb4tREggPbEk
	NTs1tSC1CCbLxMEp1cAopfr7Gdvx7cGi4n4f9LYvefHx+Zc6rWN87KbN9WafGrjjH33Ybu7V
	e/nyptszpptu+XNtcqjtH+2P/7Mfnj0+qdEyu0V72hEF1Rlr21ullAylVtjLO57Tb37286VE
	jIh3vOMX+fW7rxalT1WboyQabmdd1euT2bFAovb379A77ovyZuw2+bFfiaU4I9FQi7moOBEA
	xFoOqFcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odroid U3 fan can work without being registered as OF cooling device
(with CONFIG_THERMAL_OF disabled).
In this situation it can be controlled via PWM entry at
/sys/class/hwmon/hwmon0/pwm1.

Therefore, the thermal_cdev_update() function needs a stub
to allow clean compilation.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- New patch
---
 include/linux/thermal.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 871123c..b3515b5 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -332,6 +332,7 @@ struct thermal_cooling_device *
 thermal_of_cooling_device_register(struct device_node *np,
 				   char *type, void *devdata,
 				   const struct thermal_cooling_device_ops *);
+void thermal_cdev_update(struct thermal_cooling_device *);
 #else
 static inline struct thermal_zone_device *
 thermal_zone_of_sensor_register(struct device *dev, int id, void *data,
@@ -353,6 +354,10 @@ thermal_of_cooling_device_register(struct device_node *np,
 {
 	return NULL;
 }
+
+static inline void thermal_cdev_update(struct thermal_cooling_device *cdev)
+{
+}
 #endif
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
 		void *, struct thermal_zone_device_ops *,
@@ -375,7 +380,6 @@ int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp);
 int get_tz_trend(struct thermal_zone_device *, int);
 struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
 		struct thermal_cooling_device *, int);
-void thermal_cdev_update(struct thermal_cooling_device *);
 void thermal_notify_framework(struct thermal_zone_device *, int);
 
 #ifdef CONFIG_NET
-- 
2.0.0.rc2

