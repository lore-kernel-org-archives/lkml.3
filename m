Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaA0S6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:58:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaA0S6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:58:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 04/11] kernel: Build bin2c based on config option CONFIG_BUILD_BIN2C
Date: Mon, 27 Jan 2014 13:57:44 -0500
Message-Id: <1390849071-21989-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently bin2c builds only if CONFIG_IKCONFIG=y. But bin2c will now be
used by kexec too.  So make it compilation dependent on CONFIG_BUILD_BIN2C
and this config option can be selected by CONFIG_KEXEC and CONFIG_IKCONFIG.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/Kconfig       | 1 +
 init/Kconfig           | 5 +++++
 scripts/basic/Makefile | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 940e50e..aa5aeed 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1604,6 +1604,7 @@ source kernel/Kconfig.hz
 
 config KEXEC
 	bool "kexec system call"
+	select BUILD_BIN2C
 	---help---
 	  kexec is a system call that implements the ability to shutdown your
 	  current kernel, and to start another kernel.  It is like a reboot
diff --git a/init/Kconfig b/init/Kconfig
index 34a0a3b..32a1adb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -760,8 +760,13 @@ endchoice
 
 endmenu # "RCU Subsystem"
 
+config BUILD_BIN2C
+	bool
+	default n
+
 config IKCONFIG
 	tristate "Kernel .config support"
+	select BUILD_BIN2C
 	---help---
 	  This option enables the complete Linux kernel ".config" file
 	  contents to be saved in the kernel. It provides documentation
diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index afbc1cd..ec10d93 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -9,7 +9,7 @@
 # fixdep: 	 Used to generate dependency information during build process
 
 hostprogs-y	:= fixdep
-hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+hostprogs-$(CONFIG_BUILD_BIN2C)     += bin2c
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
-- 
1.8.4.2

