Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaCXEPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:15:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53264 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaCXEPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:15:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] thermal: Fix KELVIN_TO_CELSIUS macro
Date: Sun, 23 Mar 2014 21:14:56 -0700
Message-Id: <1395634496-25040-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is always a good idea to use paranthesis around macro parameters
to avoid undesired side effects.

In this specific case, KELVIN_TO_CELSIUS() is used in
drivers/platform/x86/asus-wmi.c with parameter "value & 0xFFFF",
which due to operator evaluation order causes more or less random
results.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/thermal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7..02488c9 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -41,8 +41,8 @@
 #define THERMAL_NO_LIMIT	THERMAL_CSTATE_INVALID
 
 /* Unit conversion macros */
-#define KELVIN_TO_CELSIUS(t)	(long)(((long)t-2732 >= 0) ?	\
-				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
+#define KELVIN_TO_CELSIUS(t)	(long)(((long)(t)-2732 >= 0) ?	\
+				((long)(t)-2732+5)/10 : ((long)(t)-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
 /* Adding event notification support elements */
-- 
1.7.9.7

