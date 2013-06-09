Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3FIKIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:08:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47456 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab3FIKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:07:37 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/5] x86, debug: Add a collect-all misc debug checks option
Date: Sun,  9 Jun 2013 12:07:31 +0200
Message-Id: <1370772454-6106-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370772454-6106-1-git-send-email-bp@alien8.de>
References: <1370772454-6106-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Instead of adding a Kconfig debug option for every single aspect of x86
debugging code we have in the kernel, let's just simply add one which
people can enable and get all the debugging stuff switched on; boot and
test the resulting kernel and if they're satisfied, ship their patches.

This should save a lot of time of wading through "Kernel hacking" and
wondering what option to enable.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig.debug | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b6a770132b67..1dab525cd358 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -303,4 +303,16 @@ config DEBUG_NMI_SELFTEST
 
 	  If unsure, say N.
 
+config X86_MISC_DEBUG_CHECKS
+	bool "Miscellaneous debugging checks"
+	depends on DEBUG_KERNEL
+	---help---
+	  Enable different build and runtime sanity checks. Those are
+	  lumped together here so as not to search through Kconfig debug
+	  options but have this one only enabled and get them all.
+
+	  This option enables:
+	   - static_cpu_has premature usage
+
+	   If unsure, say N.
 endmenu
-- 
1.8.3

