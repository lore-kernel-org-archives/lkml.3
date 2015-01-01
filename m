Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbbAARTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:19:39 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:55955 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbAARTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:19:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: fw: arc: misc.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:22:37 +0100
Message-Id: <1420132958-32622-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
ArcGetSystemId() ArcSaveConfiguration() ArcRestart() ArcPowerDown() ArcHalt()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/fw/arc/misc.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

diff --git a/arch/mips/fw/arc/misc.c b/arch/mips/fw/arc/misc.c
index f9f5307..214dc88 100644
--- a/arch/mips/fw/arc/misc.c
+++ b/arch/mips/fw/arc/misc.c
@@ -20,34 +20,6 @@
 #include <asm/bootinfo.h>
 
 VOID
-ArcHalt(VOID)
-{
-	bc_disable();
-	local_irq_disable();
-	ARC_CALL0(halt);
-never:	goto never;
-}
-
-VOID
-ArcPowerDown(VOID)
-{
-	bc_disable();
-	local_irq_disable();
-	ARC_CALL0(pdown);
-never:	goto never;
-}
-
-/* XXX is this a soft reset basically? XXX */
-VOID
-ArcRestart(VOID)
-{
-	bc_disable();
-	local_irq_disable();
-	ARC_CALL0(restart);
-never:	goto never;
-}
-
-VOID
 ArcReboot(VOID)
 {
 	bc_disable();
@@ -65,18 +37,6 @@ ArcEnterInteractiveMode(VOID)
 never:	goto never;
 }
 
-LONG
-ArcSaveConfiguration(VOID)
-{
-	return ARC_CALL0(cfg_save);
-}
-
-struct linux_sysid *
-ArcGetSystemId(VOID)
-{
-	return (struct linux_sysid *) ARC_CALL0(get_sysid);
-}
-
 VOID __init
 ArcFlushAllCaches(VOID)
 {
-- 
1.7.10.4

