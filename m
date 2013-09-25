Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3IYTuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 15:50:06 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:36983 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab3IYTuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 15:50:05 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] avr32: fix compiler warning
Date: Wed, 25 Sep 2013 21:50:01 +0200
Message-Id: <1380138601-29902-1-git-send-email-juhosg@openwrt.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following compiler warning:
    CC      arch/avr32/kernel/process.o
  arch/avr32/kernel/process.c: In function 'copy_thread':
  arch/avr32/kernel/process.c:292: warning: assignment makes integer \
  from pointer without a cast

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Note: the patch is against v3.12-rc2.
---
 arch/avr32/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index c273100..42a53e74 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -289,7 +289,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 		memset(childregs, 0, sizeof(struct pt_regs));
 		p->thread.cpu_context.r0 = arg;
 		p->thread.cpu_context.r1 = usp; /* fn */
-		p->thread.cpu_context.r2 = syscall_return;
+		p->thread.cpu_context.r2 = (unsigned long)syscall_return;
 		p->thread.cpu_context.pc = (unsigned long)ret_from_kernel_thread;
 		childregs->sr = MODE_SUPERVISOR;
 	} else {
-- 
1.7.10
