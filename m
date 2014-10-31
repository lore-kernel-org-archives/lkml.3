Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbaJaPDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:03:06 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64581 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaJaPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:03:03 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-bc-5453a4a065e5
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFT] ARM: shmobile: rcar-gen2: Fix build breakage
Date: Fri, 31 Oct 2014 16:02:46 +0100
Message-id: <1414767766-19967-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJMWRmVeSWpSXmKPExsVy+t/xK7oLlgSHGHRdEbRo3vqV0eL1C0OL
	TY+vsVpc3jWHzWLOnynMFrcv81o8WP2WzaJ3ipkDh0dLcw+bx85Zd9k9Ni+p9+jbsorRY87P
	bywenzfJBbBFcdmkpOZklqUW6dslcGXM//mdpeA8Z8Xk1nVMDYx9HF2MnBwSAiYSTd+vs0PY
	YhIX7q1n62Lk4hASWMooMX3zTlYIp49J4vq/RywgVWwCxhKbly8BqxIRuMwoce39S6YuRg4O
	ZoEkiZ8/dUFqhAWsJZ7/nAk2lUVAVWJy+3xWEJtXwF1i5oNzUNvkJE4em8w6gZF7ASPDKkbR
	1NLkguKk9FwjveLE3OLSvHS95PzcTYyQkPm6g3HpMatDjAIcjEo8vBpfgkKEWBPLiitzDzFK
	cDArifD+6AgOEeJNSaysSi3Kjy8qzUktPsTIxMEp1cAYbpzRe3HditXpJ886lXhuMmLheX7Z
	teLFgQ4R7ebmrGd3k2e1L7sRIXpLd6Pvq/NTly2+va2e29iI4VqQnNsynwdXpwhtW3pUKPjG
	xg6T1ct3R/s5v3/02tvUseQ383uXCdMKHV5ammj4FJv/V5RltksUCEhwylIwbZ9pfXySnWxe
	52neW11KLMUZiYZazEXFiQAbBVhW9wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build breakage when building allmodconfig or allyesconfig introduced
by adding ISB instruction to rcar_gen2_timer_init() function
(9ce3fa6816c2 "ARM: shmobile: rcar-gen2: Add CA7 arch_timer
initialization for r8a7794"):

  CC      arch/arm/mach-shmobile/setup-rcar-gen2.o
/tmp/cc770qt0.s: Assembler messages:
/tmp/cc770qt0.s:378: Error: selected processor does not support ARM mode `isb'
/tmp/cc770qt0.s:381: Error: selected processor does not support ARM mode `isb'
/tmp/cc770qt0.s:383: Error: selected processor does not support ARM mode `isb'
make[1]: *** [arch/arm/mach-shmobile/setup-rcar-gen2.o] Error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-shmobile/setup-rcar-gen2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-shmobile/setup-rcar-gen2.c b/arch/arm/mach-shmobile/setup-rcar-gen2.c
index 3dd6edd9bd1d..47f85643785f 100644
--- a/arch/arm/mach-shmobile/setup-rcar-gen2.c
+++ b/arch/arm/mach-shmobile/setup-rcar-gen2.c
@@ -68,6 +68,7 @@ void __init rcar_gen2_timer_init(void)
 		 * secure code.
 		 */
 		asm volatile(
+		"	.arch	armv7-a\n"
 		"	cps	0x16\n"
 		"	mrc	p15, 0, r1, c1, c1, 0\n"
 		"	orr	r0, r1, #1\n"
-- 
1.9.1

