Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaCMIRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:17:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:12852 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCMIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:37 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-ed-5321699e1391
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 5/8] devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
Date: Thu, 13 Mar 2014 17:17:26 +0900
Message-id: <1394698649-20996-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkRHdepmKwQeMPCYuOnt8sFte/PGe1
	mH/kHKvFuVcrGS3ONr1ht1jYtoTF4vKuOWwWn3uPMFrMOL+PyWLp9YtMFrcbV7BZvPlxlsli
	wvS1LBaPV7xlt3h1sI3Fgd9jzbw1jB4rl39h81i85yWTx8/l29k9+rasYvQ4fmM7k8fnTXIe
	G+eGBnBEcdmkpOZklqUW6dslcGVs/XyHqWARR8WbN3OYGxib2LsYOTkkBEwk/q49BmWLSVy4
	t56ti5GLQ0hgKaNE89O1jDBFMz90skMkpjNKPLiwjxHCaWSSONv4nAWkik1AS2L/ixtsILaI
	gLnErqU/wUYxCzxjkrjV38cEkhAW8JKYPGMqWBGLgKrEp58gKzg4eAVcJZ60MUFsk5P4sOcR
	2EmcAm4SN+9OA4sLAZVcaJ3CDDJTQuAtu8TUCw1MEHMEJL5NPsQCMkdCQFZi0wFmiDmSEgdX
	3GCZwCi8gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgVJ3+92ziDsb7B6wPMSYDjZvI
	LCWanA+MyrySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYJQsY2yf4uehqOa1VrdLbOmtRJZj0Rvzju51vHTo//5DXcZx3ay5XUqMRYFbJv/ZY6fc
	9y6pb+PUm+cldihbdXyMm2N8/XvpL5tFPm5dG5hS244tEDnAuCZBJ/beLO7z137/UNlRFnxE
	xTE9ozhpX/s2//vuFd8f8hu28019/ffkNW7+KS92NCqxFGckGmoxFxUnAgASXeXZwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoO68TMVgg8UXhCw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY+vnO0wFizgq3ryZ
	w9zA2MTexcjJISFgIjHzQyeULSZx4d56ti5GLg4hgemMEg8u7GOEcBqZJM42PmcBqWIT0JLY
	/+IGG4gtImAusWvpT7AOZoFnTBK3+vuYQBLCAl4Sk2dMBStiEVCV+PRzLdAkDg5eAVeJJ21M
	ENvkJD7seQS2mVPATeLm3WlgcSGgkgutU5gnMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66X
	nJ+7iREcs8+kdzCuarA4xCjAwajEw7tiuUKwEGtiWXFl7iFGCQ5mJRFeTx/FYCHelMTKqtSi
	/Pii0pzU4kOMyUBHTWSWEk3OB6aTvJJ4Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGan
	phakFsFsYeLglGpgzDPZsvPPSSn2yQ9L9MX2NoSF3Gmct5ptwV2Fq0K8Z25MPvnKzHnvU2e1
	ktlPFhS/33RbY7vpst3O88UZvy8IMmjvCgw84Z51Xy5XWTl2yuKTW4T4Nx/PDCjcu/o7Y+/H
	Szv4s6MMguW1I6513uFrS6lOlnr4cJaAysmEHiuuggn75utMOal/W4mlOCPRUIu5qDgRAJ89
	flEdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 152a3e9..9576ee2 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -1247,6 +1247,7 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int exynos4_busfreq_resume(struct device *dev)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
@@ -1254,9 +1255,10 @@ static int exynos4_busfreq_resume(struct device *dev)
 	busfreq_mon_reset(data);
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops exynos4_busfreq_pm = {
-	.resume	= exynos4_busfreq_resume,
+	SET_SYSTEM_SLEEP_PM_OPS(NULL, exynos4_busfreq_resume)
 };
 
 static const struct platform_device_id exynos4_busfreq_id[] = {
-- 
1.8.0

