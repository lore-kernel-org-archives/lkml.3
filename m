Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762140Ab3JQC6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 22:58:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:35231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab3JQC6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 22:58:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,511,1378882800"; 
   d="scan'208";a="420375301"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linux-kernel@vger.kernel.org, sfi-devel@simplefirmware.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH] sfi: fix compiler warnings
Date: Wed, 16 Oct 2013 20:02:53 -0700
Message-Id: <1381978973-28934-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

drivers/sfi/sfi_core.c:164:26: warning: no previous prototype for ‘sfi_map_table’ [-Wmissing-prototypes]
drivers/sfi/sfi_core.c:192:6: warning: no previous prototype for ‘sfi_unmap_table’ [-Wmissing-prototypes]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/sfi/sfi_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 1e824fb..296db7a 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -161,7 +161,7 @@ static int sfi_verify_table(struct sfi_table_header *table)
  * Check for common case that we can re-use mapping to SYST,
  * which requires syst_pa, syst_va to be initialized.
  */
-struct sfi_table_header *sfi_map_table(u64 pa)
+static struct sfi_table_header *sfi_map_table(u64 pa)
 {
 	struct sfi_table_header *th;
 	u32 length;
@@ -189,7 +189,7 @@ struct sfi_table_header *sfi_map_table(u64 pa)
  * Undoes effect of sfi_map_table() by unmapping table
  * if it did not completely fit on same page as SYST.
  */
-void sfi_unmap_table(struct sfi_table_header *th)
+static void sfi_unmap_table(struct sfi_table_header *th)
 {
 	if (!TABLE_ON_PAGE(syst_va, th, th->len))
 		sfi_unmap_memory(th, TABLE_ON_PAGE(th, th, th->len) ?
-- 
1.8.4.rc3

