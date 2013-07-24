Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3GXSDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:03:35 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61491 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3GXSDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:03:31 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: [PATCH-RESEND 2/3] staging/lustre: fix build on non-x86
Date: Thu, 25 Jul 2013 02:00:20 +0800
Message-Id: <1374688821-9874-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374688821-9874-1-git-send-email-bergwolf@gmail.com>
References: <1374688821-9874-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On non-x86 we will build with Lustre's errno translate code but
it has a few issues.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
---
 drivers/staging/lustre/lustre/ptlrpc/Makefile |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/errno.c  |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/Makefile b/drivers/staging/lustre/lustre/ptlrpc/Makefile
index a379558..6d78b80 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/Makefile
+++ b/drivers/staging/lustre/lustre/ptlrpc/Makefile
@@ -16,7 +16,7 @@ ptlrpc_objs += sec.o sec_bulk.o sec_gc.o sec_config.o sec_lproc.o
 ptlrpc_objs += sec_null.o sec_plain.o nrs.o nrs_fifo.o
 
 ptlrpc-y := $(ldlm_objs) $(ptlrpc_objs)
-ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.c
+ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.o
 
 obj-$(CONFIG_PTLRPC_GSS) += gss/
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/errno.c b/drivers/staging/lustre/lustre/ptlrpc/errno.c
index 46e259e..1c10063 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/errno.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/errno.c
@@ -25,7 +25,7 @@
  * Copyright (c) 2013, Intel Corporation.
  */
 
-#include <libcfs/libcfs.h>
+#include <linux/libcfs/libcfs.h>
 #include <lustre/lustre_errno.h>
 
 /*
@@ -184,7 +184,6 @@ static int lustre_errno_hton_mapping[] = {
 	[EBADTYPE]		= LUSTRE_EBADTYPE,
 	[EJUKEBOX]		= LUSTRE_EJUKEBOX,
 	[EIOCBQUEUED]		= LUSTRE_EIOCBQUEUED,
-	[EIOCBRETRY]		= LUSTRE_EIOCBRETRY
 };
 
 static int lustre_errno_ntoh_mapping[] = {
@@ -331,7 +330,6 @@ static int lustre_errno_ntoh_mapping[] = {
 	[LUSTRE_EBADTYPE]		= EBADTYPE,
 	[LUSTRE_EJUKEBOX]		= EJUKEBOX,
 	[LUSTRE_EIOCBQUEUED]		= EIOCBQUEUED,
-	[LUSTRE_EIOCBRETRY]		= EIOCBRETRY
 };
 
 unsigned int lustre_errno_hton(unsigned int h)
-- 
1.7.9.5

