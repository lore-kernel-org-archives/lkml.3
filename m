Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab3BMMEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:04:54 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55503 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab3BMMEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:04:47 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/5] metag: export clear_page and copy_page
Date: Wed, 13 Feb 2013 12:03:46 +0000
Message-ID: <1360757029-28868-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_12_04_46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various file systems use clear_page() and copy_page(), so when they're
built as modules we get build errors like the following:

ERROR: "clear_page" [fs/ntfs/ntfs.ko] undefined!
ERROR: "copy_page" [fs/nilfs2/nilfs2.ko] undefined!

Therefore export these functions to modules from metag_ksyms.c to fix
the errors. This was hit by a randconfig build.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/metag_ksyms.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/metag/kernel/metag_ksyms.c b/arch/metag/kernel/metag_ksyms.c
index 5381514..1b27bea 100644
--- a/arch/metag/kernel/metag_ksyms.c
+++ b/arch/metag/kernel/metag_ksyms.c
@@ -37,6 +37,8 @@ EXPORT_SYMBOL(get_trigger_mask);
 EXPORT_SYMBOL(global_trigger_mask);
 #endif
 
+EXPORT_SYMBOL(clear_page);
+EXPORT_SYMBOL(copy_page);
 EXPORT_SYMBOL(empty_zero_page);
 
 EXPORT_SYMBOL(pfn_base);
-- 
1.7.7.6


