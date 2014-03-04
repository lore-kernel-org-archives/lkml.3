Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbaCDVip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:38:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbaCDUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3.13 015/172] ARM: dma-mapping: fix GFP_ATOMIC macro usage
Date: Tue,  4 Mar 2014 12:01:39 -0800
Message-Id: <20140304200300.220448690@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 10c8562f932d89c030083e15f9279971ed637136 upstream.

GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
atomic allocation, the code must test __GFP_WAIT flag presence. This patch
fixes the issue introduced in v3.6-rc5

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/dma-mapping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1358,7 +1358,7 @@ static void *arm_iommu_alloc_attrs(struc
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-	if (gfp & GFP_ATOMIC)
+	if (!(gfp & __GFP_WAIT))
 		return __iommu_alloc_atomic(dev, size, handle);
 
 	/*


