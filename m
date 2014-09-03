Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbaICLsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:48:22 -0400
Received: from ezexch.ezchip.com ([212.179.42.101]:42506 "EHLO ezchip.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755478AbaICLsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:48:20 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 07:48:19 EDT
From: Noam Camus <noamc@ezchip.com>
To: <linux-kernel@vger.kernel.org>
CC: <torvalds@linux-foundation.org>, <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: [PATCH] ARC: [mm] Fix compilation breakage
Date: Wed, 3 Sep 2014 14:41:11 +0300
Message-ID: <1409744471-3698-1-git-send-email-noamc@ezchip.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-11.0.0.1191-7.500.1018-20926.004
X-TM-AS-Result: No--3.957000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Noam Camus <noamc@ezchip.com>

Structure name and variable name were erroneously interchanged
Signed-off-by: Noam Camus <noamc@ezchip.com>
---
 arch/arc/mm/cache_arc700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index 4670afc..22df2d1 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -427,7 +427,7 @@ struct ic_inv_args {
 
 static void __ic_line_inv_vaddr_helper(void *info)
 {
-        struct ic_inv *ic_inv_args = (struct ic_inv_args *) info;
+        struct ic_inv_args *ic_inv = (struct ic_inv_args *) info;
 
         __ic_line_inv_vaddr_local(ic_inv->paddr, ic_inv->vaddr, ic_inv->sz);
 }
-- 
1.7.1

