Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3KSPm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:42:58 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:58919 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KSPm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:42:57 -0500
Date: Tue, 19 Nov 2013 16:42:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel update
Message-ID: <20131119154253.GA12219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   # HEAD: 9dd1220114e00d8ec5cdc20085bbe198b21e1985 smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency

A late change/fix decoupling CPUMASK_OFFSTACK from DEBUG_PER_CPU_MAPS, 
fallout of:

  b53b5eda8194 x86/cpu: Increase max CPU count to 8192
  bb61ccc7dbcb x86/cpu: Allow higher NR_CPUS values

 Thanks,

	Ingo

------------------>
Josh Boyer (1):
      smp/cpumask: Make CONFIG_CPUMASK_OFFSTACK=y usable without debug dependency


 lib/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index b3c8be0..50b47cd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -342,7 +342,8 @@ config CHECK_SIGNATURE
 	bool
 
 config CPUMASK_OFFSTACK
-	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	bool "Force CPU masks off stack"
+	depends on SMP
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
