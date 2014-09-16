Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaIPQqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:46:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:40382 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaIPQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:46:08 -0400
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [mmotm][PATCH] common: dma-mapping: Store page array in vm_struct
Date: Tue, 16 Sep 2014 09:45:54 -0700
Message-Id: <1410885954-24260-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 54329ac (common: dma-mapping: introduce common remapping functions)
factored out common code for remapping arrays of pages. The code before
the refactor relied on setting area->pages with the array of mapped
pages for easy access later. The refactor dropped this, breaking
parts of the ARM DMA API. Fix this by setting the page array in the same
place.

Reported-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/base/dma-mapping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
index 3a6af66..9e8bbdd 100644
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -285,6 +285,8 @@ void *dma_common_pages_remap(struct page **pages, size_t size,
 	if (!area)
 		return NULL;
 
+	area->pages = pages;
+
 	if (map_vm_area(area, prot, pages)) {
 		vunmap(area->addr);
 		return NULL;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

