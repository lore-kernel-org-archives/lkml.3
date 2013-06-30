Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab3F3J6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 05:58:48 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48621 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3F3J6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 05:58:47 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68knommu: Mark functions only called from setup_arch() __init
Date: Sun, 30 Jun 2013 11:58:40 +0200
Message-Id: <1372586320-1151-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some functions that are only called (indirectly) from setup_arch() lack
__init annotations.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is sort of a v2 of "m68knommu: Mark config_BSP() __init", adding
parse_uboot_commandline(), init_hardware(), m360_cpm_reset()

 arch/m68k/kernel/setup_no.c         |    2 +-
 arch/m68k/platform/68000/m68328.c   |    3 ++-
 arch/m68k/platform/68000/m68EZ328.c |    3 ++-
 arch/m68k/platform/68000/m68VZ328.c |    9 +++++----
 arch/m68k/platform/68360/commproc.c |    3 ++-
 arch/m68k/platform/68360/config.c   |    3 ++-
 6 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/kernel/setup_no.c b/arch/m68k/kernel/setup_no.c
index 911ba47..5b16f5d 100644
--- a/arch/m68k/kernel/setup_no.c
+++ b/arch/m68k/kernel/setup_no.c
@@ -118,7 +118,7 @@ void (*mach_power_off)(void);
  *
  * Returns:
  */
-void parse_uboot_commandline(char *commandp, int size)
+static void __init parse_uboot_commandline(char *commandp, int size)
 {
 	extern unsigned long _init_sp;
 	unsigned long *sp;
diff --git a/arch/m68k/platform/68000/m68328.c b/arch/m68k/platform/68000/m68328.c
index a86eb66..e53caf4 100644
--- a/arch/m68k/platform/68000/m68328.c
+++ b/arch/m68k/platform/68000/m68328.c
@@ -15,6 +15,7 @@
 
 /***************************************************************************/
 
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/rtc.h>
@@ -42,7 +43,7 @@ void m68328_reset (void)
 
 /***************************************************************************/
 
-void config_BSP(char *command, int len)
+void __init config_BSP(char *command, int len)
 {
   printk(KERN_INFO "\n68328 support D. Jeff Dionne <jeff@uclinux.org>\n");
   printk(KERN_INFO "68328 support Kenneth Albanowski <kjahds@kjshds.com>\n");
diff --git a/arch/m68k/platform/68000/m68EZ328.c b/arch/m68k/platform/68000/m68EZ328.c
index a6eb72d..332b5e8 100644
--- a/arch/m68k/platform/68000/m68EZ328.c
+++ b/arch/m68k/platform/68000/m68EZ328.c
@@ -13,6 +13,7 @@
 
 /***************************************************************************/
 
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/rtc.h>
@@ -52,7 +53,7 @@ _bsc1(unsigned char *, gethwaddr, int, a)
 _bsc1(char *, getbenv, char *, a)
 #endif
 
-void config_BSP(char *command, int len)
+void __init config_BSP(char *command, int len)
 {
   unsigned char *p;
 
diff --git a/arch/m68k/platform/68000/m68VZ328.c b/arch/m68k/platform/68000/m68VZ328.c
index eb6964f..fd66583 100644
--- a/arch/m68k/platform/68000/m68VZ328.c
+++ b/arch/m68k/platform/68000/m68VZ328.c
@@ -14,6 +14,7 @@
 
 /***************************************************************************/
 
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/kd.h>
@@ -59,7 +60,7 @@ static void m68vz328_reset(void)
 	);
 }
 
-static void init_hardware(char *command, int size)
+static void __init init_hardware(char *command, int size)
 {
 #ifdef CONFIG_DIRECT_IO_ACCESS
 	SCR = 0x10;					/* allow user access to internal registers */
@@ -145,7 +146,7 @@ _bsc0(char *, getserialnum)
 _bsc1(unsigned char *, gethwaddr, int, a)
 _bsc1(char *, getbenv, char *, a)
 
-static void init_hardware(char *command, int size)
+static void __init init_hardware(char *command, int size)
 {
 	char *p;
 
@@ -167,7 +168,7 @@ static void m68vz328_reset(void)
 {
 }
 
-static void init_hardware(char *command, int size)
+static void __init init_hardware(char *command, int size)
 {
 }
 
@@ -175,7 +176,7 @@ static void init_hardware(char *command, int size)
 #endif
 /***************************************************************************/
 
-void config_BSP(char *command, int size)
+void __init config_BSP(char *command, int size)
 {
 	printk(KERN_INFO "68VZ328 DragonBallVZ support (c) 2001 Lineo, Inc.\n");
 
diff --git a/arch/m68k/platform/68360/commproc.c b/arch/m68k/platform/68360/commproc.c
index 8e4e10c..315727b 100644
--- a/arch/m68k/platform/68360/commproc.c
+++ b/arch/m68k/platform/68360/commproc.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/param.h>
@@ -77,7 +78,7 @@ void m360_cpm_reset(void);
 
 
 
-void m360_cpm_reset()
+void __init m360_cpm_reset()
 {
 /* 	pte_t		   *pte; */
 
diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
index 9877cef..0570741 100644
--- a/arch/m68k/platform/68360/config.c
+++ b/arch/m68k/platform/68360/config.c
@@ -11,6 +11,7 @@
  */
 
 #include <stdarg.h>
+#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -140,7 +141,7 @@ _bsc1(char *, getbenv, char *, a)
 #endif
 
 
-void config_BSP(char *command, int len)
+void __init config_BSP(char *command, int len)
 {
   unsigned char *p;
 
-- 
1.7.9.5

