Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbaHHWOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:14:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581AbaHHVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:35:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Binderman <dcb314@hotmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 23/23] arch/sparc/math-emu/math_32.c: drop stray break operator
Date: Fri,  8 Aug 2014 14:35:08 -0700
Message-Id: <20140808213316.764046419@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213315.769217722@linuxfoundation.org>
References: <20140808213315.769217722@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/math-emu/math_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/math-emu/math_32.c
+++ b/arch/sparc/math-emu/math_32.c
@@ -499,7 +499,7 @@ static int do_one_mathemu(u32 insn, unsi
 		case 0: fsr = *pfsr;
 			if (IR == -1) IR = 2;
 			/* fcc is always fcc0 */
-			fsr &= ~0xc00; fsr |= (IR << 10); break;
+			fsr &= ~0xc00; fsr |= (IR << 10);
 			*pfsr = fsr;
 			break;
 		case 1: rd->s = IR; break;


