Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3CFHzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:55:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53544 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3CFHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:55:44 -0500
X-AuditID: cbfee68d-b7f636d0000009be-39-5136f6757840
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 24/30] rtc: rtc-tegra: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:55:32 +0900
Message-id: <009201ce1a3f$fabdd610$f0398230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAASHSA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI93Sb2aBBnPXyVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MU/2PWAtWcFW0HW1ia2A8zdHFyMkhIWAisWN6PyuELSZx4d56
	ti5GLg4hgWWMEueWfGOCKVr15RIjRGIRo8SJSV9YIZzZTBKHW/rYQarYBNQkvnw5DGRzcIgI
	6Eu0tWiA1DAL9DJKnOndDRYXErCV6JnHA1LOKWAnMWXiY7BWYQEPiWvHWthAbBYBVYllp66A
	XcQLVP5x0icoW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoOMlxBQl3j0VxckLCJgJDH1xxeo
	EhGJfS/egd0vIbCIXeLn8QesELsEJL5NPsQC0SsrsekAM8S/khIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoREVu8OxtsHrA8xJgOtn8gsJZqc
	D4zMvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpg
	zGFh1G6R5IkRbfad3uwXW6PK3e8vuW3dbyfpWZnF6Zt/WQk9+FE7ZY3WacZewfv/uf+ui477
	wbGf5fO+lmtcn3j91rcGCOZsUy1++UO7w8/88xI9TfPpfFPNYu9VPZ3ZM8uV0cjteb6K4XTR
	Yv7V4ZNzH3lffdHSbantwrph6nSmHWLlUUFKLMUZiYZazEXFiQDSWHYowgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7pN7NAg5lfJCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqn+R6wFK7gq2o42sTUw
	nuboYuTkkBAwkVj15RIjhC0mceHeerYuRi4OIYFFjBInJn1hhXBmM0kcbuljB6liE1CT+PLl
	MJDNwSEioC/R1qIBUsMs0MsocaZ3N1hcSMBWomceD0g5p4CdxJSJj8FahQU8JK4da2EDsVkE
	VCWWnbrCCmLzApV/nPQJyhaU+DH5HguIzSygJbF+53EmCFteYvOat8wg4yUE1CUe/dUFCYsI
	GElM/fEFqkREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcNw+k97BuKrB4hCjAAejEg/vBBWzQCHWxLLiytxDjBIczEoivFxngEK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0wpeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5Ykpqd
	mlqQWgSzhYmDU6qBceYtq87t7raiu+93sq7YlPu6piVfhmHxY+5ca7lvyycnFaQt6pqmxxJ1
	zi8kbt0BkXCR25/8tVa1PFAwLS07yzPX5/BuH1kLGcPyxTlVjHpGmZ4qC3a/m6/5wWqTzvkn
	DhveP7bznX/31VeNzhdflnCwTqibcWfzV/vSefFln7sVgpL2yJoqKrEUZyQaajEXFScCAPgq
	fIsfAwAA
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-tegra.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 0020bab..8dbf2dc 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -348,8 +348,8 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	info->rtc_dev = rtc_device_register(
-		pdev->name, &pdev->dev, &tegra_rtc_ops, THIS_MODULE);
+	info->rtc_dev = devm_rtc_device_register(
+		&pdev->dev, pdev->name, &tegra_rtc_ops, THIS_MODULE);
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
 		info->rtc_dev = NULL;
@@ -374,17 +374,11 @@ static int __init tegra_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 err_dev_unreg:
-	rtc_device_unregister(info->rtc_dev);
-
 	return ret;
 }
 
 static int __exit tegra_rtc_remove(struct platform_device *pdev)
 {
-	struct tegra_rtc_info *info = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(info->rtc_dev);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


