Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3CVAk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:40:59 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:57010 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab3CVAk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:40:56 -0400
Message-ID: <1363912851.1390.170.camel@x61.thuisdomein>
Subject: [PATCH] arch: remove KCORE_ELF again
From: Paul Bolle <pebolle@tiscali.nl>
To: Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Date: Fri, 22 Mar 2013 01:40:51 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2013 00:40:51.0395 (UTC) FILETIME=[E75D3130:01CE2695]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol KCORE_ELF was removed in v2.6.0, but reappeared in two
architectures. It is useless. Remove it again.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Sent as one patch. Feel free to tell me to split it up in two
patches.

 arch/tile/Kconfig   |  5 -----
 arch/xtensa/Kconfig | 15 ---------------
 2 files changed, 20 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 2f8ccff..18e2a81 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -411,11 +411,6 @@ endmenu
 
 menu "Executable file formats"
 
-# only elf supported
-config KCORE_ELF
-	def_bool y
-	depends on PROC_FS
-
 source "fs/Kconfig.binfmt"
 
 endmenu
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index b09de49..d10b159 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -252,21 +252,6 @@ endmenu
 
 menu "Executable file formats"
 
-# only elf supported
-config KCORE_ELF
-	def_bool y
-        depends on PROC_FS
-        help
-          If you enabled support for /proc file system then the file
-          /proc/kcore will contain the kernel core image in ELF format. This
-          can be used in gdb:
-
-          $ cd /usr/src/linux ; gdb vmlinux /proc/kcore
-
-          This is especially useful if you have compiled the kernel with the
-          "-g" option to preserve debugging information. It is mainly used
-	  for examining kernel data structures on the live kernel.
-
 source "fs/Kconfig.binfmt"
 
 endmenu
-- 
1.7.11.7

