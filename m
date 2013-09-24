Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3IXJLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:11:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21483 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3IXJLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:11:33 -0400
X-AuditID: cbfee68e-b7f756d000004512-88-52415744299f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 09/22] backlight: da903x_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:11:32 +0900
Message-id: <004f01ceb906$0f824120$2e86c360$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAPIOw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zI12XcMcgg1Vr5S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozNz9oY
	Cy7wVLSs28/SwHiaq4uRk0NCwERi0+n77BC2mMSFe+vZuhi5OIQEljFKzOt4zQhT1ND+Eyqx
	iFHiff9sdgjnF6NEx8p9bCBVbAJqEl++HAZKcHCICOhLtLVogISZBXIk7j+ZBbZBSMBWYt2H
	2WA2p4CdxKmlZ8BahQWCJT61fGYFsVkEVCWe/3nKBGLzAtX/f7uTEcIWlPgx+R4LxEwtic3b
	mlghbHmJzWveMoOslRBQl3j0VxckLCJgJPF43zRmiBIRiX0v3jGCnCwhcI5d4syzQ2wQuwQk
	vk0+xALRKyux6QAzxL+SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525ihERl3w7GmwesDzEmA62fyCwlmpwPjOq8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAqGWZ/PijC0X1I7NwG7a7OyXe85ScF
	vzRQYVr5ZHNn3cm+slNd5ppKZd/nWiXPe6j9wX1PTqTDac1Az3vF9e/4fl2dc1nogYB4kIUd
	vyv/KvnsnDUvOvbmsLXesHDJO/co3bj1zl+dv1+jF09qdtvdWC9x7pzssu5e/8O7TPkL782f
	8f31HD0lluKMREMt5qLiRABU+nIw4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV2XcMcggxe7pS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMzc/aGAsu8FS0rNvP0sB4mquLkZNDQsBEoqH9JxuELSZx4d56
	IJuLQ0hgEaPE+/7Z7BDOL0aJjpX7wKrYBNQkvnw5DJTg4BAR0Jdoa9EACTML5EjcfzKLHcQW
	ErCVWPdhNpjNKWAncWrpGbBWYYFgiU8tn1lBbBYBVYnnf54ygdi8QPX/3+5khLAFJX5MvscC
	MVNLYvO2JlYIW15i85q3zCBrJQTUJR791QUJiwgYSTzeN40ZokREYt+Ld4wTGIVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcMw/k9rBuLLB4hCjAAejEg/v
	Dm+HICHWxLLiytxDjBIczEoivDdsHYOEeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YjvJK
	4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgXF5uKXs74SI2Ii6
	/iUCdyQct07xzpK58Vu2c5e57Ndts1fePxJiyvlS9fqSY3XlcwXSf+yNPz9jUb9iupzvNVfV
	zapM6wqrevvm91TkrZ6barluddzcmA2PXlt/P3VfVusGX0yP9XoPo3kmaj9Pzjw554TAE822
	lQ+XmF6zr2xLPta2dIcBh4USS3FGoqEWc1FxIgB6+EAEPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/da903x_bl.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index bbad5c2..12c5d84 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -144,8 +144,9 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_brightness;
-	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
-				       &da903x_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+					data->da903x_dev, data,
+					&da903x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -158,21 +159,12 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int da903x_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
-	return 0;
-}
-
 static struct platform_driver da903x_backlight_driver = {
 	.driver		= {
 		.name	= "da903x-backlight",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= da903x_backlight_probe,
-	.remove		= da903x_backlight_remove,
 };
 
 module_platform_driver(da903x_backlight_driver);
-- 
1.7.10.4


