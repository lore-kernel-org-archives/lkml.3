Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbaCLGVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:21:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11401 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaCLGVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:21:23 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-a1-531ffce110e0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sbkim73@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2] drivers: mfd: silence compiler warning in sec-core.c
Date: Wed, 12 Mar 2014 15:37:41 +0900
Message-id: <1394606261-4659-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t8zQ92Hf+SDDe5+MbW4//Uoo8XlXXPY
	LBZt/cJucbqb1eLiii9MDqwed67tYfOYdzLQo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLW
	H7rKUnCVo6JxazdzA+Mc9i5GTg4JAROJ06f+sUHYYhIX7q0Hsrk4hASWMUqc+fKLDabo8p9j
	UIlFjBJNc/6yQDhtTBIPrz9kBaliE9CVePJ+LjOILSKgILG59xlYnFkgX+LCr2mMILawgIfE
	ywm/wOIsAqoSu98tZOpi5ODgFXCX6D1mCmJKALXOmWQDYnICVa9drg1SLARUsPLzXCaQrRIC
	/9kkmm+2MkFMEZD4NvkQC0SrrMSmA8wQJ0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5
	xaV56XrJ+bmbGCEBPHEH4/0D1ocYk4HGTWSWEk3OB0ZAXkm8obGZkYWpiamxkbmlGWnCSuK8
	6Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwxi5L4djBz3jVUOSd7Q3f9N9CHufeqC/e
	M+nPxNo11+54yD/VDDFru9b7XPPPK7bIXp+1EbIfsg9VP+utOyby6g3Pjcd66+L3875eNi1K
	+sKmrT9mx9mnhYpUGil/nhaezLax3H/zESaJv0W3UjMZmOfoSD/RbhfbdrMm3lj+BEPppRlf
	NadGKLEUZyQaajEXFScCAN0ONd92AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t9jAd2Hf+SDDW6sN7K4//Uoo8XlXXPY
	LBZt/cJucbqb1eLiii9MDqwed67tYfOYdzLQo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNT
	MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKimUJeaUAoUCEouLlfTtME0I
	DXHTtYBpjND1DQmC6zEyQAMJ6xgz1h+6ylJwlaOicWs3cwPjHPYuRk4OCQETict/jrFB2GIS
	F+6tB7K5OIQEFjFKNM35ywLhtDFJPLz+kBWkik1AV+LJ+7nMILaIgILE5t5nYHFmgXyJC7+m
	MYLYwgIeEi8n/AKLswioSux+t5Cpi5GDg1fAXaL3mCmIKQHUOmeSDYjJCVS9drk2SLEQUMHK
	z3OZJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHB/PpHcwrmqwOMQowMGoxMO7
	UFM+WIg1say4MvcQowQHs5II70eQEG9KYmVValF+fFFpTmrxIcZkoJMmMkuJJucDYzevJN7Q
	2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhiZprWH5c8UCNO6Pd1/
	/rMngjmFLB3GGatnsEwsuGt02phjdtIyryVG3xenPmMVujbrSNUDFplX2yz1Hos+XC+R0JEk
	xiDwMvSgB8NKx1l25UGe/L5xu3etC/4zp9NRdoZyfZPSopnPc1pfZf78Gn8+97uMbkNv8DFX
	ti2OrGt4S37J22Q4qiuxFGckGmoxFxUnAgDF7+jE0wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When used 64bit compiler GCC warns as
drivers/mfd/sec-core.c:199:10: warning:
cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/mfd/sec-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index e467108..3c9fd5d 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -210,17 +210,17 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
 }
 #endif
 
-static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
+static inline unsigned long sec_i2c_get_driver_data(struct i2c_client *i2c,
 						const struct i2c_device_id *id)
 {
 #ifdef CONFIG_OF
 	if (i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(sec_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (unsigned long)match->data;
 	}
 #endif
-	return (int)id->driver_data;
+	return id->driver_data;
 }
 
 static int sec_pmic_probe(struct i2c_client *i2c,
-- 
1.7.9.5

