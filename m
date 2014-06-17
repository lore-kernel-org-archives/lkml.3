Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934149AbaFQRO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:14:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460AbaFQROz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:14:55 -0400
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] arm64: export __cpu_{clear,copy}_user_page functions
Date: Tue, 17 Jun 2014 13:14:26 -0400
Message-Id: <1403025266-2326-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpu_clear_user_page() and __cpu_copy_user_page() functions
are not currently exported. This prevents modules from using
clear_user_page() and opy_user_page().

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/mm/copypage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 9aecbac..13bbc3be 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -27,8 +27,10 @@ void __cpu_copy_user_page(void *kto, const void *kfrom, unsigned long vaddr)
 	copy_page(kto, kfrom);
 	__flush_dcache_area(kto, PAGE_SIZE);
 }
+EXPORT_SYMBOL_GPL(__cpu_copy_user_page);
 
 void __cpu_clear_user_page(void *kaddr, unsigned long vaddr)
 {
 	clear_page(kaddr);
 }
+EXPORT_SYMBOL_GPL(__cpu_clear_user_page);
-- 
1.9.0

