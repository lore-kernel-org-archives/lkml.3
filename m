Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3KWX3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 18:29:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45789 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab3KWX3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 18:29:23 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: nobootmem: avoid type warning about alignment value
Date: Sat, 23 Nov 2013 18:28:46 -0500
Message-ID: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building ARM with NO_BOOTMEM generates below warning. Using min_t
to find the correct alignment avoids the warning.

Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 mm/nobootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 2c254d3..8954e43 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -85,7 +85,7 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
 	int order;
 
 	while (start < end) {
-		order = min(MAX_ORDER - 1UL, __ffs(start));
+		order = min_t(size_t, MAX_ORDER - 1UL, __ffs(start));
 
 		while (start + (1UL << order) > end)
 			order--;
-- 
1.7.9.5

