Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3CDIFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:05:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51764 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3CDIFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:05:10 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-da-513455b5f65c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 19/24] rtc: rtc-rp5c01: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:05:08 +0900
Message-id: <014c01ce18ae$fd08c6b0$f71a5410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAQysw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY92toSaBBo//sltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MHV/mshZ8Yq+Ydzm5gfElWxcjJ4eEgInEtrnXWSFsMYkL99YD
	xbk4hASWMUrcbu5h7GLkACtau60CIr6IUeLF4UOMEM5sJonJsxsYQbrZBNQkvnw5zA7SICKg
	L9HWogFSwyzQyyhxpnc3O0iNkICtxJeHD5hAbE4BO4n751aBbRYW8JJY3b2WBcRmEVCVuPP5
	BZjNC1T/d/E0dghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvGWGOFRd4tFfXZCwiICRxJbfGxgh
	SkQk9r14B3azhMAydomX/RvYIHYJSHybfIgFoldWYtMBZkhASEocXHGDZQKjxCwkm2ch2TwL
	yeZZSFYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRESVxN3MN4/YH2IMRlo/URmKdHk
	fGBc5pXEGxobm5iZmJqYW5qam5ImrCTOK39JJlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD
	Y7/0jim/hVP8fA6zvTq3RcD0aXoKw7WFjwR4W3/ne7Hp6MtP9u31Psa6flnZXsUNZSuKfK++
	WDo39/SpmxPOZlze67QjXLHvfdixUMN5dhUlyrt8mhhOsfBWcv1zkpHfGZrso6t1Msrtw7L9
	Was4ZuxefW9fR3JY9WHuHIWOpMxNgYUZexsDlFiKMxINtZiLihMBHth55MECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7WUJNAg7+rmS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxo4vc1kLPrFXzLuc3MD4
	kq2LkYNDQsBEYu22ii5GTiBTTOLCvfVAYS4OIYFFjBIvDh9ihHBmM0lMnt3ACFLFJqAm8eXL
	YXaQZhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJb48fMAEYnMK2EncP7eKFcQWFvCSWN29lgXE
	ZhFQlbjz+QWYzQtU/3fxNHYIW1Dix+R7YHFmAS2J9TuPM0HY8hKb17xlhjhaXeLRX12QsIiA
	kcSW3xsYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBEftM+kdjKsaLA4xCnAwKvHwCnwyDhRiTSwrrsw9xCjBwawkwlsmYRIoxJuSWFmV
	WpQfX1Sak1p8iDEZ6NGJzFKiyfnAhJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp
	2ampBalFMFuYODilGhjn/tzye9Xm4+u6P4p7OHq6+35+ZLE0JcM61Ddiz55XckZ98SuqLjAF
	2fn+ll/p1eSjWJJewWxuEv+mhFVwXfqfaRPfZh5ieNx7duGJV4ztViXXMtmMVHY/4u2LnuWa
	v5x7Rc3WU0YVE759b71Q4Cx+L3bvhl0fNiUEf7N81PjG9h9vd85E5l1KLMUZiYZazEXFiQAT
	Jb79HgMAAA==
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
 drivers/rtc/rtc-rp5c01.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 359da6d..d25d2f6 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -294,18 +294,7 @@ static struct platform_driver rp5c01_rtc_driver = {
 	.remove	= __exit_p(rp5c01_rtc_remove),
 };
 
-static int __init rp5c01_rtc_init(void)
-{
-	return platform_driver_probe(&rp5c01_rtc_driver, rp5c01_rtc_probe);
-}
-
-static void __exit rp5c01_rtc_fini(void)
-{
-	platform_driver_unregister(&rp5c01_rtc_driver);
-}
-
-module_init(rp5c01_rtc_init);
-module_exit(rp5c01_rtc_fini);
+module_platform_driver_probe(rp5c01_rtc_driver, rp5c01_rtc_probe);
 
 MODULE_AUTHOR("Geert Uytterhoeven <geert@linux-m68k.org>");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


