Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaBGMmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:42:37 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56556 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaBGMmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:42:35 -0500
Date: Fri, 7 Feb 2014 18:12:30 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 19/26] drivers: isdn: Move prototype declaration to header
 file platform.h from diva_didd.c
Message-ID: <93d7188538418423685ecefaf3d2bb311b37be6e.1390408518.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of function to header file
hardware/eicon/platform.h because they are used by more than one file.

This eliminates the following warnings in hardware/eicon/diddfunc.c:
drivers/isdn/hardware/eicon/diddfunc.c:95:12: warning: no previous prototype for ‘diddfunc_init’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/diddfunc.c:110:13: warning: no previous prototype for ‘diddfunc_finit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/diva_didd.c |    3 ---
 drivers/isdn/hardware/eicon/platform.h  |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/diva_didd.c b/drivers/isdn/hardware/eicon/diva_didd.c
index fab6ccf..56d32a7 100644
--- a/drivers/isdn/hardware/eicon/diva_didd.c
+++ b/drivers/isdn/hardware/eicon/diva_didd.c
@@ -39,9 +39,6 @@ MODULE_LICENSE("GPL");
 #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
 
-extern int diddfunc_init(void);
-extern void diddfunc_finit(void);
-
 extern void DIVA_DIDD_Read(void *, int);
 
 static struct proc_dir_entry *proc_didd;
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index 33d6be1..d648ab7 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -182,6 +182,9 @@ static __inline__ void diva_os_free(unsigned long flags, void *ptr)
 int idifunc_init(void);
 void idifunc_finit(void);
 
+int diddfunc_init(void);
+void diddfunc_finit(void);
+
 /*
 ** use skbuffs for message buffer
 */
-- 
1.7.9.5

