Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaCSRgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:36:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33528 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaCSRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:36:11 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Christopher Covington <cov@codeaurora.org>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Use 64-bit DMA addresses for LPAE+VirtIO-MMIO
Date: Wed, 19 Mar 2014 13:35:19 -0400
Message-Id: <1395250522-30031-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an LPAE system, the physical addresses used by VirtIO-MMIO may
be larger than 32 bits, even if the header and configuration space
addresses fit into 32 bits. For example with the Versatile Express
memory map using 4G memory, the following error occured when trying
to use a VirtIO-MMIO block device.

EXT2-fs (vda): error: ext2_check_page: bad entry in directory #2: : unaligned directory entry - offset=0, inode=3755990991, rec_len=57311, name_len=223

To fix this, select ARCH_DMA_ADDR_T_64BIT when both LPAE and
VIRTIO_MMIO are selected.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm/mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 1f8fed9..a62bcc9 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -617,6 +617,7 @@ config ARM_LPAE
 	bool "Support for the Large Physical Address Extension"
 	depends on MMU && CPU_32v7 && !CPU_32v6 && !CPU_32v5 && \
 		!CPU_32v4 && !CPU_32v3
+	select ARCH_DMA_ADDR_T_64BIT if VIRTIO_MMIO
 	help
 	  Say Y if you have an ARMv7 processor supporting the LPAE page
 	  table format and you would like to access memory beyond the
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

