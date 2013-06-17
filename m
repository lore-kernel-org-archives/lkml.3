Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465Ab3FQETA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:19:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54616 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQES6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:18:58 -0400
X-AuditID: cbfee68e-b7f276d000002279-26-51be8e31dfa5
From: YoungJun Cho <yj44.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        m.szyprowski@samsung.com
Cc: linux-kernel@vger.kernel.org, hdoyu@nvidia.com, kyungmin.park@samsung.com,
        yj44.cho@samsung.com
Subject: [PATCH] ARM: dma-mapping: Get pages if the cpu_addr is out of
 atomic_pool
Date: Mon, 17 Jun 2013 13:18:52 +0900
Message-id: <1371442732-15088-1-git-send-email-yj44.cho@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zHV3Dvn2BBus7eC0+Xp7NbHG26Q27
	xabH11gtLu+aw2Zx+zKvxdojd9kt9u6czOjA7tHS3MPmsXlJvUdv8zs2j74tqxg9Pm+SC2CN
	4rJJSc3JLEst0rdL4Mq4fPsoa8Etropd+5ezNzC+5+hi5OSQEDCROLD5PTOELSZx4d56ti5G
	Lg4hgWWMEptb3rDAFF1o62YHsYUEpjNKvN7gD2E3M0lcfMUIYrMJaEo8/7iDFcQWEYiROHxw
	F1g9s0CqxJ9HDWALhAVCJOYePgZUz8HBIqAqsfx3EkiYV8BF4tqjLqhVChIL7r0Fu0FC4Deb
	xKSl7WwgCRYBAYlvkw+xgPRKCMhKbDoAdbOkxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSkV5yY
	W1yal66XnJ+7iRESrn07GG8esD7EmAw0biKzlGhyPjDc80riDY3NjCxMTUyNjcwtzUgTVhLn
	VWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWHZCr80mJqde/fGN0JX8Ww8Li/vUqnl+
	dFqg42qy+GCq564qwXnr7man7Cz/cKDt5ITSrPVzXXMzNe7wlE3oXL1QSLSV87GBcPGVmZ+U
	3t+sPa/fuU6QNy9U85EeTwl/0Obr9xJ0ZP5KrprxueP1h2u3J3IqdSUl/Hu0W6dGpHi+KUuH
	qbqAEktxRqKhFnNRcSIA/dt8sG0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQV3Dvn2BBhencFp8vDyb2eJs0xt2
	i02Pr7FaXN41h83i9mVei7VH7rJb7N05mdGB3aOluYfNY/OSeo/e5ndsHn1bVjF6fN4kF8Aa
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hZJC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/Lto6wFt7gqdu1fzt7A+J6j
	i5GTQ0LAROJCWzc7hC0mceHeejYQW0hgOqPE6w3+EHYzk8TFV4wgNpuApsTzjztYQWwRgRiJ
	wwd3gfUyC6RK/HnUwAxiCwuESMw9fAyonoODRUBVYvnvJJAwr4CLxLVHXSwQqxQkFtx7yzaB
	kXsBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBoeCa1g3Flg8UhRgEORiUe3g3V+wKF
	WBPLiitzDzFKcDArifDq9QCFeFMSK6tSi/Lji0pzUosPMSYDLZ/ILCWanA+M1LySeENjEzMj
	SyMzYxNzY2PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYNz9uXrHAY/41wdvTKh9x/Yo
	mnfe0X/12yftfyXPX9hRx/9Ty8zo+sQ2/YzH7Vd2dnPGViXkrDzPOedp+G5TKx3VmpgA3o0L
	RBhY3S1+SDAIzD78acenw+snC4ZsenfsNVNedu2+sIJnL489bRC7musbJbx05r5jLwI+v5nT
	K/XqtpvRxCY9PX8lluKMREMt5qLiRACQcCxfygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __iommu_get_pages(), the cpu_addr is checked wheather in
atomic_pool range or not. So if the cpu_addr is in atomic_pool
range, it does not need to check twice.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mm/dma-mapping.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index ef3e0f3..1d158c2 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1372,16 +1372,17 @@ static int arm_iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
 			  dma_addr_t handle, struct dma_attrs *attrs)
 {
-	struct page **pages = __iommu_get_pages(cpu_addr, attrs);
+	struct page **pages;
 	size = PAGE_ALIGN(size);
 
-	if (!pages) {
-		WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
+	if (__in_atomic_pool(cpu_addr, size)) {
+		__iommu_free_atomic(dev, cpu_addr, handle, size);
 		return;
 	}
 
-	if (__in_atomic_pool(cpu_addr, size)) {
-		__iommu_free_atomic(dev, cpu_addr, handle, size);
+	pages = __iommu_get_pages(cpu_addr, attrs);
+	if (!pages) {
+		WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
 		return;
 	}
 
-- 
1.7.4.1

