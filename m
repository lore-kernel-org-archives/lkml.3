Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937Ab3GSSYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:24:36 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50379 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3GSSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:24:35 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: change defconfig to stop spawning xterm
Date: Fri, 19 Jul 2013 23:50:17 +0530
Message-Id: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.3.797.gb72c616.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default configuration dictates that um Linux will launch xterms
connected to various tty devices on the host.  It makes more sense to
connect to /dev/pts/N, so that the host can:

  $ screen /dev/pts/N

or

  $ minicom /dev/pts/N

to start talking to the guest session.  Note that
con0 (CONFIG_CON_ZERO_CHAN) still defaults to "fd:0,fd:1", printing boot
messages on the same terminal.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Further, I will patch systemd to getty on con0 when um Linux is
 detected.  Thanks for all the help, and sorry I took so long to
 figure it out.

 Applies on top of the patch I sent earlier.

 arch/um/configs/i386_defconfig   | 2 +-
 arch/um/configs/x86_64_defconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/configs/i386_defconfig b/arch/um/configs/i386_defconfig
index 995aecd..74d8823 100644
--- a/arch/um/configs/i386_defconfig
+++ b/arch/um/configs/i386_defconfig
@@ -278,7 +278,7 @@ CONFIG_TTY_CHAN=y
 CONFIG_XTERM_CHAN=y
 # CONFIG_NOCONFIG_CHAN is not set
 CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
-CONFIG_CON_CHAN="xterm"
+CONFIG_CON_CHAN="pts"
 CONFIG_SSL_CHAN="pts"
 CONFIG_UML_SOUND=m
 CONFIG_SOUND=m
diff --git a/arch/um/configs/x86_64_defconfig b/arch/um/configs/x86_64_defconfig
index f2c6123..7d4cbbf 100644
--- a/arch/um/configs/x86_64_defconfig
+++ b/arch/um/configs/x86_64_defconfig
@@ -270,7 +270,7 @@ CONFIG_TTY_CHAN=y
 CONFIG_XTERM_CHAN=y
 # CONFIG_NOCONFIG_CHAN is not set
 CONFIG_CON_ZERO_CHAN="fd:0,fd:1"
-CONFIG_CON_CHAN="xterm"
+CONFIG_CON_CHAN="pts"
 CONFIG_SSL_CHAN="pts"
 CONFIG_UML_SOUND=m
 CONFIG_SOUND=m
-- 
1.8.3.3.797.gb72c616.dirty

