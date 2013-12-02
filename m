Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3LBUOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:14:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3LBUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:14:45 -0500
Message-ID: <529CEA30.8010805@infradead.org>
Date: Mon, 02 Dec 2013 12:14:40 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Timur Tabi <timur@freescale.com>
Subject: [PATCH] init.h: add missing initcall variants
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add missing initcall variants when building for loadable modules.
This fixes this build error on powerpc allmodconfig:

drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Timur Tabi <timur@freescale.com>
---
 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-313-rc2.orig/include/linux/init.h
+++ lnx-313-rc2/include/linux/init.h
@@ -286,9 +286,11 @@ void __init parse_early_options(char *cm
 #define arch_initcall(fn)		module_init(fn)
 #define subsys_initcall(fn)		module_init(fn)
 #define fs_initcall(fn)			module_init(fn)
+#define rootfs_initcall(fn)		module_init(fn)
 #define device_initcall(fn)		module_init(fn)
 #define late_initcall(fn)		module_init(fn)
 
+#define console_initcall(fn)		module_init(fn)
 #define security_initcall(fn)		module_init(fn)
 
 /* Each module must use one module_init(). */
