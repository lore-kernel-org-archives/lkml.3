Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3EaHKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:10:45 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:15041 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3EaHKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:10:37 -0400
Date: Fri, 31 May 2013 09:10:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] There is no /sys/parameters
Message-ID: <20130531091029.5c5074bc@endymion.delvare>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no such path as /sys/parameters, module parameters live in
/sys/module/*/parameters.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |    2 +-
 kernel/params.c             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-3.10-rc3.orig/include/linux/moduleparam.h	2013-04-29 02:36:01.000000000 +0200
+++ linux-3.10-rc3/include/linux/moduleparam.h	2013-05-30 10:41:37.417314420 +0200
@@ -439,7 +439,7 @@ extern struct kernel_param_ops param_ops
 extern int param_set_copystring(const char *val, const struct kernel_param *);
 extern int param_get_string(char *buffer, const struct kernel_param *kp);
 
-/* for exporting parameters in /sys/parameters */
+/* for exporting parameters in /sys/module/.../parameters */
 
 struct module;
 
--- linux-3.10-rc3.orig/kernel/params.c	2013-05-13 15:27:49.883223693 +0200
+++ linux-3.10-rc3/kernel/params.c	2013-05-30 10:43:40.411316243 +0200
@@ -787,7 +787,7 @@ static void __init kernel_add_sysfs_para
 }
 
 /*
- * param_sysfs_builtin - add contents in /sys/parameters for built-in modules
+ * param_sysfs_builtin - add sysfs parameters for built-in modules
  *
  * Add module_parameters to sysfs for "modules" built into the kernel.
  *


-- 
Jean Delvare
