Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3LJJKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:10:30 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49513 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LJJKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:10:22 -0500
X-AuditID: cbfec7f5-b7fd16d000007299-99-52a6da7c77c6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [TRIVIAL PATCH 1/2] regulator: s5m8767: Define symbol for buck control
 mask
Date: Tue, 10 Dec 2013 10:09:42 +0100
Message-id: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7o1t5YFGUxcwWUx9eETNovXLwwt
	zja9Ybe4//Uoo8W3Kx1MFpseX2O1uLxrDpvF2iN32S1Od7NaXFzxhcni/f7LTA7cHjtn3WX3
	2LSqk83jzrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZL0/vZiw4JFRx
	c9VB5gbGzfxdjJwcEgImEg+urmCFsMUkLtxbz9bFyMUhJLCUUeLMzcUsIAkhgT4miZnthSA2
	m4CxxOblS8CKRAQWMEkce3eRFcRhFuhllHjw7hcjSJWwQJjEpe9tQN0cHCwCqhKdC4VAwrwC
	bhKHZzYzgYQlBBQk5kyymcDIvYCRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSGB93cG4
	9JjVIUYBDkYlHl6Jf0uDhFgTy4orcw8xSnAwK4nwrj65LEiINyWxsiq1KD++qDQntfgQIxMH
	p1QDY7L8pKQFIr2mmyxrr+js2nPv5d4jJpNuTKt+8coy++GuE80nG68Jq1feO/rV6GGm1Zb4
	W/+2Xlm4pPFG9gORhwpzL7spLcpZG7HLX+3bj+uWcTzf7W8JOT4PlS45/lfx/Qa+2ik619k1
	uh/M23V50yzxJ82M05ZnPjVvEzGTP3yrgF/KIiM5+J4SS3FGoqEWc1FxIgBnLMjACgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace hard-coded value for mask used in BUCKX_CTRL registers (for
BUCKX_EN field) with a symbol. This also removes two local variables.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/s5m8767.c         |   11 ++++++-----
 include/linux/mfd/samsung/s5m8767.h |    3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index aeb40aad0ae7..58eb7a6c45e6 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -217,7 +217,7 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
-	int mask = 0xc0, enable_ctrl;
+	int enable_ctrl;
 	unsigned int val;
 
 	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
@@ -230,27 +230,28 @@ static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return (val & mask) == enable_ctrl;
+	return (val & S5M8767_ENCTRL_MASK) == enable_ctrl;
 }
 
 static int s5m8767_reg_enable(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
-	int mask = 0xc0, enable_ctrl;
+	int enable_ctrl;
 
 	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret)
 		return ret;
 
-	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
+	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl,
+			S5M8767_ENCTRL_MASK);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int ret, reg;
-	int  mask = 0xc0, enable_ctrl;
+	int mask = S5M8767_ENCTRL_MASK, enable_ctrl;
 
 	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
 	if (ret)
diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
index 306a95fc558c..9198377ee859 100644
--- a/include/linux/mfd/samsung/s5m8767.h
+++ b/include/linux/mfd/samsung/s5m8767.h
@@ -183,6 +183,7 @@ enum s5m8767_regulators {
 	S5M8767_REG_MAX,
 };
 
-#define S5M8767_ENCTRL_SHIFT  6
+#define S5M8767_ENCTRL_SHIFT		6
+#define S5M8767_ENCTRL_MASK		(0x3 << S5M8767_ENCTRL_SHIFT)
 
 #endif /* __LINUX_MFD_S5M8767_H */
-- 
1.7.9.5

