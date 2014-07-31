Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaGaNcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:32:11 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52426 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaGaNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:32:09 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Seunghun Lee <waydi1@gmail.com>, Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH 2/2] staging: dgnc: Remove unneeded dgnc_trace.c and dgnc_trace.h
Date: Thu, 31 Jul 2014 22:31:48 +0900
Message-Id: <1406813508-4500-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unneeded dgnc_trace.c and dgnc_trace.h

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/Makefile      |    2 +-
 drivers/staging/dgnc/dgnc_cls.c    |    1 -
 drivers/staging/dgnc/dgnc_driver.c |    1 -
 drivers/staging/dgnc/dgnc_neo.c    |    1 -
 drivers/staging/dgnc/dgnc_trace.c  |   54 ------------------------------------
 drivers/staging/dgnc/dgnc_trace.h  |   34 -----------------------
 drivers/staging/dgnc/dgnc_tty.c    |    1 -
 7 files changed, 1 insertion(+), 93 deletions(-)
 delete mode 100644 drivers/staging/dgnc/dgnc_trace.c
 delete mode 100644 drivers/staging/dgnc/dgnc_trace.h

diff --git a/drivers/staging/dgnc/Makefile b/drivers/staging/dgnc/Makefile
index 888c433..733434f 100644
--- a/drivers/staging/dgnc/Makefile
+++ b/drivers/staging/dgnc/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_DGNC) += dgnc.o
 
 dgnc-objs :=   dgnc_cls.o dgnc_driver.o\
                dgnc_mgmt.o dgnc_neo.o\
-               dgnc_trace.o dgnc_tty.o dgnc_sysfs.o
+               dgnc_tty.o dgnc_sysfs.o
diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index 5a76a8e..cfa8384 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -41,7 +41,6 @@
 #include "dgnc_driver.h"	/* Driver main header file */
 #include "dgnc_cls.h"
 #include "dgnc_tty.h"
-#include "dgnc_trace.h"
 
 static inline void cls_parse_isr(struct dgnc_board *brd, uint port);
 static inline void cls_clear_break(struct channel_t *ch, int force);
diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index a5be911..764613b 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -40,7 +40,6 @@
 #include "dpacompat.h"
 #include "dgnc_mgmt.h"
 #include "dgnc_tty.h"
-#include "dgnc_trace.h"
 #include "dgnc_cls.h"
 #include "dgnc_neo.h"
 #include "dgnc_sysfs.h"
diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index 9de988c..68ff116 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -41,7 +41,6 @@
 #include "dgnc_driver.h"	/* Driver main header file */
 #include "dgnc_neo.h"		/* Our header file */
 #include "dgnc_tty.h"
-#include "dgnc_trace.h"
 
 static inline void neo_parse_lsr(struct dgnc_board *brd, uint port);
 static inline void neo_parse_isr(struct dgnc_board *brd, uint port);
diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
deleted file mode 100644
index 3bb2259..0000000
--- a/drivers/staging/dgnc/dgnc_trace.c
+++ /dev/null
@@ -1,54 +0,0 @@
-/*
- * Copyright 2003 Digi International (www.digi.com)
- *	Scott H Kilau <Scott_Kilau at digi dot com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED; without even the
- * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- * PURPOSE.  See the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *
- *	NOTE TO LINUX KERNEL HACKERS:  DO NOT REFORMAT THIS CODE!
- *
- *	This is shared code between Digi's CVS archive and the
- *	Linux Kernel sources.
- *	Changing the source just for reformatting needlessly breaks
- *	our CVS diff history.
- *
- *	Send any bug fixes/changes to:  Eng.Linux at digi dot com.
- *	Thank you.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>	/* For jiffies, task states */
-#include <linux/interrupt.h>	/* For tasklet and interrupt structs/defines */
-#include <linux/vmalloc.h>
-
-#include "dgnc_driver.h"
-#include "dgnc_trace.h"
-
-#define TRC_TO_CONSOLE 1
-
-/* file level globals */
-static char *dgnc_trcbuf;		/* the ringbuffer */
-
-/*
- * dgnc_tracer_free()
- *
- *
- */
-void dgnc_tracer_free(void)
-{
-	if (dgnc_trcbuf)
-		vfree(dgnc_trcbuf);
-}
diff --git a/drivers/staging/dgnc/dgnc_trace.h b/drivers/staging/dgnc/dgnc_trace.h
deleted file mode 100644
index 4f4e2b9..0000000
--- a/drivers/staging/dgnc/dgnc_trace.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright 2003 Digi International (www.digi.com)
- *	Scott H Kilau <Scott_Kilau at digi dot com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED; without even the
- * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- * PURPOSE.  See the GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *	NOTE: THIS IS A SHARED HEADER. DO NOT CHANGE CODING STYLE!!!
- *
- *****************************************************************************
- * Header file for dgnc_trace.c
- *
- */
-
-#ifndef __DGNC_TRACE_H
-#define __DGNC_TRACE_H
-
-#include "dgnc_driver.h"
-
-void dgnc_tracer_free(void);
-
-#endif
-
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 453efce..c712b43 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -53,7 +53,6 @@
 #include "dgnc_driver.h"
 #include "dgnc_tty.h"
 #include "dgnc_types.h"
-#include "dgnc_trace.h"
 #include "dgnc_neo.h"
 #include "dgnc_cls.h"
 #include "dpacompat.h"
-- 
1.7.9.5

