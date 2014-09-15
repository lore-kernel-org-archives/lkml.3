Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaIOFae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 01:30:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62833 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaIOFad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 01:30:33 -0400
From: behanw@converseincode.com
To: anderson@redhat.com, catalin.marinas@arm.com, jays.lee@samsung.com,
        msalter@redhat.com, steve.capper@linaro.org, will.deacon@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with clang
Date: Sun, 14 Sep 2014 22:30:15 -0700
Message-Id: <1410759015-15642-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140909101515.GB1754@arm.com>
References: <20140909101515.GB1754@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Remove '#' from immediate parameter in AARCH64 inline assembly in mmu.

This code now works with both gcc and clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c555672..6894ef3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -94,7 +94,7 @@ static int __init early_cachepolicy(char *p)
 	 */
 	asm volatile(
 	"	mrs	%0, mair_el1\n"
-	"	bfi	%0, %1, #%2, #8\n"
+	"	bfi	%0, %1, %2, #8\n"
 	"	msr	mair_el1, %0\n"
 	"	isb\n"
 	: "=&r" (tmp)
-- 
1.9.1

