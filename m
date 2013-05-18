Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3ERJvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:51:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22507 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3ERJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:51:04 -0400
X-AuditID: cbfee691-b7fef6d000002d62-1e-51974f05afbc
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/3] Thermal: core: Modify temp_crit_show() to use proper
 callback function.
Date: Sat, 18 May 2013 18:50:56 +0900
Message-id: <1368870656-1183-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkQJfNf3qgwYbLTBZLHkxhtFiz/yeT
	RefZJ8wWl3fNYbP43HuE0eJ24wo2iycP+9gc2D0W73nJ5HHn2h42j74tqxg9jt/YzuTxeZNc
	AGsUl01Kak5mWWqRvl0CV8a3vVNZCs6yVbzfMJ+1gfE4axcjJ4eEgInE3a9fWSBsMYkL99az
	dTFycQgJLGWUWDnhG1xR/9v5jCC2kMAiRomHPUwQRS1MEl1bN7OBJNgEdCT+77vJDmKLCMhI
	TL2ynxWkiFngE6PEpIM7mEASwgJxEj0ztoI1sAioSiy//AKsgVfAXWJa50cgmwNom4LEnEk2
	IL0SAs3sEntalzFC1AtIfJt8iAWiRlZi0wFmiOMkJQ6uuMEygVFwASPDKkbR1ILkguKk9CJT
	veLE3OLSvHS95PzcTYzAsD3979nEHYz3D1gfYkwGGjeRWUo0OR8Y9nkl8YbGZkYWpiamxkbm
	lmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYIzYfvWwveaeByoHDWYwXHnS
	U82lXrExdZG/YF73pEVzwzYq2zf97O2ftOlxZnP5zHUSL0NXeghLGXgHKc7RVHbgVl5hu+L0
	5ozdOqw+6/7NnXlBXdMso75pftcj9uSCvxM/zroUI+V9MHjO5IZ+pTeSf/8v13j/Yfe8mbYn
	XnUsKZP9z3hSZKUSS3FGoqEWc1FxIgBh9slDcQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAV1W/+mBBr9Om1sseTCF0WLN/p9M
	Fp1nnzBbXN41h83ic+8RRovbjSvYLJ487GNzYPdYvOclk8eda3vYPPq2rGL0OH5jO5PH501y
	AaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzvu2dylJwlq3i/Yb5rA2M
	x1m7GDk5JARMJPrfzmeEsMUkLtxbzwZiCwksYpR42MPUxcgFZLcwSXRt3QyWYBPQkfi/7yY7
	iC0iICMx9cp+VpAiZoFPjBKTDu5gAkkIC8RJ9MzYCtbAIqAqsfzyC7AGXgF3iWmdH4FsDqBt
	ChJzJtlMYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Kp5J7WBc2WBxiFGAg1GJ
	h/eD67RAIdbEsuLK3EOMEhzMSiK8z4uBQrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HRmxe
	SbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBun5X9U6jqbx6r
	/OIkvzWMbNPWX9+s5j7JYuq0DzO2r2fat8z1cejZV4nTlv2+t0fLw/TLpKbGhcaH7mRutnn1
	JtcgK2/pVYfJnKXdOzjFcyO2nAy8r/3pqthPdZZZJ6fcFHwhN0HhtcM9vZteolkbPv36GnTM
	lDHt2LstYTObC/L+NBnOb3iWo8RSnJFoqMVcVJwIAJwFHKnOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies temp_crit_show() which is used to create hwmon's sysfs
node to use .get_crit_temp callback function of thermal zone device rather
than .get_trip_temp.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/thermal/thermal_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index f753f48..ce4384a 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -924,7 +924,7 @@ temp_crit_show(struct device *dev, struct device_attribute *attr,
 	long temperature;
 	int ret;
 
-	ret = tz->ops->get_trip_temp(tz, 0, &temperature);
+	ret = tz->ops->get_crit_temp(tz, &temperature);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5

