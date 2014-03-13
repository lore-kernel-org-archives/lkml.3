Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaCMISC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:18:02 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaCMIR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:17:57 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-fe-5321699f480c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 6/8] devfreq: exynos4: Fix power-leakage of clock on suspend
 state
Date: Thu, 13 Mar 2014 17:17:27 +0900
Message-id: <1394698649-20996-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
References: <1394698649-20996-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUHd+pmKwwc+lAhYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MpYcGAhY8EBnor+E32sDYxbuLoYOTkkBEwkXnw8yARhi0lc
	uLeerYuRi0NIYCmjxK6Dl5hgit62TmaGSExnlHj38B1UVSOTxNnG5ywgVWwCWhL7X9xgA7FF
	BMwldi39CVbELPCMSeJWfx/YKGGBMIlfa0+DFbEIqEpc/tnGDmLzCrhKzJqwnB1inZzEhz2P
	wGxOATeJm3engfUKAdVcaJ0CdoaEwFt2iWO/rrBCDBKQ+Db5ENAVHEAJWYlNB5gh5khKHFxx
	g2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGIFxdfrfs4k7GO8fsD7EmAw0biKz
	lGhyPjAu80riDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBsW7XiXaT777tvfazw3KWRul/af1quDHcc+eE94FfWjY2Hwx2vuS850MK7/eM8usXXkTE
	HdrwZu2kLRohNhP8Oqdw80VkrJqqqTPji377+bD7O1ReBM9e7B9oftfJ4tOZk488XLZOsj5Q
	4x4QMeXavitzncuMzq1SzL1a0vCjViDwXNTi6we27VNiKc5INNRiLipOBABbFmxRwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO78TMVggxevOCw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY8GBhYwFB3gq+k/0
	sTYwbuHqYuTkkBAwkXjbOpkZwhaTuHBvPVsXIxeHkMB0Rol3D99BOY1MEmcbn7OAVLEJaEns
	f3GDDcQWETCX2LX0J1gRs8AzJolb/X1MIAlhgTCJX2tPgxWxCKhKXP7Zxg5i8wq4SsyasJwd
	Yp2cxIc9j8BsTgE3iZt3p4H1CgHVXGidwjyBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOCofSa9g3FVg8UhRgEORiUe3hXLFYKFWBPLiitzDzFKcDArifB6+igGC/GmJFZWpRbl
	xxeV5qQWH2JMBrpqIrOUaHI+MKHklcQbGpuYGVkamRtaGBmbkyasJM57sNU6UEggPbEkNTs1
	tSC1CGYLEwenVAMjR+oEHpN5uyxk6w49ldNzTXugd/TPlV2vhD9dary/9lkSe7zb1+mvX81U
	UFnOzxy0qD9/vVHc36juFce7dxzx9jCWsE7Yd2h620tP+eb2pr7awqvG17eu5ar7wBW4aGpE
	RMU19oCt6+XSFyqt2Giic/r9E4P1N4pEuy5Kxe7rTDs0/chdlmmXlFiKMxINtZiLihMBRT2V
	BB4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disable ppmu clocks before entering suspend state to remove
power-leakage and enable ppmu clocks on resume function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 9576ee2..3d35063 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -1251,14 +1251,37 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 static int exynos4_busfreq_resume(struct device *dev)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
+	int i;
+
+	/* Enable clock after wake-up from suspend state */
+	for (i = 0; i < PPMU_END; i++)
+		clk_prepare_enable(data->clk_ppmu[i]);
+
+	/* Reset PPMU to check utilization again */
 
 	busfreq_mon_reset(data);
+
 	return 0;
 }
+
+static int exynos4_busfreq_suspend(struct device *dev)
+{
+	struct busfreq_data *data = dev_get_drvdata(dev);
+	int i;
+
+	/*
+	 * Disable clock before entering suspend state
+	 * to reduce leakage power on suspend state.
+	 */
+	for (i = 0; i < PPMU_END; i++)
+		clk_disable_unprepare(data->clk_ppmu[i]);
+
+	return 0;
+};
 #endif
 
 static const struct dev_pm_ops exynos4_busfreq_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, exynos4_busfreq_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(exynos4_busfreq_suspend, exynos4_busfreq_resume)
 };
 
 static const struct platform_device_id exynos4_busfreq_id[] = {
-- 
1.8.0

