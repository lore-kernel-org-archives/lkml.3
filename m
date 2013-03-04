Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3CDH6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:58:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50080 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab3CDH6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:58:34 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-83-51345428ef29
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 03/24] rtc: rtc-at91rm9200: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:58:32 +0900
Message-id: <013c01ce18ae$10cf72d0$326e5870$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAABhwg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY12NEJNAg+1v9SyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuNC6jLHgInvFurs2DYzH2boYOTkkBEwk3u3dwQhhi0lcuLceKM7FISSwjFFiytFt
	zDBFp5/MhkpMZ5TY33efFcL5xSix+/UnVpAqNgE1iS9fDrN3MXJwiAjoS7S1aIDUMAv0Mkqc
	6d3NDlIjJGAr8eXhAyYQm1PATuL+uVVgvcICfhKH1twGs1kEVCUO9q8G28wLVP/syXYmCFtQ
	4sfkeywgNrOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCTx8s5UNogSEYl9L94xgtwj
	IXCPXWL/mwfMELsEJL5NPsQC0SsrsekA1MOSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYx
	iqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihERq/w7GuwesDzEmA62fyCwlmpwPjPS8knhDY2MT
	MxNTE3NLU3NT0oSVxHnlL8kECgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamB0fhPAOf1+sHPX
	d5sLqsUs9zKu+UrE258qLWOoyI0SyZvFfn66x/1F7iL+Mnw8V+aw2y/7NrMs6enTDdKXnup9
	Z7xqayHoXHI/w+E6/+4jGvULc39t+eh0/h2Dyf5Nbs+7Jv5d23Yovmpiorvo333Bz+8WuX81
	Z9148Ix4ImeTayrrpOdzf8YqsRRnJBpqMRcVJwIAryIYc+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV2NEJNAg4sXtSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLjQuoyx4CJ7xbq7Ng2Mx9m6GDk5JARMJE4/
	mQ1li0lcuLceyObiEBKYziixv+8+K4Tzi1Fi9+tPrCBVbAJqEl++HGbvYuTgEBHQl2hr0QCp
	YRboZZQ407ubHaRGSMBW4svDB0wgNqeAncT9c6vAeoUF/CQOrbkNZrMIqEoc7F/NDGLzAtU/
	e7KdCcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmLCBhJvLwzlQ2iRERi
	34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwGngm
	vYNxVYPFIUYBDkYlHl6BT8aBQqyJZcWVuYcYJTiYlUR4yyRMAoV4UxIrq1KL8uOLSnNSiw8x
	JgM9OpFZSjQ5H5ii8kriDY1NzIwsjcwsjEzMzUkTVhLnZTz1JEBIID2xJDU7NbUgtQhmCxMH
	p1QDI0tfMdPO9tI3scvtbrq28+zx2G9UUm5006X0bI2Hku2bCacOx/xkX8NVeeJEWp+Zyhyl
	6UGP9gq88JqVs9dve9BZk47bM4SniHY3nuPJlSjPjG79euqlyf+rfqXvjBKLbzlJC/iyHXml
	Zr/9ULXBL76qebZh0xdEPc7ZvPWD5EHOqD8Vcse/KLEUZyQaajEXFScCAMqkR2BHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at91rm9200.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 434ebc3..f63c8fe 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -390,18 +390,7 @@ static struct platform_driver at91_rtc_driver = {
 	},
 };
 
-static int __init at91_rtc_init(void)
-{
-	return platform_driver_probe(&at91_rtc_driver, at91_rtc_probe);
-}
-
-static void __exit at91_rtc_exit(void)
-{
-	platform_driver_unregister(&at91_rtc_driver);
-}
-
-module_init(at91_rtc_init);
-module_exit(at91_rtc_exit);
+module_platform_driver_probe(at91_rtc_driver, at91_rtc_probe);
 
 MODULE_AUTHOR("Rick Bronson");
 MODULE_DESCRIPTION("RTC driver for Atmel AT91RM9200");
-- 
1.7.2.5


