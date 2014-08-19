Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaHSVKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:10:49 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33523 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaHSVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:10:47 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org (open list:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Cc: Andre Morton <akpm@linux-foundation.org>
Subject: [PATCH] edac: Fix build error caused by wrong member access
Date: Tue, 19 Aug 2014 17:10:46 -0400
Message-Id: <1408482646-22541-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following error 

drivers/edac/ppc4xx_edac.c:977:45: error: request for member 'dimm' in something
not a structure or union

by changing member access to pointer dereference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Andre Morton <akpm@linux-foundation.org>
---
 drivers/edac/ppc4xx_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index ef6b7e0..0f04d5e 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -974,7 +974,7 @@ static int ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 		 * page size (PAGE_SIZE) or the memory width (2 or 4).
 		 */
 		for (j = 0; j < csi->nr_channels; j++) {
-			struct dimm_info *dimm = csi->channels[j].dimm;
+			struct dimm_info *dimm = csi->channels[j]->dimm;
 
 			dimm->nr_pages  = nr_pages / csi->nr_channels;
 			dimm->grain	= 1;
-- 
1.9.1

