Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbaCDUgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:36:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbaCDUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3.10 08/97] ARM: dma-mapping: fix GFP_ATOMIC macro usage
Date: Tue,  4 Mar 2014 12:03:21 -0800
Message-Id: <20140304200346.382841545@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1311,7 +1311,7 @@ static void *arm_iommu_alloc_attrs(struc
 	*handle = DMA_ERROR_CODE;
 	size = PAGE_ALIGN(size);
 
-	if (gfp & GFP_ATOMIC)
+	if (!(gfp & __GFP_WAIT))
 		return __iommu_alloc_atomic(dev, size, handle);
 
 	pages = __iommu_alloc_buffer(dev, size, gfp, attrs);


