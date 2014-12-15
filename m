Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaLOPJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:09:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaLOO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 044/168] MIPS: lib: memcpy: Restore NOP on delay slot before returning to caller
Date: Mon, 15 Dec 2014 14:24:58 +0000
Message-Id: <1418653622-21105-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 51b1029d9966060c6ad02030e6f251425b4f06c1 upstream.

Commit cf62a8b8134dd3 ("MIPS: lib: memcpy: Use macro to build the
copy_user code") switched to a macro in order to build the memcpy
symbols in preparation for the EVA support. However, this commit
also removed the NOP instruction after the 'jr ra' when returning
back to the caller. This had no visible side-effects since the next
instruction was a load to the t0 register which was already in the
clobbered list, but it may have undesired effects in the future
if some other code is introduced in between the .Ldone and
the .Ll_exc_copy labels.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8512/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/lib/memcpy.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/lib/memcpy.S b/arch/mips/lib/memcpy.S
index c17ef80cf65a..5d3238af9b5c 100644
--- a/arch/mips/lib/memcpy.S
+++ b/arch/mips/lib/memcpy.S
@@ -503,6 +503,7 @@
 	STOREB(t0, NBYTES-2(dst), .Ls_exc_p1\@)
 .Ldone\@:
 	jr	ra
+	 nop
 	.if __memcpy == 1
 	END(memcpy)
 	.set __memcpy, 0
-- 
2.1.3

