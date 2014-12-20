Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaLTWjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 17:39:48 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37846 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaLTWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 17:39:47 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: platforms: embedded6xx: mpc7448_hpc2.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 23:42:32 +0100
Message-Id: <1419115353-12374-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
mpc7448_hpc2_halt() mpc7448_hpc2_power_off()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index beeaf4a..df4ad95 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -156,17 +156,6 @@ void mpc7448_hpc2_restart(char *cmd)
 	for (;;) ;		/* Spin until reset happens */
 }
 
-void mpc7448_hpc2_power_off(void)
-{
-	local_irq_disable();
-	for (;;) ;		/* No way to shut power off with software */
-}
-
-void mpc7448_hpc2_halt(void)
-{
-	mpc7448_hpc2_power_off();
-}
-
 /*
  * Called very early, device-tree isn't unflattened
  */
-- 
1.7.10.4

