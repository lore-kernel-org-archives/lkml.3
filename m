Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaAEMfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 07:35:17 -0500
Received: from mx-rz-2.rrze.uni-erlangen.de ([131.188.11.21]:58104 "EHLO
	mx-rz-2.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbaAEMfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 07:35:11 -0500
X-RRZE-Submit-IP: 62.245.163.133
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com,
        andrea.merello@gmail.com, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com
Subject: [PATCH 2/3] Staging rtl8192e: Fixing checkpatch error in rtllib_debug.h
Date: Sun,  5 Jan 2014 13:25:36 +0100
Message-Id: <1388924737-1412-3-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
References: <1388924737-1412-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rtllib_debug.h we fixed the following checkpatch error:
	ERROR: Macros with complex values should be enclosed in parenthesis

We fixed this with a do {} while (0), because otherwise the compiler complained.

Signed-off-by: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
Signed-off-by: Matthias Schoepe <matthias.schoepe@studium.uni-erlangen.de>
---
 drivers/staging/rtl8192e/rtllib_debug.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_debug.h b/drivers/staging/rtl8192e/rtllib_debug.h
index c59f67b..31f616f 100644
--- a/drivers/staging/rtl8192e/rtllib_debug.h
+++ b/drivers/staging/rtl8192e/rtllib_debug.h
@@ -78,9 +78,11 @@ do {			\
 } while (0);
 
 #define assert(expr) \
+do {	\
 	if (!(expr)) {				  \
 		printk(KERN_INFO "Assertion failed! %s,%s,%s,line=%d\n", \
 		#expr, __FILE__, __func__, __LINE__);	  \
-	}
+	}	\
+} while (0);
 
 #endif
-- 
1.8.5.2

