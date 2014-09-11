Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaIKNGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:06:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755741AbaIKNEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andrey Utkin" <andrey.krieger.utkin@gmail.com>,
        "David Binderman" <dcb314@hotmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.272413121@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 120/131] arch/sparc/math-emu/math_32.c: drop stray
 break  operator
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

