Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaLFWc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:32:59 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:60122 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaLFWc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:32:57 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: alpha: kernel: core_titan.c:  Remove some unused functions
Date: Sat,  6 Dec 2014 23:35:35 +0100
Message-Id: <1417905335-4990-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
titan_write_tig() titan_read_tig()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/alpha/kernel/core_titan.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/alpha/kernel/core_titan.c b/arch/alpha/kernel/core_titan.c
index 219bf27..2de2a2a 100644
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -62,21 +62,7 @@ mk_tig_addr(int offset)
 	return (volatile unsigned long *)(TITAN_TIG_SPACE + (offset << 6));
 }
 
-static inline u8 
-titan_read_tig(int offset, u8 value)
-{
-	volatile unsigned long *tig_addr = mk_tig_addr(offset);
-	return (u8)(*tig_addr & 0xff);
-}
-
-static inline void 
-titan_write_tig(int offset, u8 value)
-{
-	volatile unsigned long *tig_addr = mk_tig_addr(offset);
-	*tig_addr = (unsigned long)value;
-}
 
-
 /*
  * Given a bus, device, and function number, compute resulting
  * configuration space address
-- 
1.7.10.4

