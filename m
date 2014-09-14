Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaINIc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:32:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52541 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaINIcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:32:52 -0400
Message-ID: <541552B8.8020807@gmail.com>
Date: Sun, 14 Sep 2014 16:32:56 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>, rob.herring@calxeda.com,
        Geert Uytterhoeven <geert@linux-m68k.org>, pebolle@tiscali.nl
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add default one just like other architectures have done (e.g. cris,
score, sh ...), the related error with allmodconfig:

    LD      init/built-in.o
  drivers/built-in.o: In function `vgacon_save_screen':
  drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined reference to `screen_info'
  drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_resize':
  drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined reference to `screen_info'
  drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_switch':
  drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined reference to `screen_info'
  drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8407c): more undefined references to `screen_info' follow
  make: *** [vmlinux] Error 1

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/microblaze/kernel/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index ab5b488..8756d61 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -18,6 +18,7 @@
 #include <linux/console.h>
 #include <linux/debugfs.h>
 #include <linux/of_fdt.h>
+#include <linux/screen_info.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
@@ -42,6 +43,8 @@ DEFINE_PER_CPU(unsigned int, ENTRY_SP);	/* Saved SP on kernel entry */
 DEFINE_PER_CPU(unsigned int, R11_SAVE);	/* Temp variable for entry */
 DEFINE_PER_CPU(unsigned int, CURRENT_SAVE);	/* Saved current pointer */
 
+struct screen_info screen_info;
+
 unsigned int boot_cpuid;
 /*
  * Placed cmd_line to .data section because can be initialized from
-- 
1.9.3
