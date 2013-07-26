Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab3GZL0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:26:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50846 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3GZL03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:26:29 -0400
X-AuditID: cbfee68f-b7f436d000000f81-cb-51f25ce409ee
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v8 02/12] iommu/exynos: add missing cache flush for removed
 page table entries
Date: Fri, 26 Jul 2013 20:26:28 +0900
Message-id: <003801ce89f2$f8952d20$e9bf8760$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8Y6Vw9vEup31TMq2rYuDqttIbQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zke6TmE+BBjt/GlncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujOtb77IVvOWouLh7AUsD42r2LkZODgkBE4n+OX+g
	bDGJC/fWs4HYQgLLGCXmTrGGqWl/+om1i5ELKL6IUeLM1afsEM5fRomjm6+zglSxCWhJrJ57
	nBHEFhG4yyjx8jwPSBGzwG1miWk/X4ElhAUSJGYfXcQMYrMIqEosPzSBBcTmFbCUeLGoF8oW
	lPgx+R6YzQw0dP3O40wQtrzE5jVvmSFOUpDYcfY11DI9if3TW9ggakQk9r14xwiyWEJgKYfE
	84l7WCCWCUh8m3wIyOYASshKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC
	5ILipPQiY73ixNzi0rx0veT83E2MkCTQv4Px7gHrQ4zJQOsnMkuJJucDk0heSbyhsZmRhamJ
	qbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgXvHooz9JT5SO1uHLO
	g9ap3WuY3fJOin9Ordn6+Ubwt6iD99Rnet5fHxfRssM15Yuub3B6GmsPu86Ou9b+envlNroa
	a31LZDyzSyFoIcNRsbbdNx22mjdc2frs8cz7kbp1ZmI832c550Vkpq070Gc5Za7+xP1JbW+C
	Rbds/rkkpPa6xoV3jVVKLMUZiYZazEXFiQCXCvRsGAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd0nMZ8CDV4u1bW4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOub73LVvCW
	o+Li7gUsDYyr2bsYOTkkBEwk2p9+YoWwxSQu3FvP1sXIxSEksIhR4szVp+wQzl9GiaObr4NV
	sQloSayee5wRxBYRuMso8fI8D0gRs8BtZolpP1+BJYQFEiRmH13EDGKzCKhKLD80gQXE5hWw
	lHixqBfKFpT4MfkemM0MNHT9zuNMELa8xOY1b5khTlKQ2HH2NdQyPYn901vYIGpEJPa9eMc4
	gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBCeZZ9I7GFc1
	WBxiFOBgVOLhVXD6GCjEmlhWXJl7iFGCg1lJhPe696dAId6UxMqq1KL8+KLSnNTiQ4zJQJ9O
	ZJYSTc4HJsC8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDU
	/PVpn+XaJQoPjl+smHlIbpaDYeGHl9fP5h0WNTzmlVdpa/lfRjvhsfzFCL8LdlnRD1MXpuw6
	0Mpx6cX24P2uc95PT2DQ8fSa8lbDrsss/TzHTZkPV/i/l2Xe+/zQJofx/AbLzPeWp5I0WgP4
	LhqKxVypvVXqKGTI6GCz/+PZK+cnmYhf545WYinOSDTUYi4qTgQA2YL6pXYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds cache flush for removed small and large page entries
in exynos_iommu_unmap(). Missing cache flush of removed page table
entries can cause missing page fault interrupt when a master IP
accesses an unmapped area.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 233f382..e3be3e5 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1002,6 +1002,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	if (lv2ent_small(ent)) {
 		*ent = 0;
 		size = SPAGE_SIZE;
+		pgtable_flush(ent, ent +1);
 		priv->lv2entcnt[lv1ent_offset(iova)] += 1;
 		goto done;
 	}
@@ -1010,6 +1011,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 	BUG_ON(size < LPAGE_SIZE);
 
 	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
+	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
 
 	size = LPAGE_SIZE;
 	priv->lv2entcnt[lv1ent_offset(iova)] += SPAGES_PER_LPAGE;
-- 
1.7.2.5


