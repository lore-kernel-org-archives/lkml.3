Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaDAJU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:20:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:42167 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaDAJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:20:57 -0400
Date: Tue, 1 Apr 2014 11:21:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 iommu updates for 3.15
Message-ID: <alpine.DEB.2.02.1404011115290.14882@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-iommu-for-linus


* A quirk for the iommu quirk to include silicon which was assumed not
  to be out in the wild.

This time with the correct logic applied.

Thanks,

	tglx

------------------>
Neil Horman (1):
      x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets


 arch/x86/kernel/early-quirks.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..6d7d5a1 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -203,18 +203,15 @@ static void __init intel_remapping_check(int num, int slot, int func)
 	revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
 
 	/*
- 	 * Revision 13 of all triggering devices id in this quirk have
-	 * a problem draining interrupts when irq remapping is enabled,
-	 * and should be flagged as broken.  Additionally revisions 0x12
-	 * and 0x22 of device id 0x3405 has this problem.
+	 * Revision <= 13 of all triggering devices id in this quirk
+	 * have a problem draining interrupts when irq remapping is
+	 * enabled, and should be flagged as broken. Additionally
+	 * revision 0x22 of device id 0x3405 has this problem.
 	 */
-	if (revision == 0x13)
+	if (revision <= 0x13)
 		set_irq_remapping_broken();
-	else if ((device == 0x3405) &&
-	    ((revision == 0x12) ||
-	     (revision == 0x22)))
+	else if (device == 0x3405 && revision == 0x22)
 		set_irq_remapping_broken();
-
 }
 
 /*
