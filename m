Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaEUA7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:59:32 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57944 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaEUA7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:59:31 -0400
Message-ID: <537BFA6F.9010309@gmail.com>
Date: Wed, 21 May 2014 08:59:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/unicore32/kernel/setup.c: add generic 'screen_info'
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
 arch/unicore32/kernel/setup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 87adbf5..94bc4bc 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -53,6 +53,8 @@ struct stack {
 
 static struct stack stacks[NR_CPUS];
 
+struct screen_info screen_info;
+
 char elf_platform[ELF_PLATFORM_SIZE];
 EXPORT_SYMBOL(elf_platform);
 
-- 
1.9.2.459.g68773ac
