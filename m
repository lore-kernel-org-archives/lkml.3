Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093AbaJ1Fod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:44:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54974 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977AbaJ1Foa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 01:44:30 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] arm64: ARCH_PFN_OFFSET should be unsigned long
Date: Tue, 28 Oct 2014 13:44:01 +0800
Message-ID: <1414475041-31480-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-28_04:2014-10-27,2014-10-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410280061
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pfns are unsigned long, but PHYS_PFN_OFFSET is phys_addr_t. This leads
to page_to_pfn() returning phys_addr_t which cause type mismatches in
some print statements.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm64/include/asm/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index ccc7087..a62cd07 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -142,7 +142,7 @@ static inline void *phys_to_virt(phys_addr_t x)
  *  virt_to_page(k)	convert a _valid_ virtual address to struct page *
  *  virt_addr_valid(k)	indicates whether a virtual address is valid
  */
-#define ARCH_PFN_OFFSET		PHYS_PFN_OFFSET
+#define ARCH_PFN_OFFSET		((unsigned long)PHYS_PFN_OFFSET)
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define	virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
-- 
1.7.9.5

