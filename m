Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153AbaAEMfL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 07:35:11 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:43019 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbaAEMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 07:35:09 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2014 07:35:08 EST
X-RRZE-Submit-IP: 62.245.163.133
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com,
        andrea.merello@gmail.com, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com
Subject: [PATCH 3/3] Staging rtl8192e: Correcting wrong usage of macro in r8192E_phy.c and removing corresponding warning in rtllib_debug.h
Date: Sun,  5 Jan 2014 13:25:37 +0100
Message-Id: <1388924737-1412-4-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
References: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed in rtllib_debug.h the following checkpatch warning:
	WARNING: do {} while (0) macros should not be semicolon terminated.

After deleting this semicolon we also had to fix the wrong use of this macro in rtl8192e/r8192E_phy.c

Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c | 2 +-
 drivers/staging/rtl8192e/rtllib_debug.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
index 21e6ddd..5d6d304 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -1179,7 +1179,7 @@ void rtl8192_SetBWModeWorkItem(struct net_device *dev)
 
 	RT_TRACE(COMP_SWBW, "==>rtl8192_SetBWModeWorkItem()  Switch to %s "
 		 "bandwidth\n", priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20 ?
-		 "20MHz" : "40MHz")
+		 "20MHz" : "40MHz");
 
 
 	if (priv->rf_chip == RF_PSEUDO_11N) {
diff --git a/drivers/staging/rtl8192e/rtllib_debug.h b/drivers/staging/rtl8192e/rtllib_debug.h
index 31f616f..7537dae 100644
--- a/drivers/staging/rtl8192e/rtllib_debug.h
+++ b/drivers/staging/rtl8192e/rtllib_debug.h
@@ -75,7 +75,7 @@ do {			\
 	if (rt_global_debug_component & component) \
 		printk(KERN_DEBUG DRV_NAME ":" x "\n" , \
 		       ##args);\
-} while (0);
+} while (0)
 
 #define assert(expr) \
 do {	\
-- 
1.8.5.2

