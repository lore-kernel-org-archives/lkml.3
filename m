Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaBNX67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:58:59 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49786 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbaBNX65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:58:57 -0500
Date: Fri, 14 Feb 2014 15:58:50 -0800
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] lkdtm: include cacheflush.h
Message-ID: <20140214235849.GA30703@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures need cacheflush.h explicitly included (mips) for
use of flush_icache_range():

    config: make ARCH=mips allmodconfig
    All error/warnings:
    >> ERROR: "flush_icache_range" undefined!

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 47ed2d321351..2ebd52e05773 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -46,6 +46,7 @@
 #include <linux/debugfs.h>
 #include <linux/vmalloc.h>
 #include <linux/mman.h>
+#include <asm/cacheflush.h>
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
