Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaETMiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:38:52 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4558 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaETMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:38:51 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3/6] iommu/vt-d: clear the redundant assignment in dmar_enable_qi
Date: Tue, 20 May 2014 20:37:49 +0800
Message-ID: <1400589472-8544-4-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__dmar_enable_qi() will initialize free_head,free_tail and
free_cnt for q_inval. Remove the redundant initialization
in dmar_enable_qi().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/iommu/dmar.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 39f8b71..1168469 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1339,9 +1339,6 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 		return -ENOMEM;
 	}
 
-	qi->free_head = qi->free_tail = 0;
-	qi->free_cnt = QI_LENGTH;
-
 	raw_spin_lock_init(&qi->q_lock);
 
 	__dmar_enable_qi(iommu);
-- 
1.7.1


