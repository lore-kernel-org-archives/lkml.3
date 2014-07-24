Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbaGXP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:27:07 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61644 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439AbaGXP1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:27:03 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH 2/3] staging: dgnc: Fix do not initialise statics to 0 or NULL
Date: Fri, 25 Jul 2014 00:26:52 +0900
Message-Id: <1406215613-9314-2-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
References: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes checkpatch errors
"do not initialise statics to 0 or NULL"

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_trace.c |    2 +-
 drivers/staging/dgnc/dgnc_tty.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
index 2f62f2a..9be4715 100644
--- a/drivers/staging/dgnc/dgnc_trace.c
+++ b/drivers/staging/dgnc/dgnc_trace.c
@@ -43,7 +43,7 @@
 static char *dgnc_trcbuf;		/* the ringbuffer */
 
 #if defined(TRC_TO_KMEM)
-static int dgnc_trcbufi = 0;		/* index of the tilde at the end of */
+static int dgnc_trcbufi;		/* index of the tilde at the end of */
 #endif
 
 #if defined(TRC_TO_KMEM)
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 714a069..919abda 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -67,7 +67,7 @@
  * internal variables
  */
 static struct dgnc_board	*dgnc_BoardsByMajor[256];
-static uchar		*dgnc_TmpWriteBuf = NULL;
+static uchar		*dgnc_TmpWriteBuf;
 static DECLARE_MUTEX(dgnc_TmpWriteSem);
 
 /*
-- 
1.7.9.5

