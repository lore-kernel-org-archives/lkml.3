Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3CRJbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:31:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20700 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3CRJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:31:08 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-c3-5146dedb108c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 05/10] rtc: rtc-sa1100: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:31:06 +0900
Message-id: <01bb01ce23bb$513f6a10$f3be3e30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAACuzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI93b99wCDS5f47C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZNxb9YCmYwV3x5s5XxgbGmZxdjJwcEgImEu2ntrNB2GISF+6t
	B7K5OIQEljFK/Nx6kxWm6Nnf++wQiUWMEsd/HGOGcGYzSTyasgqsik1ATeLLl8NAVRwcIgL6
	Em0tGiA1zAK9jBJnenezg9QICdhKzLu2mBHE5hSwk9jaPwmsV1jAU+L8nKVgcRYBVYmNzyaB
	1fMC1a95/5IFwhaU+DH5HpjNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSUy8tBOq
	RERi34t3jCD3SAgsY5dYenMfK8QuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2z
	kGyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxghsdW/g/HuAetDjMlA6ycyS4km
	5wNjM68k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jLM3XU5u73pi7S34I+LM4V6Jo2XN1sU3pRqsDr5YcChyVZ7DXe3zeSaLRdbdvZ53p2r+uudy
	z8xU/j741ObR2bQppe3aWeHzM3eE+nKK2dmHb7tRoOkhekRKSMtl5x8RXgPz/ifbM7TmtMh8
	ESve4el9ueK2g2x2pIzPuSsswQld/9mtisKFlViKMxINtZiLihMBnwKPvcMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO7te26BBgsesFhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjBuLfrAUzOCueHPnK2MD
	40zOLkZODgkBE4lnf++zQ9hiEhfurWfrYuTiEBJYxChx/McxZghnNpPEoymrWEGq2ATUJL58
	OQzUwcEhIqAv0daiAVLDLNDLKHGmdzfYJCEBW4l51xYzgticAnYSW/sngfUKC3hKnJ+zFCzO
	IqAqsfHZJLB6XqD6Ne9fskDYghI/Jt8Ds5kFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGER
	ASOJiZd2QpWISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI7cZ9I7GFc1WBxiFOBgVOLh3bHeLVCINbGsuDL3EKMEB7OSCK/jbaAQb0piZVVq
	UX58UWlOavEhxmSgRycyS4km5wOTSl5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1Kz
	U1MLUotgtjBxcEo1MM45xsmuc8Pxbk6ByP894Tt/fLt86LzhJI3q1Wwelkoust9+//9gc0aq
	3rFxjk3EeVb7wL2NH6///yo/37Pm6PIZBZNP8Qd659c0ffk4JWbDjZf3nFkWJyrKsEZ84D9l
	kTBJqf2M4cQj60912dhVCKfPuJl+8G9t4NfDGtO2lOzxf6By9mFQfrESS3FGoqEWc1FxIgAN
	MhP6IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sa1100.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 5ec5036..7e0a088 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -327,7 +327,7 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int sa1100_rtc_suspend(struct device *dev)
 {
 	struct sa1100_rtc *info = dev_get_drvdata(dev);
@@ -343,13 +343,11 @@ static int sa1100_rtc_resume(struct device *dev)
 		disable_irq_wake(info->irq_alarm);
 	return 0;
 }
-
-static const struct dev_pm_ops sa1100_rtc_pm_ops = {
-	.suspend	= sa1100_rtc_suspend,
-	.resume		= sa1100_rtc_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(sa1100_rtc_pm_ops, sa1100_rtc_suspend,
+			sa1100_rtc_resume);
+
 #ifdef CONFIG_OF
 static struct of_device_id sa1100_rtc_dt_ids[] = {
 	{ .compatible = "mrvl,sa1100-rtc", },
@@ -364,9 +362,7 @@ static struct platform_driver sa1100_rtc_driver = {
 	.remove		= sa1100_rtc_remove,
 	.driver		= {
 		.name	= "sa1100-rtc",
-#ifdef CONFIG_PM
 		.pm	= &sa1100_rtc_pm_ops,
-#endif
 		.of_match_table = of_match_ptr(sa1100_rtc_dt_ids),
 	},
 };
-- 
1.7.2.5


