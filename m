Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaGVM3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:29:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbaGVM3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:29:11 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/2] module: return bool from within_module*()
Date: Tue, 22 Jul 2014 14:28:10 +0200
Message-Id: <1406032090-16151-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1406032090-16151-1-git-send-email-pmladek@suse.cz>
References: <1406032090-16151-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The within_module*() functions return only true or false. Let's use bool as
the return type.

Note that it should not change kABI because these are inline functions.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 include/linux/module.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 61d8fb2d0873..71f282a4e307 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -396,19 +396,21 @@ bool is_module_address(unsigned long addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
-static inline int within_module_core(unsigned long addr, const struct module *mod)
+static inline bool within_module_core(unsigned long addr,
+				      const struct module *mod)
 {
 	return (unsigned long)mod->module_core <= addr &&
 	       addr < (unsigned long)mod->module_core + mod->core_size;
 }
 
-static inline int within_module_init(unsigned long addr, const struct module *mod)
+static inline bool within_module_init(unsigned long addr,
+				      const struct module *mod)
 {
 	return (unsigned long)mod->module_init <= addr &&
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
 
-static inline int within_module(unsigned long addr, const struct module *mod)
+static inline bool within_module(unsigned long addr, const struct module *mod)
 {
 	return within_module_init(addr, mod) || within_module_core(addr, mod);
 }
-- 
1.8.4

