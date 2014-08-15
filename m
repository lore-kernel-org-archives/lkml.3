Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaHOB5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 21:57:38 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37077 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaHOB5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 21:57:36 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] iommu/vt-d: Add new macros for invalidation event
Date: Fri, 15 Aug 2014 09:55:51 +0800
Message-Id: <1408067751-30754-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to intel's spec
        Intel® Virtualization Technology for Directed I/O,
        Revision: 1.3 , February 2011,
        Chaper 10.4.25 to 10.4.28

There are four registers

        IECTL_REG   0xa0    Invalidation event control register
        IEDATA_REG  0xa4    Invalidation event data register
        IEADDR_REG  0xa8    Invalidation event address register
        IEUADDR_REG 0xac    Invalidation event upper address register

Through they are not used in kernel in the latest version, the defination
 should be added to kernel as well as other registers.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 include/linux/intel-iommu.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index a65208a..15fafd5 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -56,6 +56,10 @@
 #define DMAR_IQ_SHIFT	4	/* Invalidation queue head/tail shift */
 #define DMAR_IQA_REG	0x90	/* Invalidation queue addr register */
 #define DMAR_ICS_REG	0x9c	/* Invalidation complete status register */
+#define DMAR_IECTL_REG	0xa0	/* Invalidation event control register */
+#define DMAR_IEDATA_REG	0xa4	/* Invalidation event data register */
+#define DMAR_IEADDR_REG	0xa8	/* Invalidation event address register */
+#define DMAR_IEUADDR_REG 0xac	/* Invalidation event upper address register */
 #define DMAR_IRTA_REG	0xb8    /* Interrupt remapping table addr register */
 
 #define OFFSET_STRIDE		(9)
-- 
2.0.0-rc0

