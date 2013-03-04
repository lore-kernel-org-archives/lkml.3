Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3CDIAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:00:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13388 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3CDIAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:00:34 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-fe-513454a24c16
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 08/24] rtc: rtc-efi: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:00:33 +0900
Message-id: <014101ce18ae$5911fbd0$0b35f370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAGkBA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ91FISaBBrveM1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M63vWMRdsYa+Yv+MpUwPjarYuRk4OCQETiamblrNC2GISF+6t
	B4pzcQgJLGOUuLtqPnMXIwdY0YfjyRDxRYwSz6atgiqazSTx88ZFJpBuNgE1iS9fDrODNIgI
	6Eu0tWiA1DAL9DJKnOndzQ5SIyRgK/Hl4QOwek4BO4n751aBbRYWcJe4+PY+mM0ioCrR/OQ/
	WD0vUP3ZPf+gbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95C3WousSjv7ogYREBI4lZT/+zQZSI
	SOx78Y4R5B4JgWXsErPn7GGC2CUg8W3yIRaIXlmJTQeYIQEhKXFwxQ2WCYwSs5BsnoVk8ywk
	m2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkhk9e9gvHvA+hBjMtD6icxSosn5
	wMjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	yFOSymsy/x1Zd3TinOXZp+/tfb7hr2LFSefQuWtyJ/WsauOtnbInYnKwT6rwfMXiZXyxz7bZ
	OPgH7y1+nxvT7S/LJXQrfmP4lhB3T373ve7G+a+05s/ytjI/+O5jxdIplvpflpxOevx9w3PD
	7envrTPc9YLsDi1NSJm9bDeX4onPe3tFum1/KbEUZyQaajEXFScCABdx9+7CAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7CEJNAg+bXVhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/qedcwFW9gr5u94ytTA
	uJqti5GDQ0LAROLD8eQuRk4gU0ziwr31QGEuDiGBRYwSz6atgnJmM0n8vHGRCaSKTUBN4suX
	w+wgzSIC+hJtLRogNcwCvYwSZ3p3s4PUCAnYSnx5+ACsnlPATuL+uVWsILawgLvExbf3wWwW
	AVWJ5if/wep5gerP7vkHZQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIo9UlHv3VBQmLCBhJ
	zHr6nw2iRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpe
	cn7uJkZw3D6T2sG4ssHiEKMAB6MSD6/AJ+NAIdbEsuLK3EOMEhzMSiK8ZRImgUK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0wpeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5Ykpqd
	mlqQWgSzhYmDU6qBUXvpX6XUB1JmnwNWceg6nLmT5rdaf97lvwYrVm6ZWdPuZ2+WbJXhU7Bj
	UeKebplJ9koL4lZxG0bJx85ZdGni/Dsr130vev248ZfEi7/zZhS+OfC60/mxBYe19qIXc1Yd
	mCV74vDb+UXTsx4tWsM/b8f3iY47zy3LfqmrLjI/a7/si6vF1jPZds5WYinOSDTUYi4qTgQA
	OmcO4h8DAAA=
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
 drivers/rtc/rtc-efi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 1a0c37c..e706662 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -218,18 +218,7 @@ static struct platform_driver efi_rtc_driver = {
 	.remove = __exit_p(efi_rtc_remove),
 };
 
-static int __init efi_rtc_init(void)
-{
-	return platform_driver_probe(&efi_rtc_driver, efi_rtc_probe);
-}
-
-static void __exit efi_rtc_exit(void)
-{
-	platform_driver_unregister(&efi_rtc_driver);
-}
-
-module_init(efi_rtc_init);
-module_exit(efi_rtc_exit);
+module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
 
 MODULE_AUTHOR("dann frazier <dannf@hp.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


