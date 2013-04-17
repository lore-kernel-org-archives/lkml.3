Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3DQBHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:07:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32879 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3DQBHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:07:18 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-be-516df5c563a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
In-reply-to: <003001ce3b07$d5f29da0$81d7d8e0$%han@samsung.com>
Subject: [PATCH RESEND 2/8] rtc: rtc-bfin: convert bfin_rtc_driver to dev_pm_ops
Date: Wed, 17 Apr 2013 10:07:17 +0900
Message-id: <003101ce3b07$e7599260$b60cb720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B9XUIMaX4YjsSbW0FEYgtMIOOAAAAY/A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI92jX3MDDRY2yFksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcWihRsE93opjj2czNTAu5u5i5OSQEDCRWLRzLzOELSZx4d56ti5GLg4hgWWMEof+
	HWWCKVp7vpcRIrGIUWLChB+sEM4vRok9jS0sIFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhl
	lDjTu5sdpEZIwFbiZschsKmcAnYS347cYQSxhQUCJI4cf8wK0ssioCrx+kElSJgXqLz91hF2
	CFtQ4sfke2CrmAW0JNbvPM4EYctLbF7zlhmkVUJAXeLRX12IC4wkDn+TgKgQkdj34h3Y+RIC
	t9glTj99xgaSYBEQkPg2+RALRKusxKYD0HCQlDi44gbLBEaJWUgWz0KyeBaSxbOQrFjAyLKK
	UTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIyRKJ+5gvH/A+hBjMtD6icxSosn5wCjPK4k3NDYz
	sjA1MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjIGtQ2ie7lSK3
	iv27O+UlWX86Vh/5Y+kkcJxpdYR6j0318swwtzQZjXtvHWf+ufBSs0pnjrlMXD6Xh1dh4rHY
	Aob6NyL3XoUcsX/4UttC39+gQa76hGZA9I2sAhGWp1KCYj1GOxmvFs/jrzgXX2z8r/pZscWE
	dwKJwYt8d+6atH69gO5ZVyWW4oxEQy3mouJEAGM/ZszoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd2jX3MDDa59k7RYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePQQo2Ce7wVxx7PZmpgXMzdxcjJISFgIrH2
	fC8jhC0mceHeerYuRi4OIYFFjBITJvxghXB+MUrsaWxhAaliE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0Avo8SZ3t3sIDVCArYSNzsOMYHYnAJ2Et+O3AHbICwQIHHk+GNWkF4WAVWJ1w8qQcK8
	QOXtt46wQ9iCEj8m3wNbxSygJbF+53EmCFteYvOat8wgrRIC6hKP/upCXGAkcfibBESFiMS+
	F+8YJzAKzUIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAU8Exq
	B+PKBotDjAIcjEo8vBcKcgOFWBPLiitzDzFKcDArifAqrgIK8aYkVlalFuXHF5XmpBYfYkwG
	enMis5Rocj4wPeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A6Pjyfd5rmGVTblbSl+FXqh+/KWpebrUqshc7gPitjqxTg8c38Rm97VHOVxXTuzyFNK881n7
	glBuh+Jc+R8d8f/n2+VsW7Lf7rJ19edz8+oNpSUnHX29oFdoIqNCpGKZWaoFY4dB6+nl3+ZF
	eiyx8Z3ZY7JietKdgMm+j+TmJ7nVCcgLim5lUmIpzkg01GIuKk4EAG9ixidFAwAA
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
 drivers/rtc/rtc-bfin.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 4ec614b..f35b17a 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -402,11 +402,9 @@ static int bfin_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int bfin_rtc_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-
 	dev_dbg_stamp(dev);
 
 	if (device_may_wakeup(dev)) {
@@ -418,10 +416,8 @@ static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int bfin_rtc_resume(struct platform_device *pdev)
+static int bfin_rtc_resume(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
-
 	dev_dbg_stamp(dev);
 
 	if (device_may_wakeup(dev))
@@ -440,20 +436,18 @@ static int bfin_rtc_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-# define bfin_rtc_suspend NULL
-# define bfin_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(bfin_rtc_pm_ops, bfin_rtc_suspend, bfin_rtc_resume);
+
 static struct platform_driver bfin_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-bfin",
 		.owner	= THIS_MODULE,
+		.pm	= &bfin_rtc_pm_ops,
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= bfin_rtc_remove,
-	.suspend	= bfin_rtc_suspend,
-	.resume		= bfin_rtc_resume,
 };
 
 module_platform_driver(bfin_rtc_driver);
-- 
1.7.2.5


