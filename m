Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbaEaW7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 18:59:22 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54628 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaEaW7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 18:59:21 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arch: tile: kernel: unaligned.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 01:00:13 +0200
Message-Id: <1401577213-3673-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/tile/kernel/unaligned.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/tile/kernel/unaligned.c b/arch/tile/kernel/unaligned.c
index b030b4e..ce475dd 100644
--- a/arch/tile/kernel/unaligned.c
+++ b/arch/tile/kernel/unaligned.c
@@ -569,7 +569,7 @@ void jit_bundle_gen(struct pt_regs *regs, tilegx_bundle_bits bundle,
 	tilegx_bundle_bits bundle_2 = 0;
 	/* If bundle_2_enable = false, bundle_2 is fnop/nop operation. */
 	bool     bundle_2_enable = true;
-	uint64_t ra, rb, rd = -1, clob1, clob2, clob3;
+	uint64_t ra = 0, rb = 0, rd = -1, clob1 = 0, clob2 = 0, clob3 = 0;
 	/*
 	 * Indicate if the unalign access
 	 * instruction's registers hit with
-- 
1.7.10.4

