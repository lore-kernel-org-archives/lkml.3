Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaBGMjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:39:49 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63217 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaBGMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:39:33 -0500
Date: Fri, 7 Feb 2014 18:09:28 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 17/26] drivers: isdn: Move prototype declaration to header
 file platform.h from divasi.c
Message-ID: <315fb0ac18a0c05a74bca047f3e12bbd35a495b7.1390408518.git.rashika.kheria@gmail.com>
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

This eliminates the following warnings in hardware/eicon/idifunc.c:
drivers/isdn/hardware/eicon/idifunc.c:243:12: warning: no previous prototype for ‘idifunc_init’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/idifunc.c:263:13: warning: no previous prototype for ‘idifunc_finit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/divasi.c   |    3 ---
 drivers/isdn/hardware/eicon/platform.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/divasi.c b/drivers/isdn/hardware/eicon/divasi.c
index 4103a8c..c2a6f1a 100644
--- a/drivers/isdn/hardware/eicon/divasi.c
+++ b/drivers/isdn/hardware/eicon/divasi.c
@@ -48,9 +48,6 @@ static char *DRIVERLNAME = "diva_idi";
 static char *DEVNAME = "DivasIDI";
 char *DRIVERRELEASE_IDI = "2.0";
 
-extern int idifunc_init(void);
-extern void idifunc_finit(void);
-
 /*
  *  helper functions
  */
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index f170e21..33d6be1 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -179,6 +179,9 @@ static __inline__ void diva_os_free(unsigned long flags, void *ptr)
 	vfree(ptr);
 }
 
+int idifunc_init(void);
+void idifunc_finit(void);
+
 /*
 ** use skbuffs for message buffer
 */
-- 
1.7.9.5

