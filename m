Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaABVxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33099 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaABVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:40 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        iommu@lists.linux-foundation.org
Subject: [RFC PATCHv3 02/11] iommu/omap: Use get_vm_area directly
Date: Thu,  2 Jan 2014 13:53:20 -0800
Message-Id: <1388699609-18214-3-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call __get_vm_area with VMALLOC_START and
VMALLOC_END when get_vm_area already does that. Call get_vm_area
directly.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/iommu/omap-iovmm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index d147259..6280d50 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -214,7 +214,7 @@ static void *vmap_sg(const struct sg_table *sgt)
 	if (!total)
 		return ERR_PTR(-EINVAL);
 
-	new = __get_vm_area(total, VM_IOREMAP, VMALLOC_START, VMALLOC_END);
+	new = get_vm_area(total, VM_IOREMAP);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 	va = (u32)new->addr;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

