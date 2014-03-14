Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbaCNJcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:32:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59049 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbaCNJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:24 -0400
X-AuditID: cbfee690-b7f266d00000287c-c8-5322cc27a1a2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 5/8] devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro
Date: Fri, 14 Mar 2014 18:30:05 +0900
Message-id: <1394789408-14648-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsWyRsSkUFf9jFKwwYV3UhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4Mro/7qLsWARR8XS1jlMDYxN7F2MHBwSAiYS+5ZJdzFyApli
	EhfurWfrYuTiEBJYyijx7fchZoiEicTv61MYIRKLGCWmrfvDCuE0MklsW7yfCaSKTUBLYv+L
	G2wgtoiAucSupT/BRjELPGOSuNXfB1YkLOAlsfbEA3YQm0VAVWLV80OMIDavgKtEy66/UOvk
	JD7seQRWwyngJvG2eRpYjRBQTV/3ASaQoRICb9kldmztZ4EYJCDxbfIhFoh/ZCU2HYCaIylx
	cMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBEbV6X/PJuxgvHfA+hBjMtC4
	icxSosn5wKjMK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbGaXICL3Jn2TyUb4trbQ/8sD5l8dq2WeEPpyhsUF75MdB1raT+rZV8LNcaX8ZN3zfn
	VUxH2L4QE598Jh2F5iUnZpexVsywr35S9+HChW0p5mx6RZO71nyx9g2cd9PasTlRQS3SMZLx
	Sr/POZndjxN+BmdlTHFi+fjIRkV6u4H2pA2H1gQGPj6hxFKckWioxVxUnAgAh8IwzcACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK76GaVgg64LwhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCIamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
	zAG6XkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY0f91F2PBIo6Kpa1z
	mBoYm9i7GDk5JARMJH5fn8IIYYtJXLi3nq2LkYtDSGARo8S0dX9YIZxGJolti/czgVSxCWhJ
	7H9xgw3EFhEwl9i19CdYB7PAMyaJW/19YEXCAl4Sa088AFvBIqAqser5IbAVvAKuEi27/jJD
	rJOT+LDnEVgNp4CbxNvmaWA1QkA1fd0HmCYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpec
	n7uJERy1z6R2MK5ssDjEKMDBqMTD63BYMViINbGsuDL3EKMEB7OSCC/DPKVgId6UxMqq1KL8
	+KLSnNTiQ4zJQFdNZJYSTc4HJpS8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqem
	FqQWwWxh4uCUamBc65h+IXWqxi1j8WmCgSVsMZouMRwKfP2RR7dv2d/px3zL/JpJcPRCJWkt
	22/r9azc/mzzfGj7JOHcr1sOXguP3NxxwFHsp/r5mBTDRSedF3bEGjPau27hvmOuVD9Ncdfk
	nYW/eNUf39x066Nm1y57Dr3pbPKqF9v+yhQ1PV6zlifu453XF12UWIozEg21mIuKEwGGgN2V
	HgMAAA==
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
index 60539e8..e5d2c5a 100644
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

