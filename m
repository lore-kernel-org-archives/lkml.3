Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaHDUr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:47:58 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:47192 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:47:56 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] arch/sparc/math-emu/math_32.c: drop stray break operator
Date: Mon,  4 Aug 2014 23:47:41 +0300
Message-Id: <1407185261-1799-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is a guesswork, but it seems to make sense to drop this
break, as otherwise the following line is never executed and becomes
dead code. And that following line actually saves the result of
local calculation by the pointer given in function argument. So the
proposed change makes sense if this code in the whole makes sense (but I
am unable to analyze it in the whole).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81641
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 arch/sparc/math-emu/math_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/math-emu/math_32.c b/arch/sparc/math-emu/math_32.c
index aa4d55b..5ce8f2f 100644
--- a/arch/sparc/math-emu/math_32.c
+++ b/arch/sparc/math-emu/math_32.c
@@ -499,7 +499,7 @@ static int do_one_mathemu(u32 insn, unsigned long *pfsr, unsigned long *fregs)
 		case 0: fsr = *pfsr;
 			if (IR == -1) IR = 2;
 			/* fcc is always fcc0 */
-			fsr &= ~0xc00; fsr |= (IR << 10); break;
+			fsr &= ~0xc00; fsr |= (IR << 10);
 			*pfsr = fsr;
 			break;
 		case 1: rd->s = IR; break;
-- 
1.8.5.5

