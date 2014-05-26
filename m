Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaEZTkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:40:49 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:54773 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539AbaEZTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:40:48 -0400
Message-ID: <1401133246.6068.33.camel@x220>
Subject: [PATCH] staging: rtl8192u: remove checks for CONFIG_RTL8192_PM
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 21:40:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2014 19:40:47.0258 (UTC) FILETIME=[641A27A0:01CF791A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the rtl8192u driver was added in v2.6.33 its code contained checks
for CONFIG_RTL8192_PM. The related Kconfig symbol didn't exist then. It
still doesn't exist now. Remove these checks.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Note that the file r8192_pm.h doesn't exist. And there are
also no functions rtl8192_suspend and rtl8192_resume. Done on top of
next-20140526.

 drivers/staging/rtl8192u/r8192U_core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 97af38f9f281..24272c51bc9d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -97,10 +97,6 @@ double __extendsfdf2(float a)
 #include <linux/seq_file.h>
 // FIXME: check if 2.6.7 is ok
 
-#ifdef CONFIG_RTL8192_PM
-#include "r8192_pm.h"
-#endif
-
 #include "dot11d.h"
 //set here to open your trace code. //WB
 u32 rt_global_debug_component = COMP_DOWN	|
@@ -159,13 +155,8 @@ static struct usb_driver rtl8192_usb_driver = {
 	.id_table	= rtl8192_usb_id_tbl,		  /* PCI_ID table  */
 	.probe		= rtl8192_usb_probe,		  /* probe fn      */
 	.disconnect	= rtl8192_usb_disconnect,	  /* remove fn     */
-#ifdef CONFIG_RTL8192_PM
-	.suspend	= rtl8192_suspend,		  /* PM suspend fn */
-	.resume		= rtl8192_resume,                 /* PM resume fn  */
-#else
 	.suspend	= NULL,				  /* PM suspend fn */
 	.resume		= NULL,				  /* PM resume fn  */
-#endif
 };
 

-- 
1.9.0

