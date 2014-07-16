Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbaGPNlh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:41:37 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36402 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbaGPNle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:41:34 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] kdb: Remove stack dump when entering kgdb due to NMI
Date: Wed, 16 Jul 2014 14:40:33 +0100
Message-Id: <1405518033-11671-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issuing a stack dump feels ergonomically wrong when entering due to NMI.

Entering due to NMI is a normally reaction to a user request, either the
NMI button on a server or a "magic knock" on a UART. Therefore the
backtrace behaviour on entry due to NMI should be like SysRq-g (no stack
dump) rather than like oops.

Note also that the stack dump does not offer any information that
cannot be trivial retrieved using the 'bt' command.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: kgdb-bugreport@lists.sourceforge.net
---
 kernel/debug/kdb/kdb_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 49f2425..6d19905 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1207,7 +1207,6 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 		kdb_printf("due to NonMaskable Interrupt @ "
 			   kdb_machreg_fmt "\n",
 			   instruction_pointer(regs));
-		kdb_dumpregs(regs);
 		break;
 	case KDB_REASON_SSTEP:
 	case KDB_REASON_BREAK:
-- 
1.9.3

