Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3LQMe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:34:59 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63986 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3LQMe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:34:58 -0500
Date: Tue, 17 Dec 2013 18:04:50 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, sfi-devel@simplefirmware.org,
        josh@joshtriplett.org
Subject: [PATCH 2/2] drivers: sfi: Mark functions as static in sfi_core.c
Message-ID: <78c9d53e2266bfdf06bf1d545cb2cf7fb5e7226c.1387283325.git.rashika.kheria@gmail.com>
References: <c351cee2521c4728d60810eb0212e8f307c79ac6.1387283325.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c351cee2521c4728d60810eb0212e8f307c79ac6.1387283325.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions sfi_map_table() and sfi_unmap_table() as static in
sfi_core.c because they are not used outside this file.

This eliminates following warning in sfi_core.c:
drivers/sfi/sfi_core.c:164:26: warning: no previous prototype for ‘sfi_map_table’ [-Wmissing-prototypes]
drivers/sfi/sfi_core.c:192:6: warning: no previous prototype for ‘sfi_unmap_table’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
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

