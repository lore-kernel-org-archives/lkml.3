Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaGUIgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:36:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31028 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaGUIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:36:36 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-ab-53ccd110eaf0
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] cpuidle: exynos: Allow to use the driver without AFTR
Date: Mon, 21 Jul 2014 10:36:09 +0200
Message-id: <1405931771-24100-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e/4ZV2Bi2eCDSb/MLTYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsbl/mtVh75C67xZnTl1gtrlw6
	xWaxfsZrFov2v3vZHPg9Wpp72DzuXNvD5rF5Sb3HlqvtLB59W1YxenzeJBfAFsVlk5Kak1mW
	WqRvl8CV0XP4CHPBZfaK+6cmMTcwrmfrYuTgkBAwkfj/y72LkRPIFJO4cA8kzMUhJLCUUaLz
	6xsop49JYv3qhSwgVWwCxhKbly8BS4gINDFLvFp+mg0kwSzwnFHi6fdwEFtYwEvicMN8dhCb
	RUBVYv+OK2A2r4C7xNfl05kh1slJnDw2mXUCI/cCRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGCGB93UH49JjVocYBTgYlXh4OV6cChZiTSwrrsw9xCjBwawkwnsi40ywEG9KYmVValF+
	fFFpTmrxIUYmDk6pBkaZYmF1haCPa7lO7soXf1i9s42vtLRSuPPPRB8XxXsP08y+NbwOZY2e
	8narmHzeqTWrjaz+H59wpHmSjLlzrI5BdsVaxU2zJK47/lU05k3RjlBM7p7nGyDFpO/B6TXj
	y8zDDwpue/2+Kxvv6MOXHqA+gZUlOGw1L+N0qQ9zc1fsqHTjDzZar8RSnJFoqMVcVJwIAHJv
	63AaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the driver to be used when AFTR enter function is not provided
(device platform data is NULL).

This actually does not give any special energy-saving benefits but
allows to track the idle time of each core. Additionally it is a safe
way to validate supplied platform data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/cpuidle/cpuidle-exynos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
index 7c0151263828..5325a394be7e 100644
--- a/drivers/cpuidle/cpuidle-exynos.c
+++ b/drivers/cpuidle/cpuidle-exynos.c
@@ -77,7 +77,10 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	/* If NULL enter only WFI */
 	exynos_enter_aftr = (void *)(pdev->dev.platform_data);
+	if (!exynos_enter_aftr)
+		exynos_idle_driver.state_count = 1;
 
 	ret = cpuidle_register(&exynos_idle_driver, NULL);
 	if (ret) {
-- 
1.9.1

