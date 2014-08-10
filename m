Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHJQFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 12:05:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38306 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaHJQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 12:05:08 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Eric Paris <eparis@redhat.com>
Subject: [PATCH] openrisc: Fix build failure
Date: Sun, 10 Aug 2014 09:05:02 -0700
Message-Id: <1407686702-15149-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Openrisc build fails with

In file included from arch/openrisc/kernel/signal.c:31:0:
./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
./arch/openrisc/include/asm/syscall.h:77:9: error:
			'EM_OPENRISC' undeclared (first use in this function)
make[1]: *** [arch/openrisc/kernel/signal.o] Error 1

Introduced by commit "ARCH: AUDIT: implement syscall_get_arch for all arches".

Fix by adding a missing include file.

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Only applies to -next at this time.

 arch/openrisc/kernel/signal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/signal.c b/arch/openrisc/kernel/signal.c
index 7d1b823..a887cd8 100644
--- a/arch/openrisc/kernel/signal.c
+++ b/arch/openrisc/kernel/signal.c
@@ -27,6 +27,7 @@
 #include <linux/stddef.h>
 #include <linux/tracehook.h>
 
+#include <asm/elf.h>
 #include <asm/processor.h>
 #include <asm/syscall.h>
 #include <asm/ucontext.h>
-- 
1.9.1

