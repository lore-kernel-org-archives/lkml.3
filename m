Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598Ab3E1V0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab3E1V0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sukanto Ghosh <sghosh@apm.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 46/78] arm64: mm: Fix operands of clz in __flush_dcache_all
Date: Tue, 28 May 2013 14:19:55 -0700
Message-Id: <1369776027-17859-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sukanto Ghosh <sghosh@apm.com>

commit b4fed0796841b5293b9c9427a5391b7bb20ef2d9 upstream.

The format of the lower 32-bits of the 64-bit operand to 'dc cisw' is
unchanged from ARMv7 architecture and the upper bits are RES0. This
implies that the 'way' field of the operand of 'dc cisw' occupies the
bit-positions [31 .. (32-A)]. Due to the use of 64-bit extended operands
to 'clz', the existing implementation of __flush_dcache_all is incorrectly
placing the 'way' field in the bit-positions [63 .. (64-A)].

Signed-off-by: Sukanto Ghosh <sghosh@apm.com>
Tested-by: Anup Patel <anup.patel@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/mm/cache.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index abe69b8..48a3860 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -52,7 +52,7 @@ loop1:
 	add	x2, x2, #4			// add 4 (line length offset)
 	mov	x4, #0x3ff
 	and	x4, x4, x1, lsr #3		// find maximum number on the way size
-	clz	x5, x4				// find bit position of way size increment
+	clz	w5, w4				// find bit position of way size increment
 	mov	x7, #0x7fff
 	and	x7, x7, x1, lsr #13		// extract max number of the index size
 loop2:
-- 
1.8.1.2

