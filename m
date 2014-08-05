Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaHEKwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:52:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9343 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbaHEKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:05 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ca-53e0b69e5610
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 16/29] iommu: exynos: make driver multiarch friendly
Date: Tue, 05 Aug 2014 12:47:44 +0200
Message-id: <1407235677-26324-17-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xq7rztj0INli4zdri76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlbHl5Ff2gmkcFb2PHjE3MH5h62Lk4JAQMJFY
	vEWni5ETyBSTuHBvPRuILSSwlFFiz3ndLkYuILuPSaLrzm4mkASbgKFE19suNpCEiEAvo0R/
	0w8mEIdZYB2rxP7e6ywgVcICLhL3LyxjBNnAIqAqsflaCUiYV8BT4snl+2wQ2+Qk/r9cATaU
	Eyh++OYBVojNHhI/N6xhn8DIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSNR82cG4
	+JjVIUYBDkYlHl6D03eDhVgTy4orcw8xSnAwK4nwSqx5ECzEm5JYWZValB9fVJqTWnyIkYmD
	U6qBcZGPtcfKVFtXwZuZ5rwz53uk6AvdmB83v+ZNaFyZ7fsDF19wN51LuLMi53uMYGrh5eTP
	Uz2P1B/aMGuWy4o/ot6PvmwOuqg7JVFCONzyqP22fNOXt3cG/wir+uEo4jBFycpWvuz4UTuG
	qytEo69G3PXLsF5/a77dS9dslb/Fxc8Sw1cJfQp6rcRSnJFoqMVcVJwIAODk3Pp4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize all structures and register to iommu subsystem only on Exynos
compatible platforms.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index d037e87..64b3bc8 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -20,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/mm.h>
+#include <linux/of.h>
 #include <linux/iommu.h>
 #include <linux/errno.h>
 #include <linux/list.h>
@@ -1187,6 +1188,11 @@ static int __init exynos_iommu_init(void)
 {
 	int ret;
 
+	if (!of_machine_is_compatible("samsung,exynos3") &&
+	    !of_machine_is_compatible("samsung,exynos4") &&
+	    !of_machine_is_compatible("samsung,exynos5"))
+		return -ENODEV;
+
 	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
 				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
 	if (!lv2table_kmem_cache) {
-- 
1.9.2

