Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3C1IjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:39:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3C1IjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:39:10 -0400
X-AuditID: cbfee68d-b7f786d000005188-dd-515401adafee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 6/8] rtc: rtc-spear: convert spear_rtc_driver to dev_pm_ops
Date: Thu, 28 Mar 2013 17:39:08 +0900
Message-id: <001501ce2b8f$b6e39950$24aacbf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAAEY4A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI921jCGBBps/CFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMWnWMaaCJQIV957ENTBe4O1i5OSQEDCReLzvMguELSZx4d56ti5GLg4hgWWMEjsb
	zrLBFM37sY4dIjGdUWLXgvXMIAkhgV+MEi2d+iA2m4CaxJcvh4GKODhEBPQl2lo0QOqZBXoZ
	Jc707maHqLeVOHf4Klgvp4CdRPuarWCbhQW8JQ69esQKYrMIqEp8e34fLM4LVL/8ax87hC0o
	8WPyPbA4s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJPHl7jc2iBIRiX0v3jGC3CMh
	cI9d4lbzFyaIXQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsY
	RVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQuK0dwfj7QPWhxiTgdZPZJYSTc4HxnleSbyhsZmR
	hamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgPFrBFGVSsm8tR
	MnN964WOWsE2J6OL17NtjlSte9K3ava9lJLpZXIcWb8rrjon3Xq38Oy9F7Lf4hpeMHe9Cjq/
	+aekW4+gzN7KHWeOheRNsGcyvy19NjtpzrLdi7nVr4QpTH5eU6B6nt9heuf7cwsuaVzxamic
	HC159FTXJ+YdZ0P6utR4JnApsRRnJBpqMRcVJwIA9bGMSekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd21jCGBBovP8losuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDFp1jGmgiUCFfeexDUwXuDtYuTkkBAwkZj3
	Yx07hC0mceHeerYuRi4OIYHpjBK7FqxnBkkICfxilGjp1Aex2QTUJL58OQzUwMEhIqAv0dai
	AVLPLNDLKHGmdzc7RL2txLnDV8F6OQXsJNrXbGUBsYUFvCUOvXrECmKzCKhKfHt+HyzOC1S/
	/GsfO4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcXJCwiYCTx5e43NogSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFJ4JnU
	DsaVDRaHGAU4GJV4eCsEggOFWBPLiitzDzFKcDArifAe6gQK8aYkVlalFuXHF5XmpBYfYkwG
	enQis5Rocj4wQeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A+Pue5ss17Pe5ppi+ZtLraxhafg8F/bbT84vZqoTvVuo/Sa1/0Gz9+u1fh9aDvF+ETEQaHep
	zHrd67Ap+PmtbbuPC+3P380jWvjKS13pzatJDFM7lr3bJDYpxtba8exV6enTzuyyP3kg7ccx
	h+bcJ+I2ITPVfLbrxdi3LozbWlzeZuuUsbhrxSQlluKMREMt5qLiRAC1FBl6RgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-spear.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index db3ef61..574359c 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -434,10 +434,10 @@ static int spear_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-
-static int spear_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int spear_rtc_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 
@@ -453,8 +453,9 @@ static int spear_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int spear_rtc_resume(struct platform_device *pdev)
+static int spear_rtc_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 	int irq;
 
@@ -472,12 +473,10 @@ static int spear_rtc_resume(struct platform_device *pdev)
 
 	return 0;
 }
-
-#else
-#define spear_rtc_suspend	NULL
-#define spear_rtc_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(spear_rtc_pm_ops, spear_rtc_suspend, spear_rtc_resume);
+
 static void spear_rtc_shutdown(struct platform_device *pdev)
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
@@ -497,11 +496,10 @@ MODULE_DEVICE_TABLE(of, spear_rtc_id_table);
 static struct platform_driver spear_rtc_driver = {
 	.probe = spear_rtc_probe,
 	.remove = spear_rtc_remove,
-	.suspend = spear_rtc_suspend,
-	.resume = spear_rtc_resume,
 	.shutdown = spear_rtc_shutdown,
 	.driver = {
 		.name = "rtc-spear",
+		.pm = &spear_rtc_pm_ops,
 		.of_match_table = of_match_ptr(spear_rtc_id_table),
 	},
 };
-- 
1.7.2.5


