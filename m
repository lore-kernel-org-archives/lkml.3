Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCMIRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:17:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8436 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaCMIRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:41 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-78-5321699d0d06
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 4/8] devfreq: exynos4: Fix bug of resource leak and code
 clean on probe()
Date: Thu, 13 Mar 2014 17:17:25 +0900
Message-id: <1394698649-20996-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkRHdupmKwwbQlOhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mo4/24HS8FmoYq3WxuZGhin8ncxcnJICJhIfGp+yQ5hi0lc
	uLeerYuRi0NIYCmjxNvW00wwRaevz2aESExnlNj0bgWU08gkcaO3jw2kik1AS2L/ixtgtoiA
	ucSupT/BRjELPGOSuNXfBzZKWCBWYufCl2A2i4CqxPpbj8B28wq4SuxbeJ4RYp2cxIc9EHFO
	ATeJm3engdULAdVcaJ3CDFHzkl1i321+iDkCEt8mH2LpYuQAistKbDoAVSIpcXDFDZYJjMIL
	GBlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgRG1el/z3p3MN4+YH2IMRlo3ERmKdHkfGBU
	5pXEGxqbGVmYmpgaG5lbmpEmrCTOm/QwKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo+XL
	2+dWft96aOk1h+1HJ2Ylb96tWbmtUSH2WMuXY1Wr/iZ3uTfcM1/esYhPzGlH5cuv11SdVzzr
	uT+rYbGsNkNh8m7p2T7Rapekq9f+8lJSvlMu1lOrruRofO1DQs2x+y23rVZcFjPRnrPs6T2V
	qafO7uH5M9mxhF373dnuEz/n3Sxtfr7r3CklluKMREMt5qLiRABzN+DOwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO7cTMVgg8VHVS06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx4/y7HSwFm4Uq3m5t
	ZGpgnMrfxcjJISFgInH6+mxGCFtM4sK99WxdjFwcQgLTGSU2vVvBCOE0Mknc6O1jA6liE9CS
	2P/iBpgtImAusWvpT7AOZoFnTBK3+vuYQBLCArESOxe+BLNZBFQl1t96xA5i8wq4SuxbeB5q
	nZzEhz0QcU4BN4mbd6eB1QsB1VxoncI8gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95Pzc
	TYzgqH0mvYNxVYPFIUYBDkYlHt4VyxWChVgTy4orcw8xSnAwK4nwevooBgvxpiRWVqUW5ccX
	leakFh9iTAa6aiKzlGhyPjCh5JXEGxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUg
	tQhmCxMHp1QDo9SCWVLJ2pG99Xv+TOk58dvu8sfl6nv3nrP3UtrbY2+89u+x5U61igW/ojLz
	Vu14PKU1zepUEn/1ry8HaiTq5FenPmkPueCpXPL00qynfXfrLM4VC60TES7WVLMr+K3gEeGv
	17Tm0fODM19vXXaiX1dz2bt2BU2ODy7rXp39sPXI0hpzcedNTUosxRmJhlrMRcWJAFTwPYwe	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug about resource leak when happening probe fail and code clean
to add debug message.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index a2a3a47..152a3e9 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -1152,8 +1152,11 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		dev_err(dev, "Cannot determine the device id %d\n", data->type);
 		err = -EINVAL;
 	}
-	if (err)
+	if (err) {
+		dev_err(dev, "Cannot initialize busfreq table %d\n",
+			     data->type);
 		return err;
+	}
 
 	rcu_read_lock();
 	opp = dev_pm_opp_find_freq_floor(dev,
@@ -1176,7 +1179,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	if (IS_ERR(data->devfreq)) {
 		dev_err(dev, "Failed to add devfreq device\n");
 		err = PTR_ERR(data->devfreq);
-		goto err_opp;
+		goto err_devfreq;
 	}
 
 	/*
@@ -1185,18 +1188,35 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	 */
 	busfreq_mon_reset(data);
 
-	devfreq_register_opp_notifier(dev, data->devfreq);
+	/* Register opp_notifier for Exynos4 busfreq */
+	err = devfreq_register_opp_notifier(dev, data->devfreq);
+	if (err < 0) {
+		dev_err(dev, "Failed to register opp notifier\n");
+		goto err_notifier_opp;
+	}
 
+	/* Register pm_notifier for Exynos4 busfreq */
 	err = register_pm_notifier(&data->pm_notifier);
 	if (err) {
 		dev_err(dev, "Failed to setup pm notifier\n");
-		devfreq_remove_device(data->devfreq);
-		return err;
+		goto err_notifier_pm;
 	}
 
 	return 0;
 
-err_opp:
+err_notifier_pm:
+	devfreq_unregister_opp_notifier(dev, data->devfreq);
+err_notifier_opp:
+	/*
+	 * The devfreq_remove_device() would execute finally devfreq->profile
+	 * ->exit(). To avoid duplicate resource free operation, return directly
+	 * before executing resource free below 'err_devfreq' goto statement.
+	 */
+	devfreq_remove_device(data->devfreq);
+
+	return err;
+
+err_devfreq:
 	regulator_disable(data->vdd_int);
 	if (data->type == TYPE_BUSF_EXYNOS4x12)
 		regulator_disable(data->vdd_mif);
-- 
1.8.0

