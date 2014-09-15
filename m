Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbaIOWqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:46:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51104 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932929AbaIOWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:18:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 022/187] sparc64: Fix range check in kern_addr_valid().
Date: Mon, 15 Sep 2014 15:07:12 -0700
Message-Id: <1410818997-9432-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit ee73887e92a69ae0a5cda21c68ea75a27804c944 ]

In commit b2d438348024b75a1ee8b66b85d77f569a5dfed8 ("sparc64: Make
PAGE_OFFSET variable."), the MAX_PHYS_ADDRESS_BITS value was increased
(to 47).

This constant reference to '41UL' was missed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/pgtable_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index ac5f708..ff97960 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -916,7 +916,7 @@ static inline bool kern_addr_valid(unsigned long addr)
 {
 	unsigned long paddr = __pa(addr);
 
-	if ((paddr >> 41UL) != 0UL)
+	if ((paddr >> MAX_PHYS_ADDRESS_BITS) != 0UL)
 		return false;
 	return test_bit(paddr >> 22, sparc64_valid_addr_bitmap);
 }
-- 
1.9.1

