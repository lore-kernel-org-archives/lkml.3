Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab3CHDqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:46:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8642 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3CHDqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:46:04 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-8c-51395ef6f3bf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pwm: ab8500: use devm_kzalloc()
Date: Fri, 08 Mar 2013 12:45:58 +0900
Message-id: <000001ce1baf$71e96130$55bc2390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4br25fDUxF90+WS3mW8dl9qoGSMQ==
Content-language: ko
x-cr-hashedpuzzle: P6I= B2Cq CBrU Idta LxEg OGSF O8RK Pdb+ QDym R9eI USPi U0Tg
 VvOm YEl8 eqjO
 h5zK;3;agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwB0AGgAaQBlAHIAcgB5AC4AcgBlAGQAaQBuAGcAQABhAHYAaQBvAG4AaQBjAC0AZABlAHMAaQBnAG4ALgBkAGUA;Sosha1_v1;7;{5D7C21DF-74D9-4A50-837C-0E1834C9D375};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 08 Mar 2013 03:45:52
 GMT;WwBQAEEAVABDAEgAXQAgAHAAdwBtADoAIABhAGIAOAA1ADAAMAA6ACAAdQBzAGUAIABkAGUAdgBtAF8AawB6AGEAbABsAG8AYwAoACkA
x-cr-puzzleid: {5D7C21DF-74D9-4A50-837C-0E1834C9D375}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zfd1vcZaBBj/36lhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mc8t3sBXM4Kr4c3MPYwPjPI4uRk4OCQETiaUHrjND2GISF+6t
	Z+ti5OIQEljGKLFrVj8zTNHTLd+ZQGwhgUWMErtnuEMUzWaSeLlxMTtIgk1ATeLLl8NgtoiA
	ucSSRXuBmjk4mAVcJI5OEwEJCwsYSPzfewpsJouAqsTHHYfBbF4BW4m37yazQdiCEj8m32MB
	sZkFtCTW7zzOBGHLS2xe8xZspISAusSjv7oQm/QkDu2ZzQ5RIiKx78U7RpDTJAS2sEhMOvWY
	EaLeVGLZRSaIV5axS/z7JwpxgoDEt8mHWCBKZCU2HYD6VlLi4IobLBMYJWYhOWgWkoNmITlo
	FpLNCxhZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmKERNXEHYz3D1gfYkwGWj+RWUo0OR8Y
	lXkl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLij
	Zesq1rvPr2q9rpT+cfqRYdmCnpy+V/MvVXnWKEh4Fc9f8aaQ//165sOM+85c5b5wxYQt6ehU
	hYy9l2plrj+v6ShVMA4Iz88++fGSe962ws1BcZOUpYucbJ5PvbKukMnnZBHLFb3Xixxitl8q
	dU7yTShy2BuzdDGvxdTlYnMa7X5lB0oc/KvEUpyRaKjFXFScCADZ8sOKwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO63OMtAgwXTNSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxrnlO9gKZnBV/Lm5h7GB
	cR5HFyMnh4SAicTTLd+ZIGwxiQv31rOB2EICixglds9w72LkArJnM0m83LiYHSTBJqAm8eXL
	YTBbRMBcYsmivcxdjBwczAIuEkeniYCEhQUMJP7vPcUMYrMIqEp83HEYzOYVsJV4+24yG4Qt
	KPFj8j0WEJtZQEti/c7jTBC2vMTmNW/BRkoIqEs8+qsLsUlP4tCe2ewQJSIS+168YwQ5TUJg
	C4vEpFOPGSHqTSWWXWSawCg0C8mGWUg2zEKyYRaSUQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al
	6yXn525iBEftM+kdjKsaLA4xCnAwKvHwVmyyCBRiTSwrrsw9xCjBwawkwvtbxjJQiDclsbIq
	tSg/vqg0J7X4EGMyMAAmMkuJJucDE0peSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5ak
	ZqemFqQWwWxh4uCUamDcktt88rCTrk+0ictnxnuGNafv37UXmtm+LJsv9eSBwysU5hzytxbx
	jbObbtm67Ooea3ZOMZYNb1K0b7ssWfLW4XNn+cEFTLIbdL9LLBK4X2n5ISv4xJl7zIkhT06H
	HZJaHl7KLSKW8OKJJvvB2tI0m0ce3FNOHT3cfWRHSp6x/7sbm74dONOpxFKckWioxVxUnAgA
	ZbYgGB4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-ab8500.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-ab8500.c b/drivers/pwm/pwm-ab8500.c
index 4248d04..93af1bb 100644
--- a/drivers/pwm/pwm-ab8500.c
+++ b/drivers/pwm/pwm-ab8500.c
@@ -99,7 +99,7 @@ static int ab8500_pwm_probe(struct platform_device *pdev)
 	 * Nothing to be done in probe, this is required to get the
 	 * device which is required for ab8500 read and write
 	 */
-	ab8500 = kzalloc(sizeof(*ab8500), GFP_KERNEL);
+	ab8500 = devm_kzalloc(&pdev->dev, sizeof(*ab8500), GFP_KERNEL);
 	if (ab8500 == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -111,10 +111,8 @@ static int ab8500_pwm_probe(struct platform_device *pdev)
 	ab8500->chip.npwm = 1;
 
 	err = pwmchip_add(&ab8500->chip);
-	if (err < 0) {
-		kfree(ab8500);
+	if (err < 0)
 		return err;
-	}
 
 	dev_dbg(&pdev->dev, "pwm probe successful\n");
 	platform_set_drvdata(pdev, ab8500);
@@ -132,7 +130,6 @@ static int ab8500_pwm_remove(struct platform_device *pdev)
 		return err;
 
 	dev_dbg(&pdev->dev, "pwm driver removed\n");
-	kfree(ab8500);
 
 	return 0;
 }
-- 
1.7.2.5


