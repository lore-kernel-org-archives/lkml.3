Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaLVQ2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:28:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:29826 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbaLVQ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:28:29 -0500
X-AuditID: cbfee61a-f79c06d000004e71-7c-549846abb15c
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
Subject: [PATCH v2 1/8] thermal: Provide stub for
 thermal_of_cooling_device_register() function
Date: Mon, 22 Dec 2014 17:27:41 +0100
Message-id: <1419265668-32283-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
References: <1418897591-18332-1-git-send-email-l.majewski@samsung.com>
 <1419265668-32283-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jAd3VbjNCDP6fkLF4vGYxk8X8I+dY
	LeZfucZqsfTuJzaLH68vsFms+atk0bvgKpvFm0fcFm8ebma0uLxrDpvF594jjBYzzu9jsniy
	8AyTxZ1pe9ksDr9pZ3Xg99g56y67x4OJu9k81k17y+yx83sDu0ffllWMHptPV3t83iQXwB7F
	ZZOSmpNZllqkb5fAlbH61meWgv+CFTveXWNuYJzH38XIySEhYCLxeNlRFghbTOLCvfVsXYxc
	HEICixgl9mx/BeV0MUnsv/SaFaSKTUBP4vPdp0wgCRGBGYwS+5u+sYM4zAJXmCW+nWoEmyUs
	kCjxrQ1iLouAqsT3p7eYQGxeATeJGb8XM0PsU5TofjYBaAUHB6eAu8TvV7wQ25oZJU4taGSe
	wMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw4D6T2sG4ssHiEKMAB6MSDy9H2vQQ
	IdbEsuLK3EOMEhzMSiK8Vy1nhAjxpiRWVqUW5ccXleakFh9ilOZgURLnVbJvCxESSE8sSc1O
	TS1ILYLJMnFwSjUwKrqn7NzatfGL/7Gatluq/rdTPp9N9t0iObdOuiU5r1NggfdZy+7kRe3T
	CtoSK9YHbHk9c4nBL7U5m1344pvnP3Htyt9tv6PbPYjR/mJlhcbblEduqk/LRBaoTjizr7zq
	hnJ34ZYM5uVP7/jt/PNXQtPbl+P0lyvywo/WFq4NlGvx0PNcb7RKiaU4I9FQi7moOBEA/mnE
	lFgCAAA=
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
Changes for v2:
- None
---
 include/linux/thermal.h | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 2de3d9e..871123c 100644
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

