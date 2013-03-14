Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3CNIUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:20:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25677 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3CNIUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:20:18 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-a6-514188419f52
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 17/30] rtc: rtc-max6902: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:20:16 +0900
Message-id: <009401ce208c$c278f3e0$476adba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAU2lQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ13HDsdAg6cnJSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK+PjuPWPBffaKR82v2RoY17N1MXJySAiYSKw/c4MFwhaTuHAPJM7FISSwjFFiysm9
	jF2MHGBFhxqTIeLTGSX+XF3LBOH8YpS4cbidCaSbTUBN4suXw+wgDSIC+hJtLRogNcwCvYwS
	Z3p3g8WFBGwlrv+3AzE5BewkNqwXA+kUFnCXaDzRzg5iswioSiz+MoEVxOYFqn4zbwYbhC0o
	8WPyPbA7mQW0JNbvPM4EYctLbF7zlhniTHWJR391IQ4wkvjZVwVRISKx78U7RpBjJARusUvs
	PbuKDWKVgMS3yYdYIFplJTYdYIaEgqTEwRU3WCYwSsxCsngWksWzkCyehWTFAkaWVYyiqQXJ
	BcVJ6UXGesWJucWleel6yfm5mxghMdq/g/HuAetDjMlA6ycyS4km5wNjPK8k3tDYzMjC1MTU
	2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjFH+HFVSM496Pv//afZ7
	1xNt98TfmE3pNVRwZ1TUnnOUreHl3p0n2VKqLPu3zbOeW7l9mdIc/kufxat+dJ+vcq/8W7No
	0XXX1XpGy4+1PjghvDH1xX2r1jUe+ZoBKvlrp/KahuvZXDp3dnPAveoTfBJrtm816gqbabNV
	/fGl6MmL5zAys1fldiixFGckGmoxFxUnAgB0XbhT5wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQV3HDsdAg7nHRCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPj47j1jwX32ikfNr9kaGNezdTFycEgImEgc
	akzuYuQEMsUkLtwDCXNxCAlMZ5T4c3UtE4Tzi1HixuF2JpAqNgE1iS9fDrODNIsI6Eu0tWiA
	1DAL9DJKnOndDRYXErCVuP7fDsTkFLCT2LBeDKRTWMBdovFEOzuIzSKgKrH4ywRWEJsXqPrN
	vBlsELagxI/J91hAbGYBLYn1O48zQdjyEpvXvGWGOFld4tFfXYgDjCR+9lVBVIhI7HvxjnEC
	o9AsJINmIRk0C8mgWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgDPpHYwrmyw
	OMQowMGoxMN7oN8hUIg1say4MvcQowQHs5IIr6eXY6AQb0piZVVqUX58UWlOavEhxmSgPycy
	S4km5wOTU15JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MPpm
	Hvfa9U+Va0KhtXOdxO6vFnmW6b7OtnwvIi40CvNFeJz9Hnit0/PHprPq6sfreJ/yWlzwnFnK
	7rjv4nGbFRIlO+fqzORfP9FHMSxm36Ts9yllf++1Ky+7JPbHzkeUU0LP7Vz6bzUZYbnH65be
	3bTa1lpfhO3izjcz03Zsv/1h08lXtp8kJyixFGckGmoxFxUnAgBr2mqURAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max6902.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-max6902.c b/drivers/rtc/rtc-max6902.c
index 7d0bf69..7e4491b 100644
--- a/drivers/rtc/rtc-max6902.c
+++ b/drivers/rtc/rtc-max6902.c
@@ -134,8 +134,8 @@ static int max6902_probe(struct spi_device *spi)
 	if (res != 0)
 		return res;
 
-	rtc = rtc_device_register("max6902",
-				&spi->dev, &max6902_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "max6902",
+				&max6902_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -145,9 +145,6 @@ static int max6902_probe(struct spi_device *spi)
 
 static int max6902_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.2.5


