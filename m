Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3IYT3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:29:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23293 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3IYT3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:29:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/mmu: Correct PAT MST setting.
Date: Wed, 25 Sep 2013 15:29:27 -0400
Message-Id: <1380137367-8357-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich spotted that the PAT MSR settings in the Xen public
document that "the first (PAT6) column was wrong across the
board, and the column for PAT7 was missing altogether."

This updates it to be in sync.

CC: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index fdc3ba2..c9631e7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -468,8 +468,8 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
  * 3        PCD PWT      UC       UC     UC
  * 4    PAT              WB       WC     WB
  * 5    PAT     PWT      WC       WP     WT
- * 6    PAT PCD          UC-      UC     UC-
- * 7    PAT PCD PWT      UC       UC     UC
+ * 6    PAT PCD          UC-      rsv    UC-
+ * 7    PAT PCD PWT      UC       rsv    UC
  */
 
 void xen_set_pat(u64 pat)
-- 
1.8.3.1

