Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaBGMoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:44:39 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51959 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaBGMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:44:36 -0500
Date: Fri, 7 Feb 2014 18:14:29 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 21/26] drivers: isdn: Move prototype declaration to header
 file platform.h from os_4bri.c
Message-ID: <ba35e8744d30d59c93c19452ae0a9af4e428a4ce.1390408518.git.rashika.kheria@gmail.com>
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

This eliminates the following warnings in hardware/eicon/s_4bri.c:
drivers/isdn/hardware/eicon/s_4bri.c:128:6: warning: no previous prototype for ‘start_qBri_hardware’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/s_4bri.c:275:5: warning: no previous prototype for ‘qBri_FPGA_download’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/s_4bri.c:487:6: warning: no previous prototype for ‘prepare_qBri_functions’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/s_4bri.c:496:6: warning: no previous prototype for ‘prepare_qBri2_functions’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/os_4bri.c  |    9 ---------
 drivers/isdn/hardware/eicon/platform.h |    5 +++++
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/os_4bri.c b/drivers/isdn/hardware/eicon/os_4bri.c
index 54f7033..287ceee 100644
--- a/drivers/isdn/hardware/eicon/os_4bri.c
+++ b/drivers/isdn/hardware/eicon/os_4bri.c
@@ -23,15 +23,6 @@ static void *diva_xdiLoadFileFile = NULL;
 static dword diva_xdiLoadFileLength = 0;
 
 /*
-**  IMPORTS
-*/
-extern void prepare_qBri_functions(PISDN_ADAPTER IoAdapter);
-extern void prepare_qBri2_functions(PISDN_ADAPTER IoAdapter);
-
-extern int qBri_FPGA_download(PISDN_ADAPTER IoAdapter);
-extern void start_qBri_hardware(PISDN_ADAPTER IoAdapter);
-
-/*
 **  LOCALS
 */
 static unsigned long _4bri_bar_length[4] = {
diff --git a/drivers/isdn/hardware/eicon/platform.h b/drivers/isdn/hardware/eicon/platform.h
index a507cea..af3d0a6 100644
--- a/drivers/isdn/hardware/eicon/platform.h
+++ b/drivers/isdn/hardware/eicon/platform.h
@@ -187,6 +187,11 @@ void diddfunc_finit(void);
 
 void prepare_maestra_functions(PISDN_ADAPTER IoAdapter);
 
+void start_qBri_hardware(PISDN_ADAPTER IoAdapter);
+void prepare_qBri_functions(PISDN_ADAPTER IoAdapter);
+void prepare_qBri2_functions(PISDN_ADAPTER IoAdapter);
+int qBri_FPGA_download(PISDN_ADAPTER IoAdapter);
+
 /*
 ** use skbuffs for message buffer
 */
-- 
1.7.9.5

