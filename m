Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaHEKvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:51:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9361 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaHEKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:49:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-db-53e0b6a3a028
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
Subject: [PATCH 21/29] iommu: exynos: remove unused functions, part 2
Date: Tue, 05 Aug 2014 12:47:49 +0200
Message-id: <1407235677-26324-22-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7qLtz0INtgyT9Di76Rj7BbNi9ez
	WUy6P4HFYsF+a4vO2RvYLXoXXGWzONv0ht2ic+ISdosvVx4yWWx6fI3V4vKuOWwWM87vY7JY
	e+Quu8Wp65/ZLP71HmS0OHP6EqvF/z072C0Ov2lntTjycDe7xapdfxgtbv/mcxD1eHJwHpPH
	71+TGD12zrrL7jG7Yyarx6ZVnWwe++euYffYvKTe4/a/x8wek28sZ/S4cqKJ1aO3+R2bx5ar
	7SwefVtWMXp83iQXwBfFZZOSmpNZllqkb5fAlXFk5UKmgil8Ffv7VzM3MF7g7mLk5JAQMJHY
	9OsyE4QtJnHh3nq2LkYuDiGBpYwSnfNvMUI4fUwST04uZAOpYhMwlOh62wVWJSLQyyjR3/SD
	CcRhFljHKrG/9zoLSJWwgKvErNfTmLsYOThYBFQlZszTBQnzCnhKbH/fxgyxTk7i/8sVYKs5
	geKHbx5gBbGFBDwkfm5Ywz6BkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDI+bKD
	cfExq0OMAhyMSjy8BqfvBguxJpYVV+YeYpTgYFYS4ZVY8yBYiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA6NPwrlIs2+uj7albUuTaMu7vzo1wXCP1kbfx/v1Wj/Kf3qQYciv7+Y/bR7D2WiLWqb8
	qLjnhrx3P/mfu/M8JMmbxb9K+WD82zMyGc9lOg+wyb49NLV+q9Ga4y/1Ln/rXP4lgWua6T73
	3DO5h+4YLXH4uea0rsaT+1093FeTL/z9rG25db7B5yolluKMREMt5qLiRAA3AZvwegIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After refactoring functions to use pointer to struct sysmmu_drvdata
directly, some functions became useless and thus never used, so remove
them completely.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/iommu/exynos-iommu.c | 43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 018a615..674d1fb 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -458,49 +458,6 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
 	return ret;
 }
 
-/* __exynos_sysmmu_enable: Enables System MMU
- *
- * returns -error if an error occurred and System MMU is not enabled,
- * 0 if the System MMU has been just enabled and 1 if System MMU was already
- * enabled before.
- */
-static int __exynos_sysmmu_enable(struct device *dev, phys_addr_t pgtable,
-				  struct iommu_domain *domain)
-{
-	int ret = 0;
-	unsigned long flags;
-	struct exynos_iommu_owner *owner = dev->archdata.iommu;
-	struct sysmmu_drvdata *data;
-
-	BUG_ON(!has_sysmmu(dev));
-
-	data = dev_get_drvdata(owner->sysmmu);
-
-	ret = __sysmmu_enable(data, pgtable, domain);
-	if (ret >= 0)
-		data->master = dev;
-
-	return ret;
-}
-
-static bool exynos_sysmmu_disable(struct device *dev)
-{
-	unsigned long flags;
-	bool disabled = true;
-	struct exynos_iommu_owner *owner = dev->archdata.iommu;
-	struct sysmmu_drvdata *data;
-
-	BUG_ON(!has_sysmmu(dev));
-
-	data = dev_get_drvdata(owner->sysmmu);
-
-	disabled = __sysmmu_disable(data);
-	if (disabled)
-		data->master = NULL;
-
-	return disabled;
-}
-
 static void __sysmmu_tlb_invalidate_flpdcache(struct sysmmu_drvdata *data,
 					      sysmmu_iova_t iova)
 {
-- 
1.9.2

