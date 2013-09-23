Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3IWJpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:45:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29163 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3IWJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:45:46 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-f2-52400dc98795
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 07/15] rtc: rtc-ds2404: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:45:45 +0900
Message-id: <002301ceb841$acf58680$06e09380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAO0eg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA92TvA5BBo079CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuPtateAQW8WsL+sZGxi3s3YxcnJICJhIzFo9jQnCFpO4cG89WxcjF4eQwDJGiQsv
	TrLBFPVN/QmVmM4oMaP9ODOE84tR4mv/dLAqNgE1iS9fDrN3MXJwiAjoS7S1aIDUMAv0Mkqc
	6d3NDlIjJGArMXHaV7B1nAJ2Ems+LwOzhYHsKx03wWpYBFQlpnQsAYvzAtWf2zWXFcIWlPgx
	+R4LiM0soCWxeVsTK4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwknnz4xQRRIiKx78U7RpB7JARu
	sUtM3POXEWKXgMS3yYdYIHplJTYdYIZ4WFLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR
	1ILkguKk9CJTveLE3OLSvHS95PzcTYyQSJ24g/H+AetDjMlA6ycyS4km5wMjPa8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjBwe+f+EHzxnm83w
	SWLdMZlojqX3OU6f3v4gOJwxqTl8bv8+hVX/E17272ne8n9rZ4nXq1iXpWfOX9v8QW/iS7c9
	ky8dPBrlsKfh8qHZe+KNw2y3vS6zNOldvTPioyjv/W/pN/o+/w7sPJPglZid8Sq/5XW/zc1Q
	n3shd793XXxhKTj5gJNpyyQlluKMREMt5qLiRABJV2xh6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2TvA5BBpsva1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHH3tWrBIbaKWV/WMzYwbmftYuTkkBAwkeib
	+pMNwhaTuHBvPZDNxSEkMJ1RYkb7cWYI5xejxNf+6WBVbAJqEl++HGbvYuTgEBHQl2hr0QCp
	YRboZZQ407ubHaRGSMBWYuK0r0wgNqeAncSaz8vAbGEg+0rHTbAaFgFViSkdS8DivED153bN
	ZYWwBSV+TL7HAmIzC2hJbN7WxAphy0tsXvOWGWSvhIC6xKO/uiBhEQEjiScffjFBlIhI7Hvx
	jnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITgPPpHYw
	rmywOMQowMGoxMMbkWgfJMSaWFZcmXuIUYKDWUmE14/VIUiINyWxsiq1KD++qDQntfgQYzLQ
	oxOZpUST84EpKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUa
	GM3vrblRdk8rMVZp6W67O2FXGJvmNyxxj1pYe0JardrdkjnmrWLHG32XPff11mUEZTyR26e5
	61PhT7Pp+/es0wjUKe/tn9tiaOoWu631+l29NuYz/za911nY7fDf2Lxnm2BqmZ1Tr5dXDd+U
	h/HWqbff7522IVvfWsM04t7FR+/ebN5b95H1tBJLcUaioRZzUXEiAL9XkPxHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds2404.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index 2ca5a23..fc209dc 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -224,7 +224,7 @@ static const struct rtc_class_ops ds2404_rtc_ops = {
 
 static int rtc_probe(struct platform_device *pdev)
 {
-	struct ds2404_platform_data *pdata = pdev->dev.platform_data;
+	struct ds2404_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct ds2404 *chip;
 	int retval = -EBUSY;
 
-- 
1.7.10.4


