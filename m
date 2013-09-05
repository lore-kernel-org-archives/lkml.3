Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705Ab3IELDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:03:43 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53408 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934094Ab3IELDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:03:41 -0400
Date: Thu, 5 Sep 2013 13:03:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20130905110335.GA23020@gmail.com>
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

   HEAD: 4488e09b4582c3d9cae1601351e26584e208d877 x86, doc: Add an entry in MAINTAINERS for arch/x86/kernel/cpu/vmware.c

Fix for the annoying paravirt.o build warning under allmodconfig, and a 
MAINTAINERS file update.

out-of-topic modifications in x86-urgent-for-linus:
---------------------------------------------------
MAINTAINERS                        # 4488e09: x86, doc: Add an entry in MAINTAI

 Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86, doc: Add an entry in MAINTAINERS for arch/x86/kernel/cpu/vmware.c

H. Peter Anvin (1):
      x86, paravirt: Remove duplicate definition for DEF_NATIVE


 MAINTAINERS                | 6 ++++++
 arch/x86/kernel/paravirt.c | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..fba8134 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9016,6 +9016,12 @@ F:	drivers/staging/vme/
 F:	drivers/vme/
 F:	include/linux/vme*
 
+VMWARE HYPERVISOR INTERFACE
+M:	Alok Kataria <akataria@vmware.com>
+L:	virtualization@lists.linux-foundation.org
+S:	Supported
+F:	arch/x86/kernel/cpu/vmware.c
+
 VMWARE VMXNET3 ETHERNET DRIVER
 M:	Shreyas Bhatewara <sbhatewara@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 884aa40..1b10af8 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -62,11 +62,6 @@ void __init default_banner(void)
 	       pv_info.name);
 }
 
-/* Simple instruction patching code. */
-#define DEF_NATIVE(ops, name, code)					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
-	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
-
 /* Undefined instruction for dealing with missing ops pointers. */
 static const unsigned char ud2a[] = { 0x0f, 0x0b };
 
