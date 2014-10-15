Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaJOPjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:39:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:15868 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaJOPjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:39:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="scan'208";a="619182099"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] arch/x86/realmode: make trampoline code conditional for x86-32
Date: Wed, 15 Oct 2014 17:38:26 +0200
Message-Id: <1413387506-5269-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trampoline code is only needed for SMP and in x86-64 for wakeup
code. Make it conditional in order to minimize the kernel size.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/realmode/rm/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 7c0d7be..82b7312 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -20,7 +20,11 @@ wakeup-objs	+= video-vesa.o
 wakeup-objs	+= video-bios.o
 
 realmode-y			+= header.o
+ifdef CONFIG_X86_64
 realmode-y			+= trampoline_$(BITS).o
+else
+realmode-$(CONFIG_SMP)		+= trampoline_$(BITS).o
+endif
 realmode-y			+= stack.o
 realmode-y			+= reboot.o
 realmode-$(CONFIG_ACPI_SLEEP)	+= $(wakeup-objs)
-- 
2.1.0

