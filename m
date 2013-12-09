Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706Ab3LIVw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:52:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43482 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761656Ab3LIVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:52:16 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v3 05/23] mm/memblock: drop WARN and use SMP_CACHE_BYTES as a default alignment
Date: Mon, 9 Dec 2013 16:50:38 -0500
Message-ID: <1386625856-12942-6-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

Don't produce warning and interpret 0 as "default align" equal to
SMP_CACHE_BYTES in case if caller of memblock_alloc_base_nid() doesn't
specify alignment for the block (align == 0).

This is done in preparation of introducing common memblock alloc
interface to make code behavior consistent. More details are
in below thread :
	https://lkml.org/lkml/2013/10/13/117.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/memblock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 39855d4..784958d 100644
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

