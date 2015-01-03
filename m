Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbbACQ6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:58:54 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:51086 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbACQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:58:49 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steven Miao <realmz6@gmail.com>, Sonic Zhang <sonic.zhang@analog.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Christoph Lameter <cl@linux.com>,
        Masanari Iida <standby24x7@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] blackfin: mach-common: ints-priority:  Remove unused function
Date: Sat,  3 Jan 2015 18:01:49 +0100
Message-Id: <1420304509-13072-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function bfin_sec_resume() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/blackfin/mach-common/ints-priority.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index dd2af74..7236bdf 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -429,14 +429,6 @@ static void init_software_driven_irq(void)
 	bfin_sec_enable_ssi(37);
 }
 
-void bfin_sec_resume(void)
-{
-	bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_RESET);
-	udelay(100);
-	bfin_write_SEC_GCTL(SEC_GCTL_EN);
-	bfin_write_SEC_SCI(0, SEC_CCTL, SEC_CCTL_EN | SEC_CCTL_NMI_EN);
-}
-
 void handle_sec_sfi_fault(uint32_t gstat)
 {
 
-- 
1.7.10.4

