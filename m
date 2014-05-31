Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaEaXGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:06:07 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54550 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaEaXGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:06:06 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Bill Metzenthen <billm@melbpc.org.au>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: math-emu: poly_tan.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 01:06:57 +0200
Message-Id: <1401577618-4286-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/math-emu/poly_tan.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/math-emu/poly_tan.c b/arch/x86/math-emu/poly_tan.c
index 1875763..fc481d4 100644
--- a/arch/x86/math-emu/poly_tan.c
+++ b/arch/x86/math-emu/poly_tan.c
@@ -93,6 +93,7 @@ void poly_tan(FPU_REG *st0_ptr)
 		exponent = -1 + norm_Xsig(&argSignif);
 	} else {
 		invert = 0;
+		accum.lsw = 0;
 		argSignif.lsw = 0;
 		XSIG_LL(accum) = XSIG_LL(argSignif) = significand(st0_ptr);
 
-- 
1.7.10.4

