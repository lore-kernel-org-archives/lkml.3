Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3DQBIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:08:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33223 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3DQBIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:08:41 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-5d-516df61732ce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 6/8] rtc: rtc-spear: convert spear_rtc_driver to
 dev_pm_ops
Date: Wed, 17 Apr 2013 10:08:39 +0900
Message-id: <003501ce3b08$187549c0$495fdd40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAADbRA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY13xb7mBBg37LS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmDTrGFPBEoGKe0/iGhgv8HYxcnJICJhILP30ghXCFpO4cG89WxcjF4eQwDJGiYvf
	z7J3MXKAFT3fZQcRn84ocWdaIzuE84tRonftSnaQbjYBNYkvXw6DNYgI6Eu0tWiA1DAL9DJK
	nOndDVYjJGArcbPjEBOIzSlgJ/HtyB1GEFtYIERiyvp5rCC9LAKqErO+hYGEeYHKn89cwQJh
	C0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiDvVJR791QUJiwgYSfy9sYMNokREYt+Ld4wg50gI
	3GOXONZ7Cmwti4CAxLfJh1ggemUlNh1ghoSDpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZV
	jKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCFR2r+D8e4B60OMyUDrJzJLiSbnA6M8ryTe0NjM
	yMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MwkYqrDs9j0/g
	rrcvv3NAa8WHnGdr1LjObgy+efb2yrMm4pwZ8cytwUsctsbrpan9r4lNVZC0ODU7z/nM5N6J
	cvd4QoImu/Ym7K9lk/HYmcyTk7o4QTo8XmX2oQS/NGXOVs7VuraKV7Nm+RT84j4cn2hsWbnK
	oY2bd/fq1BOf3nTqyTg7vlNiKc5INNRiLipOBACVFhJg6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV3xb7mBBosumVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDFp1jGmgiUCFfeexDUwXuDtYuTgkBAwkXi+
	y66LkRPIFJO4cG89WxcjF4eQwHRGiTvTGtkhnF+MEr1rV7KDVLEJqEl8+XKYHaRZREBfoq1F
	A6SGWaCXUeJM726wGiEBW4mbHYeYQGxOATuJb0fuMILYwgIhElPWz2MF6WURUJWY9S0MJMwL
	VP585goWCFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveMkPcrC7x6K8uSFhEwEji740dbBAlIhL7
	XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJTwDPp
	HYyrGiwOMQpwMCrx8F4oyA0UYk0sK67MPcQowcGsJMKruAooxJuSWFmVWpQfX1Sak1p8iDEZ
	6M+JzFKiyfnA9JRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYzTvXzUNQ40XdZ01i4WNG47c2EZQ+YrYTPfuVe0Pzd94r0a8fzDAQ+PV7fDu96tu/ZxpetU
	p7sN/xkTPy3YGfascm+Y9EPj9OSNoY4nJrnpK/3KWzKpJ/6ByyHOAC6XvZ4Ce19vM1sV32yS
	6uZ9xvhTuHX2M1Mvj307q57InfzkafO9a8HuzDolluKMREMt5qLiRACE3eJuRQMAAA==
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


