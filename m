Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaFKS75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:59:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47817 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaFKS7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:59:53 -0400
Date: Wed, 11 Jun 2014 20:59:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, m.chehab@samsung.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7 v5] trace, RAS: Add basic RAS trace event
Message-ID: <20140611185948.GB14923@pd.tnic>
References: <1402475691-30045-1-git-send-email-gong.chen@linux.intel.com>
 <1402475691-30045-2-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1402475691-30045-2-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 04:34:45AM -0400, Chen, Gong wrote:
> To avoid confuision and conflict of usage for RAS related trace event,
> add an unified RAS trace event stub.
> 
> v5 -> v4: remove explicit RAS menuconfig.
> v4 -> v3: change dependency rule of RAS_TRACE.
> v3 -> v2: fix dependency in Kconfig.
> v2 -> v1: adjust Kconfig to take RAS as a separate subsystem.

Let's simplify it a little - I've dropped RAS_TRACE for now. We can
carve it out later, when needed.

---
From: "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 1/7 v5] trace, RAS: Add basic RAS trace event

To avoid confuision and conflict of usage for RAS related trace event,
add an unified RAS trace event stub.

Start a RAS subsystem menu which will be fleshed out in time, when more
features get added to it.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1402475691-30045-2-git-send-email-gong.chen@linux.intel.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/Kconfig        |  2 ++
 drivers/Makefile       |  1 +
 drivers/edac/Kconfig   |  1 +
 drivers/edac/edac_mc.c |  3 ---
 drivers/ras/Kconfig    |  6 ++++++
 drivers/ras/Makefile   |  1 +
 drivers/ras/ras.c      | 12 ++++++++++++
 7 files changed, 23 insertions(+), 3 deletions(-)
 create mode 100644 drivers/ras/Kconfig
 create mode 100644 drivers/ras/Makefile
 create mode 100644 drivers/ras/ras.c

Index: linux/drivers/Kconfig
===================================================================
--- linux.orig/drivers/Kconfig	2014-06-11 17:14:23.782437196 +0200
+++ linux/drivers/Kconfig	2014-06-11 17:14:23.770437196 +0200
@@ -176,4 +176,6 @@ source "drivers/powercap/Kconfig"
 
 source "drivers/mcb/Kconfig"
 
+source "drivers/ras/Kconfig"
+
 endmenu
Index: linux/drivers/Makefile
===================================================================
--- linux.orig/drivers/Makefile	2014-06-11 17:14:23.782437196 +0200
+++ linux/drivers/Makefile	2014-06-11 17:14:23.770437196 +0200
@@ -158,3 +158,4 @@ obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
+obj-$(CONFIG_RAS)		+= ras/
Index: linux/drivers/edac/Kconfig
===================================================================
--- linux.orig/drivers/edac/Kconfig	2014-06-11 17:14:23.782437196 +0200
+++ linux/drivers/edac/Kconfig	2014-06-11 17:24:18.142427373 +0200
@@ -72,6 +72,7 @@ config EDAC_MCE_INJ
 
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
+	select RAS
 	help
 	  Some systems are able to detect and correct errors in main
 	  memory.  EDAC can report statistics on memory error
Index: linux/drivers/edac/edac_mc.c
===================================================================
--- linux.orig/drivers/edac/edac_mc.c	2014-06-11 17:14:23.782437196 +0200
+++ linux/drivers/edac/edac_mc.c	2014-06-11 17:14:23.770437196 +0200
@@ -33,9 +33,6 @@
 #include <asm/edac.h>
 #include "edac_core.h"
 #include "edac_module.h"
-
-#define CREATE_TRACE_POINTS
-#define TRACE_INCLUDE_PATH ../../include/ras
 #include <ras/ras_event.h>
 
 /* lock to memory controller's control array */
Index: linux/drivers/ras/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/ras/Kconfig	2014-06-11 17:24:00.846427659 +0200
@@ -0,0 +1,2 @@
+config RAS
+	bool
Index: linux/drivers/ras/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/ras/Makefile	2014-06-11 17:14:23.774437196 +0200
@@ -0,0 +1 @@
+obj-$(CONFIG_RAS) += ras.o
Index: linux/drivers/ras/ras.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/ras/ras.c	2014-06-11 17:14:23.774437196 +0200
@@ -0,0 +1,12 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ *	Chen, Gong <gong.chen@linux.intel.com>
+ */
+
+#define CREATE_TRACE_POINTS
+#define TRACE_INCLUDE_PATH ../../include/ras
+#include <ras/ras_event.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
--

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
