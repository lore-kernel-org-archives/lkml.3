Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3LCCfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:35:02 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53778 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab3LCC3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:29:16 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 07/23] mm/memblock: drop WARN and use SMP_CACHE_BYTES as a default alignment
Date: Mon, 2 Dec 2013 21:27:22 -0500
Message-ID: <1386037658-3161-8-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386037658-3161-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

drop WARN and use SMP_CACHE_BYTES as a default alignment in
memblock_alloc_base_nid() as recommended by Tejun Heo in
https://lkml.org/lkml/2013/10/13/117.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 53da534..1d15e07 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -883,8 +883,8 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 {
 	phys_addr_t found;
 
-	if (WARN_ON(!align))
-		align = __alignof__(long long);
+	if (!align)
+		align = SMP_CACHE_BYTES;
 
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
-- 
1.7.9.5

