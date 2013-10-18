Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab3JRTLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:11:13 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43161 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab3JRTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:11:11 -0400
Date: Fri, 18 Oct 2013 21:11:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20131018191106.GA29451@gmail.com>
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

   # HEAD: dd3c9c4b603c664fedc12facf180db0f1794aafe x86: Update UV3 hub revision ID

Two fixlets:

  - fix a (rare-config) build bug
  - fix a next-gen SGI/UV hw/firmware enumeration bug

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86/microcode: Correct Kconfig dependencies

Russ Anderson (1):
      x86: Update UV3 hub revision ID


 arch/x86/Kconfig                   | 1 +
 arch/x86/kernel/apic/x2apic_uv_x.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 145d703..f67e839 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1033,6 +1033,7 @@ config X86_REBOOTFIXUPS
 
 config MICROCODE
 	tristate "CPU microcode loading support"
+	depends on CPU_SUP_AMD || CPU_SUP_INTEL
 	select FW_LOADER
 	---help---
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1191ac1..a419814 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -113,7 +113,7 @@ static int __init early_get_pnodeid(void)
 		break;
 	case UV3_HUB_PART_NUMBER:
 	case UV3_HUB_PART_NUMBER_X:
-		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE - 1;
+		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE;
 		break;
 	}
 
