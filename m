Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935564Ab3IEJXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:23:03 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38752 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763299Ab3IEJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:23:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] MIPS: Export copy_from_user_page() (needed by lustre)
Date: Thu,  5 Sep 2013 11:22:45 +0200
Message-Id: <1378372965-27213-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mips/mm/init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 4e73f10..e205ef5 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -254,6 +254,7 @@ void copy_from_user_page(struct vm_area_struct *vma,
 			SetPageDcacheDirty(page);
 	}
 }
+EXPORT_SYMBOL_GPL(copy_from_user_page);
 
 void __init fixrange_init(unsigned long start, unsigned long end,
 	pgd_t *pgd_base)
-- 
1.7.9.5

