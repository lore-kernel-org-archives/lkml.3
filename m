Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaEGUdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:33:49 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:17962 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbaEGUdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:33:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocXANiXalNXQBiQ/2dsb2JhbABagwaDPahrCgUBmgoCAoEdF3SCZhwjGIECJBOIRQHQM4VWiHyERgEDjxuKGwGLAId7gzY7
Date: Wed, 7 May 2014 22:33:39 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/1] KERNEL: add __attribute__  in c file
Message-Id: <20140507223339.3dccf63d066edbcac207e6f3@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a sparse warning about noreturn attribute only
featuring in module.h

kernel/module.c:212:6: error: symbol '__module_put_and_exit' redeclared with
different type (originally declared at include/linux/module.h:449)-
different modifiers

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/linux/module.h | 4 ++--
 kernel/module.c        | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index f520a76..05ab8f3 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -446,8 +446,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data);
 
-extern void __module_put_and_exit(struct module *mod, long code)
-	__attribute__((noreturn));
+extern void __attribute__((noreturn)) __module_put_and_exit(struct module *mod,
+							    long code);
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code)
 
 #ifdef CONFIG_MODULE_UNLOAD
diff --git a/kernel/module.c b/kernel/module.c
index 079c461..7d78872 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -209,7 +209,8 @@ static inline void add_taint_module(struct module *mod, unsigned flag,
  * A thread that wants to hold a reference to a module only while it
  * is running can call this to safely exit.  nfsd and lockd use this.
  */
-void __module_put_and_exit(struct module *mod, long code)
+void __attribute__((noreturn)) __module_put_and_exit(struct module *mod,
+						     long code)
 {
 	module_put(mod);
 	do_exit(code);
-- 
1.8.4.5

