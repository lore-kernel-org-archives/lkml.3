Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab3I1SX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:23:26 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45684 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab3I1SXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:23:22 -0400
Date: Sat, 28 Sep 2013 20:23:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20130928182318.GA7340@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: accd1e823ed1d5980106dd522a4c535084400830 x86/microcode/AMD: Fix patch level reporting for family 15h

An AMD microcode patch level sysfs reporting fixlet.

 Thanks,

	Ingo

------------------>
Suravee Suthikulpanit (1):
      x86/microcode/AMD: Fix patch level reporting for family 15h


 arch/x86/kernel/microcode_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7123b5d..af99f71 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -216,6 +216,7 @@ int apply_microcode_amd(int cpu)
 	/* need to apply patch? */
 	if (rev >= mc_amd->hdr.patch_id) {
 		c->microcode = rev;
+		uci->cpu_sig.rev = rev;
 		return 0;
 	}
 
