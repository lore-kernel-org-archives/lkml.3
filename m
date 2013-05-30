Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967401Ab3E3DEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:04:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:3537 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967359Ab3E3DDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312653"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 11/13] sfi: fix compiler warnings
Date: Wed, 29 May 2013 19:45:21 -0700
Message-Id: <1369881923-27067-12-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

drivers/sfi/sfi_core.c:164:26: warning: no previous prototype for ‘sfi_map_table’ [-Wmissing-prototypes]
drivers/sfi/sfi_core.c:192:6: warning: no previous prototype for ‘sfi_unmap_table’ [-Wmissing-prototypes]

Change-Id: I2c2053dcd364a21c6b86016b28f2fb4961ccf43e
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/sfi/sfi_core.c |    4 ++--
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
1.7.9.5

