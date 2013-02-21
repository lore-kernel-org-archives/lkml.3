Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab3BUIhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:37:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48490 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3BUIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:37:40 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-43-5125dcd4341b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 11/12] rtc: rtc-max8997: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:37:39 +0900
Message-id: <00d601ce100e$b52bb490$1f831db0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAALXLg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfd0rd1QDDebdZra4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZaw8dZC9YylExf8kn5gbGp2xdjJwcEgImEu37lzFC2GISF+6t
	B4pzcQgJLGOUmLrvCAtM0en7y8FsIYFFjBJ/ToRAFM1mkmjbMp8VJMEmoCbx5cth9i5GDg4R
	AX2JthYNkBpmgV5GiTO9u9khmm0l5ny4xgxicwrYSVze9oUVpF5YwENi/5IikDCLgKrE8sZf
	YLt4gcov32tnhLAFJX5MvgcWZxbQkli/8zgThC0vsXnNW2aQMRIC6hKP/uqChEUEjCRu7rsD
	VSIise/FO0aQcyQElrFL7Nx2kQ1il4DEt8mHWCB6ZSU2HWCGeFdS4uCKGywTGCVmIdk8C8nm
	WUg2z0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkLjq3cF4+4D1IcZkoPUTmaVE
	k/OBcZlXEm9obGxiZmJqYm5pam5KmrCSOK/cJZlAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYwSb269KJVLkDTyvyVmdfD5ueINZWfXrTLm6cpbYc9vILLJeabB9pM7OEXrbbntCu60Xz8v
	9f9+uYucSCLPk9MXeYpeKeS/Wi64vaP5/ArJR7dK3p4/o/tKLkxgRfEjvS33O8ONk09euFjc
	ObfOKePDtElFF/JmTSjO/rLSu85GYpH/YrV7uvOUWIozEg21mIuKEwF4RVwcwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7lO6qBBmcabSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtpDB9kLlnJUzF/yibmB
	8SlbFyMnh4SAicTp+8tZIGwxiQv31oPFhQQWMUr8ORHSxcgFZM9mkmjbMp8VJMEmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u9khmm0l5ny4xgxicwrYSVze9oUVpF5YwENi/5IikDCL
	gKrE8sZfYHt5gcov32tnhLAFJX5MvgcWZxbQkli/8zgThC0vsXnNW2aQMRIC6hKP/uqChEUE
	jCRu7rsDVSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOGqfSe1gXNlgcYhRgINRiYd3wUuVQCHWxLLiytxDjBIczEoivIq3VQOFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YUPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1
	OzW1ILUIZgsTB6dUA+PUB1eepLfI3A8MOh7t2TSl7vA1xi2Xdh/pChTqmi8r0dfX6fY+vE3x
	llCNfKss1xPP1epPrvbPauSYU96xODHm5ennE+uWG3HNWNnR+Da1R1w+7n3tZufzB2uePYg1
	iln/YolcVsIO1dcpvTcfpBxe9yuQWfb7j0Mx9ZoPl2vuuzM1a1G+g6ESS3FGoqEWc1FxIgBt
	9MoyHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max8997.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index a4e7079..00e505b 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -495,7 +495,8 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	}
 	info->virq = virq;
 
-	ret = request_threaded_irq(virq, NULL, max8997_rtc_alarm_irq, 0,
+	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
+				max8997_rtc_alarm_irq, 0,
 				"rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
@@ -514,10 +515,8 @@ static int max8997_rtc_remove(struct platform_device *pdev)
 {
 	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
 
-	if (info) {
-		free_irq(info->virq, info);
+	if (info)
 		rtc_device_unregister(info->rtc_dev);
-	}
 
 	return 0;
 }
-- 
1.7.2.5


