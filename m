Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab3DIOaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:30:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36579 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761106Ab3DIOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:30:01 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-8b-516425e7c617
From: Vivek Gautam <gautam.vivek@samsung.com>
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, a.zummo@towertech.it,
        kgene.kim@samsung.com, s.nawrocki@samsung.com, thomas.ab@samsung.com,
        dianders@chromium.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH] rtc: rtc-s3c: use clk_prepare_enable and clk_disable_unprepare
Date: Tue, 09 Apr 2013 19:57:40 +0530
Message-id: <1365517660-9322-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkSve5akqgwavHKhZLLl5ltzi77CCb
	RduVg+wWvQuusllc3jWHzWLG+X1MFvs7OxgtDr9pZ7XoWMZocWzGEkYHLo/ZDRdZPPZMPMnm
	cefaHjaPvi2rGD2mz/vJ5PF5k1wAWxSXTUpqTmZZapG+XQJXxonnS5kL2ngqHm1xaWB8ydnF
	yMkhIWAisePnFRYIW0ziwr31bF2MXBxCAksZJSb++8cGU3Tz52EmiMR0RonL6x6yQDhTmCSa
	ds9mAqliE9CVaHq7ixHEFhGwkVg5q58VxGYW+MwoMf1nEIgtLOAv0T//MVg9i4CqRP+becxd
	jBwcvALuEj9/B0AsU5B4c/sZM8h8CYFF7BLTZ/5khKgXkPg2+RALSL2EgKzEpgPMEPWSEgdX
	3GCZwCi4gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZgaJ/+96x/B+PdA9aHGJOBxk1k
	lhJNzgfGRl5JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4
	OKUaGA1TTBrYdz67YfgrhMvJ5H53m+v2Wt/S+EbZs2XmmfpLwzn+bL6/Mn0Fw5+OSK1TySlc
	8T93JCQ17/6ptOLGFS2XlkQZNWW5/a/YpJ7OUVi94ovLBiWZL7eX5/F91+4T0hW0NmxKW35B
	+bXw19yzSp3K0qmH2R7+uNvvWnR4dslJtRct8ptOK7EUZyQaajEXFScCAHKGoKiDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQd3nqimBBgtuSFgsuXiV3eLssoNs
	Fm1XDrJb9C64ymZxedccNosZ5/cxWezv7GC0OPymndWiYxmjxbEZSxgduDxmN1xk8dgz8SSb
	x51re9g8+rasYvSYPu8nk8fnTXIBbFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
	lhbmSgp5ibmptkouPgG6bpk5QKcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJA
	AwlrGDNOPF/KXNDGU/Foi0sD40vOLkZODgkBE4mbPw8zQdhiEhfurWfrYuTiEBKYzihxed1D
	FghnCpNE0+7ZYFVsAroSTW93MYLYIgI2Eitn9bOC2MwCnxklpv8MArGFBfwl+uc/BqtnEVCV
	6H8zj7mLkYODV8Bd4ufvAIhlChJvbj9jnsDIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcOQ8k97BuKrB4hCjAAejEg/vhSdJgUKsiWXFlbmHGCU4mJVEeA9JpQQK8aYkVlalFuXH
	F5XmpBYfYkwGWj6RWUo0OR8Y1Xkl8YbGJuamxqaWJhYmZpakCSuJ8x5stQ4UEkhPLEnNTk0t
	SC2C2cLEwSnVwCiiqS10mu+6FSeHRphubef0d3Kyc+VkG7LeSxp/q1l9vbnlqsLr3kPs9hbf
	u+KFVviWv1qvNjOlVbDgx8HpBmtmRnKET8jXsSo5kl1gat185x/nkscKSnfC5387+nTHjoTP
	rpul1B6I696fWv7G/kfyL5bva5LmHP25UPdS5pWS3b5qsvxbXymxFGckGmoxFxUnAgD0ceLj
	4AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.abraham@linaro.org>

Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
calls as required by common clock framework.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

The v1 of this patch is pretty old, but the change needs to be merged to
avoid getting those needless WARN_ON() dumps on console.

Changes from v1:
 - Not using clk_disable_unprepare() at the end of s3c_rtc_probe(), since
   this will unprepare the rtc clock which is again getting used in other
   funtions later.
 - Using clk_unprepare() at the remove() instead to fix things up.

 drivers/rtc/rtc-s3c.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index fb994e9..e3528c9 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -430,6 +430,7 @@ static int s3c_rtc_remove(struct platform_device *dev)
 
 	s3c_rtc_setaie(&dev->dev, 0);
 
+	clk_unprepare(rtc_clk);
 	rtc_clk = NULL;
 
 	return 0;
@@ -498,7 +499,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 
 	/* check to see if everything is setup correctly */
 
@@ -578,7 +579,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return ret;
 }
-- 
1.7.6.5

