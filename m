Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaG1NvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:51:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:32879 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaG1NvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:51:15 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>, Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH] staging: dgnc: removes unused if defined code
Date: Mon, 28 Jul 2014 22:51:03 +0900
Message-Id: <1406555463-30852-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DGNC_TRACER and TRC_TO_KMEM are never defined.

This patch removes if defined DGNC_TRACER and TRC_TO_KMEM code.

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c |    4 ---
 drivers/staging/dgnc/dgnc_driver.h |   53 ------------------------------------
 drivers/staging/dgnc/dgnc_trace.c  |    8 ------
 3 files changed, 65 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 68460af..a5be911 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -388,10 +388,6 @@ void dgnc_cleanup_module(void)
 
 	dgnc_tty_post_uninit();
 
-#if defined(DGNC_TRACER)
-	/* last thing, make sure we release the tracebuffer */
-	dgnc_tracer_free();
-#endif
 	if (dgnc_NumBoards)
 		pci_unregister_driver(&dgnc_driver);
 }
diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index b40ee2c..58b5aa7 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -91,57 +91,6 @@
 
 #define	DBG_CARR		(dgnc_debug & 0x10000)
 
-
-#if defined(DGNC_TRACER)
-
-# if defined(TRC_TO_KMEM)
-/* Choose one: */
-#  define TRC_ON_OVERFLOW_WRAP_AROUND
-#  undef  TRC_ON_OVERFLOW_SHIFT_BUFFER
-# endif /* TRC_TO_KMEM */
-
-# define TRC_MAXMSG		1024
-# define TRC_OVERFLOW		"(OVERFLOW)"
-# define TRC_DTRC		"/usr/bin/dtrc"
-
-#if defined TRC_TO_CONSOLE
-#define PRINTF_TO_CONSOLE(args) { printk(DRVSTR": "); printk args; }
-#else /* !defined TRACE_TO_CONSOLE */
-#define PRINTF_TO_CONSOLE(args)
-#endif
-
-#if defined TRC_TO_KMEM
-#define PRINTF_TO_KMEM(args) dgnc_tracef args
-#else /* !defined TRC_TO_KMEM */
-#define PRINTF_TO_KMEM(args)
-#endif
-
-#define	TRC(args)	{ PRINTF_TO_KMEM(args); PRINTF_TO_CONSOLE(args) }
-
-# define DPR_INIT(ARGS)		if (DBG_INIT) TRC(ARGS)
-# define DPR_BASIC(ARGS)	if (DBG_BASIC) TRC(ARGS)
-# define DPR_CORE(ARGS)		if (DBG_CORE) TRC(ARGS)
-# define DPR_OPEN(ARGS)		if (DBG_OPEN)  TRC(ARGS)
-# define DPR_CLOSE(ARGS)	if (DBG_CLOSE)  TRC(ARGS)
-# define DPR_READ(ARGS)		if (DBG_READ)  TRC(ARGS)
-# define DPR_WRITE(ARGS)	if (DBG_WRITE) TRC(ARGS)
-# define DPR_IOCTL(ARGS)	if (DBG_IOCTL) TRC(ARGS)
-# define DPR_PROC(ARGS)		if (DBG_PROC)  TRC(ARGS)
-# define DPR_PARAM(ARGS)	if (DBG_PARAM)  TRC(ARGS)
-# define DPR_PSCAN(ARGS)	if (DBG_PSCAN)  TRC(ARGS)
-# define DPR_EVENT(ARGS)	if (DBG_EVENT)  TRC(ARGS)
-# define DPR_DRAIN(ARGS)	if (DBG_DRAIN)  TRC(ARGS)
-# define DPR_CARR(ARGS)		if (DBG_CARR)  TRC(ARGS)
-# define DPR_MGMT(ARGS)		if (DBG_MGMT)  TRC(ARGS)
-# define DPR_INTR(ARGS)		if (DBG_INTR)  TRC(ARGS)
-# define DPR_MSIGS(ARGS)	if (DBG_MSIGS)  TRC(ARGS)
-
-# define DPR(ARGS)		if (dgnc_debug) TRC(ARGS)
-# define P(X)			dgnc_tracef(#X "=%p\n", X)
-# define X(X)			dgnc_tracef(#X "=%x\n", X)
-
-#else/* !defined DGNC_TRACER */
-
 #define PRINTF_TO_KMEM(args)
 # define TRC(ARGS)
 # define DPR_INIT(ARGS)
@@ -164,8 +113,6 @@
 
 # define DPR(args)
 
-#endif/* DGNC_TRACER */
-
 /* Number of boards we support at once. */
 #define	MAXBOARDS	20
 #define	MAXPORTS	8
diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
index d764154..3bb2259 100644
--- a/drivers/staging/dgnc/dgnc_trace.c
+++ b/drivers/staging/dgnc/dgnc_trace.c
@@ -42,14 +42,6 @@
 /* file level globals */
 static char *dgnc_trcbuf;		/* the ringbuffer */
 
-#if defined(TRC_TO_KMEM)
-static int dgnc_trcbufi = 0;		/* index of the tilde at the end of */
-#endif
-
-#if defined(TRC_TO_KMEM)
-static DEFINE_SPINLOCK(dgnc_tracef_lock);
-#endif
-
 /*
  * dgnc_tracer_free()
  *
-- 
1.7.9.5

