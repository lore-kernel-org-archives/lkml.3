Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaJMHti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:49:38 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54658 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaJMHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:49:34 -0400
Date: Mon, 13 Oct 2014 09:49:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/ras tree change for v3.18
Message-ID: <20141013074929.GA15685@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-ras-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-ras-for-linus

   # HEAD: d286c3af48e3ad187fc52a0060c71b0844f234ff x86/mce: Avoid showing repetitive message from intel_init_thermal()

This tree includes a single commit that tones down a kernel 
message to only occur during initial bootup, not during 
suspend/resume cycles.

 Thanks,

	Ingo

------------------>
Rakib Mullick (1):
      x86/mce: Avoid showing repetitive message from intel_init_thermal()


 arch/x86/kernel/cpu/mcheck/therm_throt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 36a1bb6d1ee0..1af51b1586d7 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -498,8 +498,8 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 
 
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
+		if (system_state == SYSTEM_BOOTING)
+			printk(KERN_DEBUG "CPU%d: Thermal monitoring handled by SMI\n", cpu);
 		return;
 	}
 
