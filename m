Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3CRJaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:30:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48394 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3CRJaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:30:08 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-50-5146de9f3f54
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 02/10] rtc: rtc-mxc: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:30:06 +0900
Message-id: <01b801ce23bb$2d6f2bc0$884d8340$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAAAaTA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zfd3599wCDbZ2s1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MfXcfMhbM5qw4tuYrWwPjVvYuRk4OCQETiYZ3h1ghbDGJC/fW
	s3UxcnEICSxjlLj/uZeli5EDrGjF3niI+CJGiQtty1ggnNlMEnNnN4N1swmoSXz5cpgdpEFE
	QF+irUUDpIZZoJdR4kzvbrBtQgK2EvOuLWYEsTkF7CS29k8C6xUWcJOY2/aaCcRmEVCV+DN/
	KpjNC1R/b9oiVghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yQxyqLvHory5IWETASOLS9cus
	ECUiEvtevGMEuUdCYBm7xMVdT9ghdglIfJt8COpJWYlNB5ghASEpcXDFDZYJjBKzkGyehWTz
	LCSbZyFZsYCRZRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGSGT172C8e8D6EGMy0PqJzFKi
	yfnAyMwriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dU
	AyPrVHMGvbWa66VlmMIOp144J8tyjU/rzNWj1/bJ3/G2KlP7ErifqVJI4HXQQ/tvrH9sdHds
	m/dq9TzrK/Knt2pdsXT42rjcdFFtB7uEg/+EmhmBHYoy9jvePmbuParn+fTnzD3Ppi5deiFY
	eI+s4gcFgaeP7XUNNU3elUroiL4NuN8i823VfDElluKMREMt5qLiRACA1i2LwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO68e26BBrevWltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjH13HzIWzOasOLbmK1sD
	41b2LkYODgkBE4kVe+O7GDmBTDGJC/fWs3UxcnEICSxilLjQtowFwpnNJDF3djMrSBWbgJrE
	ly+HwZpFBPQl2lo0QGqYBXoZJc707mYHqRESsJWYd20xI4jNKWAnsbV/ElivsICbxNy210wg
	NouAqsSf+VPBbF6g+nvTFrFC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniaHWJR391QcIi
	AkYSl65fZoUoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1ya
	l66XnJ+7iREct8+kdzCuarA4xCjAwajEw7tjvVugEGtiWXFl7iFGCQ5mJRFex9tAId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HppS8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5ak
	ZqemFqQWwWxh4uCUamCs3iGySEEwPjaP7fS0ff1fc9YFyKtahD5u/+g5sSD2SNEcgcdOgvuW
	afk+dtC60DCnWnWFPtdqib7Z97b+3h/77oG6tkEwQyjj0+QHFebvTx6unP3y64qta4LU7zQJ
	3xG81W+5TLQw4XXm8ajtpUoxok++rJ4mYcscKCi+YVqmeQuPLvOTp5OVWIozEg21mIuKEwG/
	wadHHwMAAA==
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
 drivers/rtc/rtc-mxc.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 13380ca..9a3895b 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -470,7 +470,7 @@ static int mxc_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int mxc_rtc_suspend(struct device *dev)
 {
 	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
@@ -490,19 +490,14 @@ static int mxc_rtc_resume(struct device *dev)
 
 	return 0;
 }
-
-static struct dev_pm_ops mxc_rtc_pm_ops = {
-	.suspend	= mxc_rtc_suspend,
-	.resume		= mxc_rtc_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(mxc_rtc_pm_ops, mxc_rtc_suspend, mxc_rtc_resume);
+
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
 		   .name	= "mxc_rtc",
-#ifdef CONFIG_PM
 		   .pm		= &mxc_rtc_pm_ops,
-#endif
 		   .owner	= THIS_MODULE,
 	},
 	.id_table = imx_rtc_devtype,
-- 
1.7.2.5


