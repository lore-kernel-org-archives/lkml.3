Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3BUIfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:35:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48128 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3BUIfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:35:46 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-d8-5125dc5d504c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 07/12] rtc: rtc-wm831x: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:35:40 +0900
Message-id: <00d201ce100e$6e66f1f0$4b34d5d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAHGNA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ93YO6qBBv+/CVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MC/v6WAtmc1bse+zTwHiYvYuRk0NCwERi/p35LBC2mMSFe+vZ
	uhi5OIQEljFK3L7TygZTdGv3XXaIxCJGic8zdrBCOLOZJI68OAhWxSagJvHlC8hYDg4RAX2J
	thYNkBpmgV5GiTO9u8HWCQnYSsz5cI0ZxOYUsJO4vO0LK4gtLOAusb9hGdgcFgFVic23ljKB
	2LxA9Z8+roWyBSV+TL4HdiqzgJbE+p3HmSBseYnNa94yg+yVEFCXePRXFyQsImAk0XVwClS5
	iMS+F+8YQe6REFjELvHuVQMTxC4BiW+TD7FA9MpKbDrADPGwpMTBFTdYJjBKzEKyeRaSzbOQ
	bJ6FZMUCRpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCGR1buD8fYB60OMyUDrJzJLiSbn
	AyMzryTe0NjYxMzE1MTc0tTclDRhJXFeuUsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	l73RMOqcdDwrNXSdpGNzwsk2lR6paXM+31XZcS/3zRHOWeeilEUkTBKUGiZvFowVdLksnvHx
	5SKDwzodi2Q2Ngl+DfpU+NJW4MuqeQk/vi57fsBKja29vNlxbraNH+u5ktf5hqEbza1d/wpe
	NVhx00lI9tE/u3Ozv0+x5fm/POztj+r5i/NklViKMxINtZiLihMBHRqm/MICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7sHdVAgx8P+Swu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoV9fawFszkr9j32aWA8
	zN7FyMkhIWAicWv3XShbTOLCvfVsXYxcHEICixglPs/YwQrhzGaSOPLiIBtIFZuAmsSXLyDd
	HBwiAvoSbS0aIDXMAr2MEmd6d4NNEhKwlZjz4RoziM0pYCdxedsXVhBbWMBdYn/DMrA5LAKq
	EptvLWUCsXmB6j99XAtlC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSM
	JLoOToEqF5HY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66X
	nJ+7iREct8+kdjCubLA4xCjAwajEw7vgpUqgEGtiWXFl7iFGCQ5mJRFexduqgUK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0wpeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5Ykpqd
	mlqQWgSzhYmDU6qBsbZgIZvmMVvD2W9Xd+VLmslv+tkuHB67UPTC8la1+Ycv1MaX/fvnvOL2
	M7t8nmP7rDYm7b77JFZPsNV/kr21dUZ464Pp6W0pqwNfzqsyvbmnYA6fj0DBlNpZn/67rm2Y
	lfBUcUNuZueOJNmWcuXvpn8+fdol1rJikpMSI9O0vK/s/7TC3wu1KLEUZyQaajEXFScCALnQ
	coEfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-wm831x.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 1b0affb..2f0ac7b 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -443,9 +443,10 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	ret = request_threaded_irq(alm_irq, NULL, wm831x_alm_irq,
-				   IRQF_TRIGGER_RISING, "RTC alarm",
-				   wm831x_rtc);
+	ret = devm_request_threaded_irq(&pdev->dev, alm_irq, NULL,
+				wm831x_alm_irq,
+				IRQF_TRIGGER_RISING, "RTC alarm",
+				wm831x_rtc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
 			alm_irq, ret);
@@ -462,9 +463,7 @@ err:
 static int wm831x_rtc_remove(struct platform_device *pdev)
 {
 	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 
-	free_irq(alm_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
 
 	return 0;
-- 
1.7.2.5


