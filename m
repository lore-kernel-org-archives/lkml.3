Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbbAARxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:53:10 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:62074 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbAARxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:53:09 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mm: cache-feroceon-l2:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:56:09 +0100
Message-Id: <1420134969-1892-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
l2_inv_pa() l2_clean_pa()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mm/cache-feroceon-l2.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mm/cache-feroceon-l2.c b/arch/arm/mm/cache-feroceon-l2.c
index e028a7f..c2eac97 100644
--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -65,11 +65,6 @@ static inline void l2_put_va(unsigned long vaddr)
 #endif
 }
 
-static inline void l2_clean_pa(unsigned long addr)
-{
-	__asm__("mcr p15, 1, %0, c15, c9, 3" : : "r" (addr));
-}
-
 static inline void l2_clean_pa_range(unsigned long start, unsigned long end)
 {
 	unsigned long va_start, va_end, flags;
@@ -96,11 +91,6 @@ static inline void l2_clean_inv_pa(unsigned long addr)
 	__asm__("mcr p15, 1, %0, c15, c10, 3" : : "r" (addr));
 }
 
-static inline void l2_inv_pa(unsigned long addr)
-{
-	__asm__("mcr p15, 1, %0, c15, c11, 3" : : "r" (addr));
-}
-
 static inline void l2_inv_pa_range(unsigned long start, unsigned long end)
 {
 	unsigned long va_start, va_end, flags;
-- 
1.7.10.4

