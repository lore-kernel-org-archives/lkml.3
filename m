Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbaIOWU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51404 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbaIOWU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 034/187] arch/sparc/math-emu/math_32.c: drop stray break operator
Date: Mon, 15 Sep 2014 15:07:24 -0700
Message-Id: <1410818997-9432-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Utkin <andrey.krieger.utkin@gmail.com>

[ Upstream commit 093758e3daede29cb4ce6aedb111becf9d4bfc57 ]

This commit is a guesswork, but it seems to make sense to drop this
break, as otherwise the following line is never executed and becomes
dead code. And that following line actually saves the result of
local calculation by the pointer given in function argument. So the
proposed change makes sense if this code in the whole makes sense (but I
am unable to analyze it in the whole).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81641
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.9.1

