Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LKOIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:08:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58611 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3LKOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:08:09 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-f2-52a871c69e28
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] mfd: s2mps11: Fix build after regmap field rename in sec-core.c
Date: Wed, 11 Dec 2013 15:07:43 +0100
Message-id: <1386770863-32247-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xa7rHClcEGTTOM7OYs34Nm8XUh0/Y
	LFZv8rV4/cLQ4mzTG3aLb1c6mCw2Pb7GanF51xw2i7VH7rJbPJ1wkc3i4oovTA7cHoffvGf2
	2DnrLrvHplWdbB53ru1h8zgx4zeLx+Yl9R59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CV8eNr
	J2PBK4GK718uMjYwdvJ1MXJySAiYSNzoXcQCYYtJXLi3nq2LkYtDSGApo8Stvi8sEE4fk8Tr
	O//AqtgEjCU2L18CViUisJ5J4vm6tcwgDrNAL6PEg3e/GEGqhAUCJBbP2sIOYrMIqEps2vgQ
	qJuDg1fAXWLGhVIQU0JAQWLOJJsJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE
	2dcdjEuPWR1iFOBgVOLhPVC0PEiINbGsuDL3EKMEB7OSCO8nzxVBQrwpiZVVqUX58UWlOanF
	hxiZODilGhizpFsyNvtvdfOa/n2tctIVUdd7i+uFe7bIPNxhZTVFY31v9b9DD1l2ree/t2J9
	1sLTTSpGLOcvPKyVetHMMYn5wo/Kl+rX1LX53k09tTCETfr9kqTd1/ryLO43npmT0BB54Nav
	mycO/w5snvf2szKns1VTI7OSGLvfE602LjG/r6Jvf/gYqC1RYinOSDTUYi4qTgQA2nGtDBEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of s2mps11 regulator and clock drivers after renaming
regmap field in struct sec_pmic_dev in commit:
 - "mfd/rtc: s5m: Fix register updating by adding regmap for RTC"

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c   |    6 +++---
 drivers/regulator/s2mps11.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 7be41e676a64..00a3abe103a5 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -60,7 +60,7 @@ static int s2mps11_clk_prepare(struct clk_hw *hw)
 	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
 	int ret;
 
-	ret = regmap_update_bits(s2mps11->iodev->regmap,
+	ret = regmap_update_bits(s2mps11->iodev->regmap_pmic,
 				S2MPS11_REG_RTC_CTRL,
 				 s2mps11->mask, s2mps11->mask);
 	if (!ret)
@@ -74,7 +74,7 @@ static void s2mps11_clk_unprepare(struct clk_hw *hw)
 	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
 	int ret;
 
-	ret = regmap_update_bits(s2mps11->iodev->regmap, S2MPS11_REG_RTC_CTRL,
+	ret = regmap_update_bits(s2mps11->iodev->regmap_pmic, S2MPS11_REG_RTC_CTRL,
 			   s2mps11->mask, ~s2mps11->mask);
 
 	if (!ret)
@@ -174,7 +174,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		s2mps11_clk->hw.init = &s2mps11_clks_init[i];
 		s2mps11_clk->mask = 1 << i;
 
-		ret = regmap_read(s2mps11_clk->iodev->regmap,
+		ret = regmap_read(s2mps11_clk->iodev->regmap_pmic,
 				  S2MPS11_REG_RTC_CTRL, &val);
 		if (ret < 0)
 			goto err_reg;
diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 333677d68d0e..9e61922d8230 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -438,7 +438,7 @@ common_reg:
 	platform_set_drvdata(pdev, s2mps11);
 
 	config.dev = &pdev->dev;
-	config.regmap = iodev->regmap;
+	config.regmap = iodev->regmap_pmic;
 	config.driver_data = s2mps11;
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
 		if (!reg_np) {
-- 
1.7.9.5

