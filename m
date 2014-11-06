Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaKFPdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:33:47 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61361 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFPdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:33:44 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RESEND PATCH v3.18-rc3] kdb: Remove stack dump when entering kgdb due to NMI
Date: Thu,  6 Nov 2014 15:33:31 +0000
Message-Id: <1415288011-26322-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405518033-11671-1-git-send-email-daniel.thompson@linaro.org>
References: <1405518033-11671-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issuing a stack dump feels ergonomically wrong when entering due to NMI.

Entering due to NMI is normally a reaction to a user request, either the
NMI button on a server or a "magic knock" on a UART. Therefore the
backtrace behaviour on entry due to NMI should be like SysRq-g (no stack
dump) rather than like oops.

Note also that the stack dump does not offer any information that
cannot be trivial retrieved using the 'bt' command.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
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

