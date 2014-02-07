Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaBGMeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:34:00 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59065 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaBGMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:33:05 -0500
Date: Fri, 7 Feb 2014 18:03:00 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 11/26] drivers: isdn: Move prototype declarations to header
 file platform.h from mntfunc.c
Message-ID: <8590a8fab9971fc353e0dd4d46c33a3f8ecc18bb.1390408516.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions to header file
hardware/eicon/platform.h because they are used by more than one file.

This eliminates the following warnings in hardware/eicon/divamnt.c:
drivers/isdn/hardware/eicon/divamnt.c:75:5: warning: no previous prototype for ‘diva_os_copy_to_user’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/divamnt.c:80:5: warning: no previous prototype for ‘diva_os_copy_from_user’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/mntfunc.c  |    5 -----
 drivers/isdn/hardware/eicon/platform.h |    9 +++++++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/mntfunc.c b/drivers/isdn/hardware/eicon/mntfunc.c
index 1cd9aff..e304a1d 100644
--- a/drivers/isdn/hardware/eicon/mntfunc.c
+++ b/drivers/isdn/hardware/eicon/mntfunc.c
@@ -29,11 +29,6 @@ static DESCRIPTOR MAdapter;
 static DESCRIPTOR MaintDescriptor =
 { IDI_DIMAINT, 0, 0, (IDI_CALL) diva_maint_prtComp };
 
-extern int diva_os_copy_to_user(void *os_handle, void __user *dst,
-				const void *src, int length);
-extern int diva_os_copy_from_user(void *os_handle, void *dst,
-				  const void __user *src, int length);
-
 static void no_printf(unsigned char *x, ...)
 {
 	/* dummy debug function */
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index ef329e0..f170e21 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -277,6 +277,15 @@ void diva_os_remove_soft_isr(diva_os_soft_isr_t *psoft_isr);
 void diva_os_get_time(dword *sec, dword *usec);
 
 /*
+ * kernel/user space copy functions
+ */
+int diva_os_copy_to_user(void *os_handle, void __user *dst,
+			 const void *src, int length);
+int diva_os_copy_from_user(void *os_handle, void *dst,
+			   const void __user *src, int length);
+
+
+/*
 **  atomic operation, fake because we use threads
 */
 typedef int diva_os_atomic_t;
-- 
1.7.9.5

