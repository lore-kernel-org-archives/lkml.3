Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaKIJMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:12:40 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:65068 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbaKIJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:11:43 -0500
X-IronPort-AV: E=Sophos;i="5.07,345,1413237600"; 
   d="scan'208";a="105805277"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: kernel-janitors@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: lustre: libcfs_debug.h: remove final uses of the GOTO macro
Date: Sun,  9 Nov 2014 10:06:33 +0100
Message-Id: <1415523994-12520-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1415523994-12520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove the GOTO macro, as it is no longer used.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
index 8888b27..2e5a9e5 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
@@ -242,18 +242,6 @@ do {									\
 
 #define LCONSOLE_EMERG(format, ...) CDEBUG(D_CONSOLE | D_EMERG, format, ## __VA_ARGS__)
 
-void libcfs_log_goto(struct libcfs_debug_msg_data *, const char *, long_ptr_t);
-#define GOTO(label, rc)							\
-do {									\
-	if (cfs_cdebug_show(D_TRACE, DEBUG_SUBSYSTEM)) {		\
-		LIBCFS_DEBUG_MSG_DATA_DECL(msgdata, D_TRACE, NULL);	\
-		libcfs_log_goto(&msgdata, #label, (long_ptr_t)(rc));	\
-	} else {							\
-		(void)(rc);						\
-	}								\
-	goto label;							\
-} while (0)
-
 int libcfs_debug_msg(struct libcfs_debug_msg_data *msgdata,
 			    const char *format1, ...)
 	__attribute__ ((format (printf, 2, 3)));

