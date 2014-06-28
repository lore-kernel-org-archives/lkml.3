Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaF1Rw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:52:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaF1Rwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.15 104/139] arm64/dma: Removing ARCH_HAS_DMA_GET_REQUIRED_MASK macro
Date: Sat, 28 Jun 2014 10:47:45 -0700
Message-Id: <20140628174610.172937546@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

commit f3a183cb422574014538017b5b291a416396f97e upstream.

Arm64 does not define dma_get_required_mask() function.
Therefore, it should not define the ARCH_HAS_DMA_GET_REQUIRED_MASK.
This causes build errors in some device drivers (e.g. mpt2sas)

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/dma-mapping.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/include/asm/dma-mapping.h
+++ b/arch/arm64/include/asm/dma-mapping.h
@@ -26,8 +26,6 @@
 #include <xen/xen.h>
 #include <asm/xen/hypervisor.h>
 
-#define ARCH_HAS_DMA_GET_REQUIRED_MASK
-
 #define DMA_ERROR_CODE	(~(dma_addr_t)0)
 extern struct dma_map_ops *dma_ops;
 extern struct dma_map_ops coherent_swiotlb_dma_ops;


