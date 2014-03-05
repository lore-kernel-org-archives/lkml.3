Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaCERbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:31:08 -0500
Received: from mailscanner02.zoner.fi ([84.34.166.11]:26356 "EHLO
	mailscanner02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaCERbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:31:04 -0500
Date: Wed, 5 Mar 2014 19:30:57 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle McMartin <kyle@infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] xz: Enable all filters by default in Kconfig
Message-ID: <20140305193057.4a481aaf@tukaani.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lasse Collin <lasse.collin@tukaani.org>

This restores the old behavior that existed before 2013-02-22.
Disabling the filters only makes sense on embedded systems.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
---

 lib/xz/Kconfig |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -Nru linux-3.14-rc5.orig/lib/xz/Kconfig linux-3.14-rc5/lib/xz/Kconfig
--- linux-3.14-rc5.orig/lib/xz/Kconfig	2014-03-03 04:56:16.000000000 +0200
+++ linux-3.14-rc5/lib/xz/Kconfig	2014-03-03 13:26:58.402872951 +0200
@@ -9,33 +9,33 @@
 if XZ_DEC
 
 config XZ_DEC_X86
-	bool "x86 BCJ filter decoder"
-	default y if X86
+	bool "x86 BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder"
-	default y if PPC
+	bool "PowerPC BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder"
-	default y if IA64
+	bool "IA-64 BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder"
-	default y if ARM
+	bool "ARM BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder"
-	default y if (ARM && ARM_THUMB)
+	bool "ARM-Thumb BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder"
-	default y if SPARC
+	bool "SPARC BCJ filter decoder" if EXPERT
+	default y
 	select XZ_DEC_BCJ
 
 endif
