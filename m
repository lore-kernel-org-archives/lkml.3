Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaLRKNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:13:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11328 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaLRKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:13:43 -0500
X-AuditID: cbfee61a-f79c06d000004e71-3b-5492a8d4d7ff
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
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 1/9] thermal: Provide stub for
 thermal_of_cooling_device_register() function
Date: Thu, 18 Dec 2014 11:13:03 +0100
Message-id: <1418897591-18332-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd0rKyaFGJxbaWUx/8g5Vov5V66x
	Wiy9+4nN4sfrC2wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaDHj/D4miycLzzBZ3Jm2l83i
	8Jt2Vgdej52z7rJ7PJi4m81j3bS3zB47vzewe/RtWcXosfl0tcfnTXIB7FFcNimpOZllqUX6
	dglcGZs7zzEWPBSsWLQpuIGxk7+LkZNDQsBE4uipW2wQtpjEhXvrgWwuDiGB6YwSd1ceZIVw
	upgkXhxtZwapYhPQk/h89ykTSEJEYAajxP6mb+wgDrPAdyaJpq1LWUCqhAXiJB6dnw82l0VA
	VeL3t29gNq+Am8S+48sZIfYpSnQ/mwAW5xRwl5jzHMIWAqpp+nuJeQIj7wJGhlWMoqkFyQXF
	Sem5hnrFibnFpXnpesn5uZsYwUH6TGoH48oGi0OMAhyMSjy8EnqTQoRYE8uKK3MPMUpwMCuJ
	8EbnAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzKtm3hQgJpCeWpGanphakFsFkmTg4pRoYzxx2
	OnHu/t355vNT3y23LKgQCDvI/vlDrYbTrbczmk1/x76KDTjBtHTBjcJ01+TCxnbxR0ZqB1t1
	ZcP9P21JfCouO9tcdWrd9OIan50Sex5l5gi+n6DUZ+Ot4H/HwS9Q/ljMvqVTc19F9338oKpd
	wPS0/pvu9ur/J6siX93fcOVTkPu2tR9vK7EUZyQaajEXFScCAHZgRZVOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odroid U3 fan can work without being registered as OF cooling device
(with CONFIG_THERMAL_OF disabled).
In this situation it can be controlled via PWM entry at
/sys/class/hwmon/hwmon0/pwm1.

Therefore, the thermal_of_cooling_device_register() function needs a stub
to allow clean compilation.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 include/linux/thermal.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 99be7fc..54dce0e 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -328,6 +328,10 @@ thermal_zone_of_sensor_register(struct device *dev, int id, void *data,
 				const struct thermal_zone_of_device_ops *ops);
 void thermal_zone_of_sensor_unregister(struct device *dev,
 				       struct thermal_zone_device *tz);
+struct thermal_cooling_device *
+thermal_of_cooling_device_register(struct device_node *np,
+				   char *type, void *devdata,
+				   const struct thermal_cooling_device_ops *);
 #else
 static inline struct thermal_zone_device *
 thermal_zone_of_sensor_register(struct device *dev, int id, void *data,
@@ -342,6 +346,13 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 {
 }
 
+static inline struct thermal_cooling_device *
+thermal_of_cooling_device_register(struct device_node *np,
+				   char *type, void *devdata,
+				   const struct thermal_cooling_device_ops *ops)
+{
+	return NULL;
+}
 #endif
 struct thermal_zone_device *thermal_zone_device_register(const char *, int, int,
 		void *, struct thermal_zone_device_ops *,
@@ -357,9 +368,6 @@ void thermal_zone_device_update(struct thermal_zone_device *);
 
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
-struct thermal_cooling_device *
-thermal_of_cooling_device_register(struct device_node *np, char *, void *,
-				   const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
 struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name);
 int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp);
-- 
2.0.0.rc2

