Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaBGMql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:46:41 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57346 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaBGMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:46:39 -0500
Date: Fri, 7 Feb 2014 18:16:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 23/26] drivers: isdn: Move prototype declaration to header
 file platform.h from divamnt.c
Message-ID: <be2e88206b9ca92090b57eb2981dfe606b0c824b.1390408519.git.rashika.kheria@gmail.com>
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

Move prototype declaration of functions to header file
hardware/eicon/platform.h because they are used by more than one file.

This eliminates the following warnings in hardware/eicon/mntfunc.c:
drivers/isdn/hardware/eicon/mntfunc.c:136:5: warning: no previous prototype for ‘maint_read_write’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/mntfunc.c:303:12: warning: no previous prototype for ‘mntfunc_init’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/mntfunc.c:351:13: warning: no previous prototype for ‘mntfunc_finit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/divamnt.c  |    4 ----
 drivers/isdn/hardware/eicon/platform.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/divamnt.c b/drivers/isdn/hardware/eicon/divamnt.c
index 48db08d..02a1d0d 100644
--- a/drivers/isdn/hardware/eicon/divamnt.c
+++ b/drivers/isdn/hardware/eicon/divamnt.c
@@ -47,10 +47,6 @@ static wait_queue_head_t msgwaitq;
 static unsigned long opened;
 static struct timeval start_time;
 
-extern int mntfunc_init(int *, void **, unsigned long);
-extern void mntfunc_finit(void);
-extern int maint_read_write(void __user *buf, int count);
-
 /*
  *  helper functions
  */
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index f26f6cb..6bec7db 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -195,6 +195,10 @@ int qBri_FPGA_download(PISDN_ADAPTER IoAdapter);
 void prepare_pri_functions(PISDN_ADAPTER IoAdapter);
 void prepare_pri2_functions(PISDN_ADAPTER IoAdapter);
 
+int mntfunc_init(int *, void **, unsigned long);
+void mntfunc_finit(void);
+int maint_read_write(void __user *buf, int count);
+
 /*
 ** use skbuffs for message buffer
 */
-- 
1.7.9.5

