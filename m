Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaB0MOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:14:33 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57330 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaB0MOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:14:32 -0500
Date: Thu, 27 Feb 2014 17:44:24 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, josh@joshtriplett.org
Subject: [PATCH 32/46] kernel: Add prototype declaration to header file
 include/linux/module.h
Message-ID: <eab75e21791e605a986c3bb568619f800c79b454.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype definition of function to header file
include/linux/module.h because it is used by more than one file.

This eliminates the following warning in kernel/module.c:
kernel/module.c:3823:6: warning: no previous prototype for ‘module_layout’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/module.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index eaf60ff..bf88877 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -82,6 +82,14 @@ void sort_extable(struct exception_table_entry *start,
 void sort_main_extable(void);
 void trim_init_extable(struct module *m);
 
+#ifdef CONFIG_MODVERSIONS
+void module_layout(struct module *mod,
+		   struct modversion_info *ver,
+		   struct kernel_param *kp, 
+		   struct kernel_symbol *ks, 
+		   struct tracepoint * const *tp);
+#endif
+
 #ifdef MODULE
 #define MODULE_GENERIC_TABLE(gtype, name)			\
 extern const struct gtype##_id __mod_##gtype##_table		\
-- 
1.7.9.5

