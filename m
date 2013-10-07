Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3JGPMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:12:42 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53358 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab3JGPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:12:41 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: SmartMIPS: Fix build
Date: Mon,  7 Oct 2013 17:10:42 +0200
Message-Id: <1381158642-10598-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All CONFIG_CPU_HAS_SMARTMIPS #ifdefs have been removed from code, but
the ACX register declaration in struct pt_regs is still protected by it,
causing builds to fail. Remove the #ifdef protection and always declare
the register.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/mips/include/asm/ptrace.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index 7bba9da..d47bdce 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -33,9 +33,7 @@ struct pt_regs {
 	unsigned long cp0_status;
 	unsigned long hi;
 	unsigned long lo;
-#ifdef CONFIG_CPU_HAS_SMARTMIPS
 	unsigned long acx;
-#endif
 	unsigned long cp0_badvaddr;
 	unsigned long cp0_cause;
 	unsigned long cp0_epc;
-- 
1.8.4

