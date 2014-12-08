Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaLHRHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:07:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:07:06 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-ae-5485dab66cfa
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>,
        navneet kumar <navneetk@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v3 3/5] thermal: of: Rename struct __thermal_trip to struct
 thermal_trip
Date: Mon, 08 Dec 2014 18:04:19 +0100
Message-id: <1418058261-25251-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd3tt1pDDG7OZrF4vGYxk8XGGetZ
	Lb587mOzmH/lGqvFmr9KFm8ecVu8ebiZ0eLyrjlsFp97jzBaPFl4hsniwdVpbBb71ixlsnjy
	EKj+1cE2Foufu+axOPB77Jx1l91j8Z6XTB7rpr1l9uhtfsfm8XfWfhaPnd8b2D36tqxi9Pi8
	Sc5j49zQAM4oLpuU1JzMstQifbsEroyvr6YzF7wQr7i7PLaBcbFwFyMnh4SAiUTri5dMELaY
	xIV769m6GLk4hAQWMUqsXj2HBSQhJNDFJLHsVjaIzSagJ/H57lOwBhEBb4nX+6YzgjQwC6xh
	kfhw9S5QNweHsECURMNcVpAaFgFViYZNS9hBbF4BN4l1HavYIJYpSnQ/mwBmcwq4S5y/d50V
	YnETo8TlHTtZJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHMbPpHcwrmqwOMQo
	wMGoxMO78EFLiBBrYllxZe4hRgkOZiUR3uU7W0OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8964
	mRsiJJCeWJKanZpakFoEk2Xi4JRqYFx9TdGk7O5Tnb/ytkf2nD0zY8c9i+nvg05MbuheY9Te
	/mhe+F5JFo+grZwHS3dfeSQya7F/de/rDpfILerZyT1L3bS/cu1bx2M6dZe0iOfu+Pgte3/x
	/xDzXqS9JPZAj8i/rwudux+L7JxlGt50IEZ+PfOWwv2Jl35Wv1r5bmPobO7ugL9Bnk1KLMUZ
	iYZazEXFiQCSB9nFXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes name of struct __thermal_trip to thermal_trip and moves
declaration of the latter to ./include/linux/thermal.h for better visibility.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v3:
- New patch - as suggested by Navneet Kumar
---
 drivers/thermal/of-thermal.c | 21 +++------------------
 include/linux/thermal.h      | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 87b9cfe..d3ac117 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -37,21 +37,6 @@
 /***   Private data structures to represent thermal device tree data ***/
 
 /**
- * struct __thermal_trip - representation of a point in temperature domain
- * @np: pointer to struct device_node that this trip point was created from
- * @temperature: temperature value in miliCelsius
- * @hysteresis: relative hysteresis in miliCelsius
- * @type: trip point type
- */
-
-struct __thermal_trip {
-	struct device_node *np;
-	unsigned long int temperature;
-	unsigned long int hysteresis;
-	enum thermal_trip_type type;
-};
-
-/**
  * struct __thermal_bind_param - a match between trip and cooling device
  * @cooling_device: a pointer to identify the referred cooling device
  * @trip_id: the trip point index
@@ -88,7 +73,7 @@ struct __thermal_zone {
 
 	/* trip data */
 	int ntrips;
-	struct __thermal_trip *trips;
+	struct thermal_trip *trips;
 
 	/* cooling binding data */
 	int num_tbps;
@@ -538,7 +523,7 @@ EXPORT_SYMBOL_GPL(thermal_zone_of_sensor_unregister);
  */
 static int thermal_of_populate_bind_params(struct device_node *np,
 					   struct __thermal_bind_params *__tbp,
-					   struct __thermal_trip *trips,
+					   struct thermal_trip *trips,
 					   int ntrips)
 {
 	struct of_phandle_args cooling_spec;
@@ -641,7 +626,7 @@ static int thermal_of_get_trip_type(struct device_node *np,
  * Return: 0 on success, proper error code otherwise
  */
 static int thermal_of_populate_trip(struct device_node *np,
-				    struct __thermal_trip *trip)
+				    struct thermal_trip *trip)
 {
 	int prop;
 	int ret;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 5bc28a7..b8d91ef 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -303,6 +303,21 @@ struct thermal_zone_of_device_ops {
 	int (*get_trend)(void *, long *);
 };
 
+/**
+ * struct thermal_trip - representation of a point in temperature domain
+ * @np: pointer to struct device_node that this trip point was created from
+ * @temperature: temperature value in miliCelsius
+ * @hysteresis: relative hysteresis in miliCelsius
+ * @type: trip point type
+ */
+
+struct thermal_trip {
+	struct device_node *np;
+	unsigned long int temperature;
+	unsigned long int hysteresis;
+	enum thermal_trip_type type;
+};
+
 /* Function declarations */
 #ifdef CONFIG_THERMAL_OF
 struct thermal_zone_device *
-- 
2.0.0.rc2

