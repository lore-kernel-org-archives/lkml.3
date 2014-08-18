Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaHRPJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:09:20 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:43400 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaHRPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:09:18 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [RESEND PATCH 3.17rc1] kdb: Remove stack dump when entering kgdb due to NMI
Date: Mon, 18 Aug 2014 16:09:01 +0100
Message-Id: <1408374541-13066-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405518033-11671-1-git-send-email-daniel.thompson@linaro.org>
References: <1405518033-11671-1-git-send-email-daniel.thompson@linaro.org>
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
index 379650b..f9ba423 100644
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

