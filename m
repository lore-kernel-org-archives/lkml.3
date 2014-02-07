Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbaBGMcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:32:08 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60404 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaBGMcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:32:02 -0500
Date: Fri, 7 Feb 2014 17:56:21 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 07/26] drivers: isdn: Move prototype declaration to header
 file platform.h from divasproc.c
Message-ID: <b29a188ce0a77d8e536258ef25745c82492e8f44.1390408515.git.rashika.kheria@gmail.com>
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

This eliminates the following warnings in hardware/eicon/divasmain.c:
drivers/isdn/hardware/eicon/divasmain.c:190:6: warning: no previous prototype for ‘divas_get_version’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/divasproc.c |    1 -
 drivers/isdn/hardware/eicon/platform.h  |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/eicon/divasproc.c b/drivers/isdn/hardware/eicon/divasproc.c
index 56ce98a..edb7f39 100644
--- a/drivers/isdn/hardware/eicon/divasproc.c
+++ b/drivers/isdn/hardware/eicon/divasproc.c
@@ -34,7 +34,6 @@
 
 
 extern PISDN_ADAPTER IoAdapters[MAX_ADAPTER];
-extern void divas_get_version(char *);
 extern void diva_get_vserial_number(PISDN_ADAPTER IoAdapter, char *buf);
 
 /*********************************************************
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index cdfbb19..e861857 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -150,6 +150,7 @@ struct _diva_os_timer;
 struct _ISDN_ADAPTER;
 
 void diva_log_info(unsigned char *, ...);
+void divas_get_version(char *);
 
 /*
 **  XDI DIDD Interface
-- 
1.7.9.5

