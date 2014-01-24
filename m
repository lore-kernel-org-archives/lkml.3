Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaAXRpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:45:03 -0500
Received: from mail.windriver.com ([147.11.1.11]:61045 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAXRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:45:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paul Mundt <lethal@linux-sh.org>, <linux-sh@vger.kernel.org>
Subject: [PATCH] sh: mach-highlander/psw.c is tristate and should use module.h
Date: Fri, 24 Jan 2014 12:44:44 -0500
Message-ID: <1390585484-5736-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is controlled by a tristate Kconfig option, and hence
needs to include module.h so that it can get module_init() once
we relocate it from init.h into module.h in the future.

Note that module_exit() appears to be missing from the driver, so
it is questionable whether it would actually work for a removal
and reload cycle if it was configured for a modular build.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[patch will be added to init cleanup series:
   http://git.kernel.org/cgit/linux/kernel/git/paulg/init.git/  ]

 arch/sh/boards/mach-highlander/psw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/mach-highlander/psw.c b/arch/sh/boards/mach-highlander/psw.c
index 522786318d36..40e2b585d488 100644
--- a/arch/sh/boards/mach-highlander/psw.c
+++ b/arch/sh/boards/mach-highlander/psw.c
@@ -10,7 +10,7 @@
  * for more details.
  */
 #include <linux/io.h>
-#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <mach/highlander.h>
-- 
1.8.5.2

