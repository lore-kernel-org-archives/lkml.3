Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaEUXI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:08:29 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37005 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaEUXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:08:28 -0400
Message-ID: <537D31E7.4030307@gmail.com>
Date: Thu, 22 May 2014 07:08:23 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arch/unicore32/kernel/setup.c: add generic 'screen_info'
 to avoid compiling failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic 'screen_info' just like another architectures have done
(e.g. tile, sh, score, ia64, hexagon, and cris).

The related error (with allmodconfig under unicore32):

    LD      init/built-in.o
  drivers/built-in.o: In function `vgacon_save_screen':
  powercap_sys.c:(.text+0x21788): undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_resize':
  powercap_sys.c:(.text+0x21b54): undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_switch':
  powercap_sys.c:(.text+0x21cb4): undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_init':
  powercap_sys.c:(.text+0x2296c): undefined reference to `screen_info'
  drivers/built-in.o: In function `vgacon_startup':
  powercap_sys.c:(.text+0x22e80): undefined reference to `screen_info'


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/setup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 87adbf5..3fa317f 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -53,6 +53,10 @@ struct stack {
 
 static struct stack stacks[NR_CPUS];
 
+#ifdef CONFIG_VGA_CONSOLE
+struct screen_info screen_info;
+#endif
+
 char elf_platform[ELF_PLATFORM_SIZE];
 EXPORT_SYMBOL(elf_platform);
 
-- 
1.9.2.459.g68773ac
