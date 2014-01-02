Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaABVxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:52 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33108 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaABVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:41 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCHv3 06/11] arm: use is_vmalloc_addr
Date: Thu,  2 Jan 2014 13:53:24 -0800
Message-Id: <1388699609-18214-7-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_vmalloc_addr already does the range checking against VMALLOC_START and
VMALLOC_END. Use it.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/mm/iomap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/iomap.c b/arch/arm/mm/iomap.c
index 4614208..4bf5457 100644
--- a/arch/arm/mm/iomap.c
+++ b/arch/arm/mm/iomap.c
@@ -34,8 +34,7 @@ EXPORT_SYMBOL(pcibios_min_mem);
 
 void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
 {
-	if ((unsigned long)addr >= VMALLOC_START &&
-	    (unsigned long)addr < VMALLOC_END)
+	if (is_vmalloc_addr(addr))
 		iounmap(addr);
 }
 EXPORT_SYMBOL(pci_iounmap);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

