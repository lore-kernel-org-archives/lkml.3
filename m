Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3KSPsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:48:32 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47265 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3KSPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:48:31 -0500
Date: Tue, 19 Nov 2013 16:48:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20131119154827.GA12692@gmail.com>
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

   # HEAD: cc08e04c3fdcaab767b8db27527002b2b4d758cb x86: Export 'boot_cpu_physical_apicid' to modules

A modular build fix for certain .config's.

 Thanks,

	Ingo

------------------>
David Rientjes (1):
      x86: Export 'boot_cpu_physical_apicid' to modules


 arch/x86/kernel/apic/apic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a7eb82d..befe498 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,6 +62,7 @@ unsigned disabled_cpus;
 
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
+EXPORT_SYMBOL_GPL(boot_cpu_physical_apicid);
 
 /*
  * The highest APIC ID seen during enumeration.
