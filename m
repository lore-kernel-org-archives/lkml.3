Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbbAARv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:51:29 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:55510 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbAARv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:51:27 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steven Miao <realmz6@gmail.com>, adi-buildroot-devel@lists.sourceforge.net
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: blackfin: kernel: kgdb:  Remove unused function
Date: Thu,  1 Jan 2015 18:54:26 +0100
Message-Id: <1420134867-1594-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function kgdb_post_primary_code() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/blackfin/kernel/kgdb.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index fa53fae..b1cc04f 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -359,19 +359,6 @@ void kgdb_roundup_cpu(int cpu, unsigned long flags)
 static unsigned long kgdb_arch_imask;
 #endif
 
-void kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
-{
-	if (kgdb_single_step)
-		preempt_enable();
-
-#ifdef CONFIG_IPIPE
-	if (kgdb_arch_imask) {
-		cpu_pda[raw_smp_processor_id()].ex_imask = kgdb_arch_imask;
-		kgdb_arch_imask = 0;
-	}
-#endif
-}
-
 int kgdb_arch_handle_exception(int vector, int signo,
 			       int err_code, char *remcom_in_buffer,
 			       char *remcom_out_buffer,
-- 
1.7.10.4

