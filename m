Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3ERJvP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 05:51:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39407 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3ERJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 05:51:09 -0400
X-AuditID: cbfee68e-b7f276d000002279-8d-51974f0cdf23
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 3/3] Thermal:core: Handle trips focused on current trip point
 only.
Date: Sat, 18 May 2013 18:51:03 +0900
Message-id: <1368870663-1225-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkSJfHf3qgwd9fChZLHkxhtFiz/yeT
	RefZJ8wWl3fNYbP43HuE0eJ24wo2iycP+9gc2D0W73nJ5HHn2h42j74tqxg9jt/YzuTxeZNc
	AGsUl01Kak5mWWqRvl0CV8a6B4EF5/krHh5vZW1g/MfTxcjJISFgIrHtQCsThC0mceHeerYu
	Ri4OIYGljBJTfs5lgSk62bqOGSIxnVFizqVVUFUtTBIr9r0Fq2IT0JH4v+8mO4gtIiAjMfXK
	flaQImaBT4wSkw7uANshLBAqMWveQbAiFgFViQdz5gNN4uDgFXCXmH3LEcSUEFCQmDPJBqRV
	QqCZXeL61YeMEOUCEt8mH2KBqJGV2HSAGeI4SYmDK26wTGAUXMDIsIpRNLUguaA4Kb3ISK84
	Mbe4NC9dLzk/dxMjMGhP/3vWt4Px5gHrQ4zJQOMmMkuJJucDgz6vJN7Q2MzIwtTE1NjI3NKM
	NGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx9c5Zkfvzfm7zgf5L//UUL/mw8
	GjXv9J+TM5TPFP50PuHDJX7hyv0rNc7HiyZcyt8T5b2/5tl6Rudvbzcm3zuScqFPbMrF17Ua
	fZMv2e6xe7nm+MHtzIyfWMJWc816sj+hMKr7QJNpgHHHv+/vmiY3zovxTxA8u0XURctH1uve
	B6EUibdTNhYUKbEUZyQaajEXFScCACSy3hdwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV0e/+mBBueaJC2WPJjCaLFm/08m
	i86zT5gtLu+aw2bxufcIo8XtxhVsFk8e9rE5sHss3vOSyePOtT1sHn1bVjF6HL+xncnj8ya5
	ANaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ6x4EFpznr3h4vJW1gfEf
	TxcjJ4eEgInEydZ1zBC2mMSFe+vZuhi5OIQEpjNKzLm0CsppYZJYse8tC0gVm4COxP99N9lB
	bBEBGYmpV/azghQxC3xilJh0cAcTSEJYIFRi1ryDYEUsAqoSD+bMB5rEwcEr4C4x+5YjiCkh
	oCAxZ5LNBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY+KZ9A7GVQ0WhxgFOBiV
	eHhnOE8LFGJNLCuuzD3EKMHBrCTC+7wYKMSbklhZlVqUH19UmpNafIgxGWj3RGYp0eR8YLzm
	lcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAOjkS/PD7cJTPZX
	Xa7ZX3yqtebu8wleGnO67K98ZxH4pfFQdteBOoNK1rO+Z39InhZ4tPNSVNmGjl2H2xqmbwks
	uOITY7X01jO1+LV/HPXrphYdEez6J7i2Wshw2oMrBqqq56wZ10wvZLD4MDuR/Zpobv/Ty8eV
	D1v7/N9TffTtQe/WFp1F92JmK7EUZyQaajEXFScCADBNY8XNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When thermal zone device is updated, it doesn't need to check
every trip points and its handling mathod even current temperature
doesn't exceed the trip's temperature. To modify those dissipatve
mechanism, this patch introduces the way to get current thermal
trip point to call only correspond trip point handling.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/thermal/thermal_core.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index ce4384a..1cc4825 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -333,14 +333,6 @@ static void handle_non_critical_trips(struct thermal_zone_device *tz,
 static void handle_critical_trips(struct thermal_zone_device *tz,
 				int trip, enum thermal_trip_type trip_type)
 {
-	long trip_temp;
-
-	tz->ops->get_trip_temp(tz, trip, &trip_temp);
-
-	/* If we have not crossed the trip_temp, we do not care. */
-	if (tz->temperature < trip_temp)
-		return;
-
 	if (tz->ops->notify)
 		tz->ops->notify(tz, trip, trip_type);
 
@@ -437,14 +429,28 @@ static void update_temperature(struct thermal_zone_device *tz)
 	mutex_unlock(&tz->lock);
 }
 
+static int thermal_zone_get_current_trip(struct thermal_zone_device *tz)
+{
+	int trip;
+	long trip_temp;
+
+	for (trip = tz->trips - 1; trip > 0; trip--) {
+		tz->ops->get_trip_temp(tz, trip, &trip_temp);
+		if (tz->temperature > trip_temp)
+			continue;
+	}
+	return trip;
+}
+
 void thermal_zone_device_update(struct thermal_zone_device *tz)
 {
-	int count;
+	int trip;
 
 	update_temperature(tz);
 
-	for (count = 0; count < tz->trips; count++)
-		handle_thermal_trip(tz, count);
+	trip = thermal_zone_get_current_trip(tz);
+
+	handle_thermal_trip(tz, trip);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_update);
 
-- 
1.7.9.5

