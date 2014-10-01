Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaJAPb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:31:59 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:59840 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaJAPb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:31:58 -0400
From: Sean Paul <seanpaul@chromium.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, lauraa@codeaurora.org,
        ritesh.harjani@gmail.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: olof@lixom.net, seanpaul@chromium.org
Subject: [PATCH v2] arm64: Use DMA_ERROR_CODE to denote failed allocation
Date: Wed,  1 Oct 2014 11:31:50 -0400
Message-Id: <1412177510-26310-1-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141001135248.GQ5182@n2100.arm.linux.org.uk>
References: <20141001135248.GQ5182@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the static assignment of ~0 to dma_handle with
DMA_ERROR_CODE to be consistent with other platforms.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---

Changes in v2:
	- Removed the check for DMA_ERROR_CODE in __dma_free_noncoherent
	  the function shouldn't be called after failed allocation

 arch/arm64/mm/dma-mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
index 4164c5a..5687dd4 100644
--- a/arch/arm64/mm/dma-mapping.c
+++ b/arch/arm64/mm/dma-mapping.c
@@ -125,7 +125,7 @@ static void *__dma_alloc_noncoherent(struct device *dev, size_t size,
 no_map:
 	__dma_free_coherent(dev, size, ptr, *dma_handle, attrs);
 no_mem:
-	*dma_handle = ~0;
+	*dma_handle = DMA_ERROR_CODE;
 	return NULL;
 }
 
-- 
2.1.1

