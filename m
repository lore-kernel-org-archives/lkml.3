Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaCNJeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:34:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbaCNJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:18 -0400
X-AuditID: cbfee68f-b7f156d00000276c-75-5322cc27ece5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 6/8] devfreq: exynos4: Fix power-leakage of clock on suspend
 state
Date: Fri, 14 Mar 2014 18:30:06 +0900
Message-id: <1394789408-14648-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkQFfjjFKwwQNmi46e3ywW1788Z7WY
	f+Qcq8W5VysZLc42vWG3WNi2hMXi8q45bBafe48wWsw4v4/JYun1i0wWtxtXsFm8+XGWyWLC
	9LUsFo9XvGW3eHWwjcWB32PNvDWMHiuXf2HzWLznJZPHz+Xb2T36tqxi9Dh+YzuTx+dNch4b
	54YGcERx2aSk5mSWpRbp2yVwZazZu4Op4ABPxfbJPawNjFu4uhg5OCQETCTeLg/uYuQEMsUk
	Ltxbz9bFyMUhJLCUUeLy1zXsEAkTiV/dLxkhEosYJRafOM4O4TQySWxbvJ8JpIpNQEti/4sb
	bCC2iIC5xK6lP8FGMQs8Y5K41d8HViQsECax+0wDC4jNIqAq8X/VRbAVvAKuEvenTmWDWCcn
	8WHPI7A4p4CbxNvmaYwgthBQTV/3ASaQoRICH9klfn84xAYxSEDi2+RDLBD/yEpsOsAMMUdS
	4uCKGywTGIUXMDKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiMqdP/nvXvYLx7wPoQYzLQ
	uInMUqLJ+cCYzCuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjGGNd7i0vl7vqWrb3NnSUbxy6ifrU77inbcCW5l4b79YcI/78n6zpK+82gUGQmvm
	qjxnSgr4F9vN9kPz2ISvT3fvtA4wunHfk8+Vqz7Iwr2KObl4eeR7+csSIn22QV9l7Fp8vuz/
	8Df8Rs4HxlzrE673Nt54tKO3T/mHZLVbouSFP1lzwxc3K7EUZyQaajEXFScCALKLmsG/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK76GaVgg08zTC06en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY83eHUwFB3gqtk/u
	YW1g3MLVxcjJISFgIvGr+yUjhC0mceHeerYuRi4OIYFFjBKLTxxnh3AamSS2Ld7PBFLFJqAl
	sf/FDTYQW0TAXGLX0p9gHcwCz5gkbvX3gRUJC4RJ7D7TwAJiswioSvxfdZEdxOYVcJW4P3Uq
	G8Q6OYkPex6BxTkF3CTeNk8DO0MIqKav+wDTBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGCo/aZ1A7GlQ0WhxgFOBiVeHgdDisGC7EmlhVX5h5ilOBgVhLhZZinFCzEm5JYWZVa
	lB9fVJqTWnyIMRnoqonMUqLJ+cCEklcSb2hsYmZkaWRuaGFkbE6asJI474FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjOYv8+3U/djuH9t0MlI/7X+5bECP4sSyk7XuT5k33X0yk3fz3HsbF+pO
	W8nK0Gd48yXXyu1sej9DVoZNfpmR8X57f1Spyylz3WfLN+Ztj1dTfJAm9Wl7k6XbNhnWY/a9
	iSm1HG8XR0751rroV5f+DJl9ceFKN8IC3xb+63jyf/+8nwKPQuetnqXEUpyRaKjFXFScCAAu
	3OJdHgMAAA==
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
index e5d2c5a..65e097a 100644
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

