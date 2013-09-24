Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3IXPE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:04:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8270 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3IXPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:04:25 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-64-5241a9f897c9
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: t.figa@samsung.com, linus.walleij@linaro.org
Cc: thomas.abraham@linaro.org, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] pinctrl: Correct number of pins for s5pv210
Date: Tue, 24 Sep 2013 17:04:11 +0200
Message-id: <1380035051-24526-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xgO6PlY5BBvNWCVv0LrjKZnG26Q27
	xZQ/y5ksNj2+xmpxedccNosZ5/cxWZxec4rZYv2M1ywWx2YsYXTg9LhzbQ+bx+Yl9R4H3+1h
	8ujbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mww9KC+bzVUz/YNDAuJmni5GTQ0LARKLj90c2
	CFtM4sK99UA2F4eQwCJGietXnjJBOO1MEnO7tzOBVLEJmEtMfLaJBcQWETCQaDq2kBWkiFmg
	kUnixsGJYEXCAjYS397vYwaxWQRUJVbMmcYOYvMK+EnsvrSKBWKdgsTPyyfYJjByL2BkWMUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHDbPpHcwrmqwOMQowMGoxMN7IcEhSIg1say4MvcQ
	owQHs5IIr2atY5AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYO
	TqkGxjCjPLNEg/vBO5SLtcSPu0nPTF8pGMLmrWoXocQgY8XkVdeuqccrWJIZbV+wPOgLv3HZ
	S5/IQ0UTopNZ6o+pJJ+J2no4fd8DBWfxy7Mlnq44eU3E5ouIYfuvWQdZ5NcpbMtK04xRZgza
	7fLBQ6PcTXGG8oSLv/8U7t60oLz8ebLl5ds/eGSVWIozEg21mIuKEwEAi+p2FwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Values of pins in table s5pv210 bank are incorrect. This patch correct values.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/pinctrl/pinctrl-exynos.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 2689f8d..155b1b3 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -663,18 +663,18 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
 /* pin banks of s5pv210 pin-controller */
 static struct samsung_pin_bank s5pv210_pin_bank[] = {
 	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
-	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
+	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpa1", 0x04),
 	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
 	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
 	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
 	EXYNOS_PIN_BANK_EINTG(4, 0x0a0, "gpd0", 0x14),
-	EXYNOS_PIN_BANK_EINTG(4, 0x0c0, "gpd1", 0x18),
-	EXYNOS_PIN_BANK_EINTG(5, 0x0e0, "gpe0", 0x1c),
-	EXYNOS_PIN_BANK_EINTG(8, 0x100, "gpe1", 0x20),
-	EXYNOS_PIN_BANK_EINTG(6, 0x120, "gpf0", 0x24),
+	EXYNOS_PIN_BANK_EINTG(6, 0x0c0, "gpd1", 0x18),
+	EXYNOS_PIN_BANK_EINTG(8, 0x0e0, "gpe0", 0x1c),
+	EXYNOS_PIN_BANK_EINTG(5, 0x100, "gpe1", 0x20),
+	EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpf0", 0x24),
 	EXYNOS_PIN_BANK_EINTG(8, 0x140, "gpf1", 0x28),
 	EXYNOS_PIN_BANK_EINTG(8, 0x160, "gpf2", 0x2c),
-	EXYNOS_PIN_BANK_EINTG(8, 0x180, "gpf3", 0x30),
+	EXYNOS_PIN_BANK_EINTG(6, 0x180, "gpf3", 0x30),
 	EXYNOS_PIN_BANK_EINTG(7, 0x1a0, "gpg0", 0x34),
 	EXYNOS_PIN_BANK_EINTG(7, 0x1c0, "gpg1", 0x38),
 	EXYNOS_PIN_BANK_EINTG(7, 0x1e0, "gpg2", 0x3c),
-- 
1.8.1.2

