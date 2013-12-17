Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3LQJjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:39:10 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:44813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3LQJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:39:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] export: declare ksymtab symbols
Date: Tue, 17 Dec 2013 10:38:56 +0100
Message-Id: <1387273136-31449-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

sparse complains about any __ksymtab symbols with the following:

 warning: symbol '__ksymtab_...' was not declared. Should it be static?

due to Andi's patch making it non-static.

Mollify sparse by declaring the symbol extern, otherwise we get
drowned in sparse warnings for anything that uses EXPORT_SYMBOL
in the sources, making it easy to miss real warnings.

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/export.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/export.h b/include/linux/export.h
index 3f2793d..96e45ea 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -59,6 +59,7 @@ extern struct module __this_module;
 	static const char __kstrtab_##sym[]			\
 	__attribute__((section("__ksymtab_strings"), aligned(1))) \
 	= VMLINUX_SYMBOL_STR(sym);				\
+	extern const struct kernel_symbol __ksymtab_##sym;	\
 	__visible const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
 	__attribute__((section("___ksymtab" sec "+" #sym), unused))	\
-- 
1.8.5.1

