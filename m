Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3HPWj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab3HPWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 084/133] s390/bitops: fix find_next_bit_left
Date: Fri, 16 Aug 2013 15:33:46 -0700
Message-Id: <1376692475-28413-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 3b0040a47ad63f7147e9e7d2febb61a3b564bb90 upstream.

The find_next_bit_left function is broken if used with an offset which
is not a multiple of 64. The shift to mask the bits of a 64-bit word
not to search is in the wrong direction, the result can be either a
bit found smaller than the offset or failure to find a set bit.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/include/asm/bitops.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 1542293..787eb3b 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -698,7 +698,7 @@ static inline int find_next_bit_left(const unsigned long *addr,
 	size -= offset;
 	p = addr + offset / __BITOPS_WORDSIZE;
 	if (bit) {
-		set = __flo_word(0, *p & (~0UL << bit));
+		set = __flo_word(0, *p & (~0UL >> bit));
 		if (set >= size)
 			return size + offset;
 		if (set < __BITOPS_WORDSIZE)
-- 
1.8.1.2

