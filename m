Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaCEACB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:02:01 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.201]:36918 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105AbaCEAB7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:01:59 -0500
X-Env-Sender: Jonathan.Ringle@gridpoint.com
X-Msg-Ref: server-7.tower-45.messagelabs.com!1393977718!34974927!1
X-Originating-IP: [67.200.113.45]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: Jon Ringle <jringle@gridpoint.com>
To: <linux-kernel@vger.kernel.org>
CC: Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH] Add option to build with -O3
Date: Tue, 4 Mar 2014 19:01:49 -0500
Message-ID: <1393977709-9809-1-git-send-email-jringle@gridpoint.com>
X-Mailer: git-send-email 1.8.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-EMS-Proccessed: KgU7Zc8frcTgvrN/cX2wdQ==
X-EMS-STAMP: Jzbcf0TAHxcuZlPN1ui/qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 Makefile     |  2 ++
 init/Kconfig | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 78209ee..e7f0b3c 100644
--- a/Makefile
+++ b/Makefile
@@ -581,6 +581,8 @@ all: vmlinux

 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS  += -Os $(call cc-disable-warning,maybe-uninitialized,)
+else ifdef CONFIG_CC_OPTIMIZE_FOR_SPEED
+KBUILD_CFLAGS   += -O3
 else
 KBUILD_CFLAGS  += -O2
 endif
diff --git a/init/Kconfig b/init/Kconfig
index 009a797..17d4c62 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1233,13 +1233,26 @@ source "usr/Kconfig"

 endif

+choice
+    prompt "Optimize"
+
+config CC_OPTIMIZE_NORMAL
+    bool "Optimize Normal (-O2)"
+    help
+      Enabling this option will pass "-O2" to gcc
 config CC_OPTIMIZE_FOR_SIZE
-       bool "Optimize for size"
+       bool "Optimize for size (-Os)"
        help
-         Enabling this option will pass "-Os" instead of "-O2" to gcc
+         Enabling this option will pass "-Os" to gcc
          resulting in a smaller kernel.

-         If unsure, say N.
+config CC_OPTIMIZE_FOR_SPEED
+    bool "Optimze for speed (-O3)"
+    help
+      Enabling this option will pass "-O3" to gcc
+      resulting in a larger kernel (but possibly faster)
+
+endchoice

 config SYSCTL
        bool
--
1.8.5.4


The information contained in this transmission may contain confidential information.  If the reader of this message is not the intended recipient, you are hereby notified that any review, dissemination, distribution or duplication of this communication is strictly prohibited.  If you are not the intended recipient, please contact the sender by reply email and destroy all copies of the original message.
