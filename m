Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaHLPMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:12:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35926 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaHLPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:12:33 -0400
X-AuditID: cbfee61b-f79f86d00000144c-1d-53ea2ee0ea46
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 1/3] ARM: EXYNOS: Fix build with PM_SLEEP=n and
 ARM_EXYNOS_CPUIDLE=n
Date: Tue, 12 Aug 2014 17:11:55 +0200
Message-id: <1407856317-2457-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd0Heq+CDU4dlbHYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i84eXbBZXLp1is1g/
	4zWLA69HS3MPm8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5ALYorhsUlJzMstSi/TtErgybp9+
	ylawi6NixfktLA2MDexdjBwcEgImEr9usXYxcgKZYhIX7q1n62Lk4hASWMQo0dvyiR3C6WKS
	WNS0jwmkik3ASmJi+ypGEFtEQE2iZ/FWRpAiZoE7zBKv9u5lAUkIC0RK7Hk1F2wsi4CqxLbf
	D1lAtvEKuEu8+MMBsU1RovvZBDYQm1PAQ+L95HfMILYQUEnXvqPMExh5FzAyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIDspn0jsYVzVYHGIU4GBU4uG9wP8qWIg1say4MvcQowQHs5II
	r+Dtl8FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGBv1
	mhh3vz17yL3I8UPKzS/zmTP8r5ReXy/ku8snLtOaZcPZvxPFH5++bVci0HEy6Uxq3+odEz2e
	aZRvC5plnvs7NkDny+NL/qy7j5/bsLvsxlU744t3rBaknI4/1fXgVFWCSq587JNvJ6c1rzTV
	7MjN+nSTTc/HqK77sNXOrTazqrbl2U1tvKnEUpyRaKjFXFScCABHmi6YRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos_defconfig with disabled CONFIG_PM_SLEEP by
adding checking whether Exynos cpuidle support is enabled before
accessing exynos_enter_aftr.

The build error message:
arch/arm/mach-exynos/built-in.o:(.data+0x74): undefined reference to `exynos_enter_aftr'
make: *** [vmlinux] Error 1

This patch has been tested on Exynos4210 based Origen board.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/exynos.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 6a24e11..d57f136 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -161,7 +161,9 @@ static void exynos_restart(enum reboot_mode mode, const char *cmd)
 
 static struct platform_device exynos_cpuidle = {
 	.name              = "exynos_cpuidle",
+#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
 	.dev.platform_data = exynos_enter_aftr,
+#endif
 	.id                = -1,
 };
 
-- 
1.8.2.3

