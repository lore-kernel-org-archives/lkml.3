Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaJMICB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:02:01 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57834 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaJMIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:01:54 -0400
Date: Mon, 13 Oct 2014 10:01:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv tree change for v3.18
Message-ID: <20141013080149.GA16367@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   # HEAD: 8091c1f8ea2374695c105591179b1269fb5f2fbb x86/apic/uv: Remove unnecessary #ifdef

This tree includes a single cleanup commit.

 Thanks,

	Ingo

------------------>
Andreas Ruprecht (1):
      x86/apic/uv: Remove unnecessary #ifdef


 arch/x86/kernel/apic/x2apic_uv_x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 293b41df54ef..2f1b5e0df660 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -204,7 +204,6 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
-#ifdef CONFIG_SMP
 	unsigned long val;
 	int pnode;
 
@@ -223,7 +222,6 @@ static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 
 	atomic_set(&init_deasserted, 1);
-#endif
 	return 0;
 }
 
