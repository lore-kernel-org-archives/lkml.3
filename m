Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaBGOCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:02:32 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62229 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaBGOCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:02:31 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-c6x-dev@linux-c6x.org
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, Joe Perches <joe@perches.com>
Subject: [PATCH] c6x: Include init.h in asm/cache.h
Date: Fri,  7 Feb 2014 06:02:22 -0800
Message-Id: <1391781742-32250-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/c6x/include/asm/cache.h uses __init and thus needs to include init.h.
This fixes the following c6x build error.

arch/c6x/include/asm/cache.h:63:20: error: expected '=', ',', ';',
'asm' or '__attribute__' before 'c6x_cache_init'
 extern void __init c6x_cache_init(void);

Problem was inadvertendly introduced with commit c28aa1f
(printk/cache: mark printk_once test variable __read_mostly).

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/c6x/include/asm/cache.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/c6x/include/asm/cache.h b/arch/c6x/include/asm/cache.h
index 09c5a0f..86648c0 100644
--- a/arch/c6x/include/asm/cache.h
+++ b/arch/c6x/include/asm/cache.h
@@ -12,6 +12,7 @@
 #define _ASM_C6X_CACHE_H
 
 #include <linux/irqflags.h>
+#include <linux/init.h>
 
 /*
  * Cache line size
-- 
1.7.9.7

