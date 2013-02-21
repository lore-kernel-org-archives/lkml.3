Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3BUIf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:35:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:17640 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3BUIfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:35:25 -0500
X-AuditID: cbfee68f-b7f656d000000d78-c0-5125dc4483fd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 06/12] rtc: rtc-tps80031: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:35:15 +0900
Message-id: <00d101ce100e$5f879270$1e96b750$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAGCOA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY12XO6qBBpu6JSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGmyP72AsusVcca7nF1MC4mq2LkYNDQsBEYvaHvC5GTiBTTOLC
	vfVAYS4OIYFljBItL08wQSSAan4+ZIZITGeUuPK+hREkISQwm0ni3yEpEJtNQE3iy5fD7CBD
	RQT0JdpaNEDqmQV6GSXO9O5mh6i3lZjz4RoziM0pYCdxedsXVhBbWMBTYtrUsywgNouAqsSU
	A3vA5vAC1Z/9HwUS5hUQlPgx+R5YCbOAlsT6nceZIGx5ic1r3jJD/KIu8eivLkhYRMBI4tzq
	k1AlIhL7XrxjBDlHQmAVu8S7VTugVglIfJt8iAWiV1Zi0wFmiHclJQ6uuMEygVFiFpLNs5Bs
	noVk8ywkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECImq/h2Mdw9YH2JMBlo/kVlK
	NDkfGJV5JfGGxsYmZiamJuaWpuampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cBYyOf4eOqNzwn86zbNFEyO9XaqUPx/ZW5jZaSuCov8fvaQ83MvMlvqvHLSOXBO8HWEkgen
	R/D6P+ab6gLnL5K/+/zhUq333wxuhBVJXHg9Zb2V8gyWRT+mfVpy4fEEzfTEbMt97w3WFItp
	xcu9/tC4LeqN+A4Ho/1T9/oJX2qbYLel+GdVVM9CJZbijERDLeai4kQAcAK98MACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoK7LHdVAg0vXhSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpsj+9gLLrFXHGu5xdTA
	uJqti5GTQ0LARGL2z4fMELaYxIV764HiXBxCAtMZJa68b2EESQgJzGaS+HdICsRmE1CT+PLl
	MHsXIweHiIC+RFuLBkg9s0Avo8SZ3t3sEPW2EnM+XAMbyilgJ3F52xdWEFtYwFNi2tSzLCA2
	i4CqxJQDe8Dm8ALVn/0fBRLmFRCU+DH5HlgJs4CWxPqdx5kgbHmJzWveMoOUSwioSzz6qwsS
	FhEwkji3+iRUiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgqH0mvYNxVYPFIUYBDkYlHt4FL1UChVgTy4orcw8xSnAwK4nwKt5WDRTiTUms
	rEotyo8vKs1JLT7EmAz050RmKdHkfGBCySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTE
	ktTs1NSC1CKYLUwcnFINjHVL8nt4TFbv2nhs7odH8fM3l1vdFxBvYghvN2zdVBahbfXwwam0
	S5XtnzO3XFn50yFs569z5esLpW/e/rPs0dflvr2nVTU+XlV9+f7X/6TmNoGZnKnBhs4tOW21
	7swvmFUmVHtxSSfEbPz6cKbAW+8nh3/GZyvv+eVlfE6zd/6WrZPkai75tiixFGckGmoxFxUn
	AgD57C3NHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tps80031.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-tps80031.c b/drivers/rtc/rtc-tps80031.c
index 9740641..9aaf8aa 100644
--- a/drivers/rtc/rtc-tps80031.c
+++ b/drivers/rtc/rtc-tps80031.c
@@ -285,7 +285,8 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = request_threaded_irq(rtc->irq, NULL, tps80031_rtc_irq,
+	ret = devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+			tps80031_rtc_irq,
 			IRQF_ONESHOT | IRQF_EARLY_RESUME,
 			dev_name(&pdev->dev), rtc);
 	if (ret < 0) {
@@ -302,7 +303,6 @@ static int tps80031_rtc_remove(struct platform_device *pdev)
 {
 	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
 
-	free_irq(rtc->irq, rtc);
 	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
-- 
1.7.2.5


