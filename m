Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab3C1Ijf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:39:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15095 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab3C1Ijb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:39:31 -0400
X-AuditID: cbfee68d-b7f786d000005188-08-515401c189e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
In-reply-to: <001001ce2b8f$61824c90$2486e5b0$%han@samsung.com>
Subject: [PATCH 7/8] rtc: rtc-stmp3xxx: convert stmp3xxx_rtcdrv to dev_pm_ops
Date: Thu, 28 Mar 2013 17:39:29 +0900
Message-id: <001601ce2b8f$c333e980$499bbc80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rj2FhCGvCEF7CQ36UwoHUUgpQOwAAFZgw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ92DjCGBBque6lgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0TW9g7VgMn/FvoVzmBoYL/F0MXJwSAiYSLz6qdbFyAlkiklcuLeerYuRi0NIYBmj
	RGPvRhaIhInE7GfHmSASixgl2s+cY4ZwfjFKnDp9hg2kik1ATeLLl8PsIFNFBPQl2lo0QGqY
	BXoZJc707mYHqRESsJU4d/gqM4jNKWAn0b5mK9gGYQFfia9LlrCB9LIIqEqc/csFEuYFKp95
	bw0ThC0o8WPyPbByZgEtifU7jzNB2PISm9e8ZYZ4Rl3i0V9dkLCIgJHEoU0foUpEJPa9eMcI
	co6EwCN2iY2PmlhBEiwCAhLfJh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8C8mK
	BYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFC4rR3B+PtA9aHGJOB1k9klhJNzgfGeV5J
	vKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGEME3v11
	9E3ecLL05OlJOzu+XeY+uZu5rGnJ+58Nx9OK3ys1is++MNHzs92hi8bZ3Y+n/n/VHOpcb3Z5
	l9XdfxcXvcnfmiD6cr7K6SYezm2P318s7/X3TTZm9s9ZfO3Y53i+G+z3uNl3bWN7MfNjwKay
	O38qM98ETRdWybvKXp94pr4ndPrjBVJKLMUZiYZazEXFiQAJHPCZ6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd2DjCGBBv03NSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOia3sFaMJm/Yt/COUwNjJd4uhg5OSQETCRm
	PzvOBGGLSVy4t56ti5GLQ0hgEaNE+5lzzBDOL0aJU6fPsIFUsQmoSXz5cpi9i5GDQ0RAX6Kt
	RQOkhlmgl1HiTO9udpAaIQFbiXOHrzKD2JwCdhLta7aygNjCAr4SX5csYQPpZRFQlTj7lwsk
	zAtUPvPeGiYIW1Dix+R7YOXMAloS63dCHMcsIC+xec1bZpBWCQF1iUd/dUHCIgJGEoc2fYQq
	EZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGc
	Bp5J7WBc2WBxiFGAg1GJh7dCIDhQiDWxrLgy9xCjBAezkgjvoU6gEG9KYmVValF+fFFpTmrx
	IcZkoD8nMkuJJucDU1ReSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYw
	cXBKNTDqFH9WmX5te4qAmPWfQ5V3gvVPfxMKvSvz/MnmBeIq3x/4BS1ufuqWuPxN4dtCdbc7
	RQ8zd5m9eV/z78GFWF63ac/YeZdGf3zqllrYcSN9X3cEk+T8mjNbE1Z94XfcWfFZaPU7ltuP
	Fy+8+lzu77tg7r8HiqWebp4nI7XTftNh6eKM1t0tHwNalViKMxINtZiLihMB44ymh0cDAAA=
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
 drivers/rtc/rtc-stmp3xxx.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 98f0d3c..22f72b5 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -309,15 +309,15 @@ out_free:
 	return err;
 }
 
-#ifdef CONFIG_PM
-static int stmp3xxx_rtc_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int stmp3xxx_rtc_suspend(struct device *dev)
 {
 	return 0;
 }
 
-static int stmp3xxx_rtc_resume(struct platform_device *dev)
+static int stmp3xxx_rtc_resume(struct device *dev)
 {
-	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
+	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
 	mxs_reset_block(rtc_data->io);
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
@@ -326,11 +326,11 @@ static int stmp3xxx_rtc_resume(struct platform_device *dev)
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 	return 0;
 }
-#else
-#define stmp3xxx_rtc_suspend	NULL
-#define stmp3xxx_rtc_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(stmp3xxx_rtc_pm_ops, stmp3xxx_rtc_suspend,
+			stmp3xxx_rtc_resume);
+
 static const struct of_device_id rtc_dt_ids[] = {
 	{ .compatible = "fsl,stmp3xxx-rtc", },
 	{ /* sentinel */ }
@@ -340,11 +340,10 @@ MODULE_DEVICE_TABLE(of, rtc_dt_ids);
 static struct platform_driver stmp3xxx_rtcdrv = {
 	.probe		= stmp3xxx_rtc_probe,
 	.remove		= stmp3xxx_rtc_remove,
-	.suspend	= stmp3xxx_rtc_suspend,
-	.resume		= stmp3xxx_rtc_resume,
 	.driver		= {
 		.name	= "stmp3xxx-rtc",
 		.owner	= THIS_MODULE,
+		.pm	= &stmp3xxx_rtc_pm_ops,
 		.of_match_table = of_match_ptr(rtc_dt_ids),
 	},
 };
-- 
1.7.2.5


