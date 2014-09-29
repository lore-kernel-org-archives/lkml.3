Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaI2MTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:19:34 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56019 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaI2MTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:19:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PM / Domains: add missing include to linux/pm.h
Date: Mon, 29 Sep 2014 14:18:53 +0200
Message-ID: <3760683.0Y3oBQm6U1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o5uwRdAxoqVww+o1gvGuPJA72wU62ofAyOz/i9ySiYj
 bixopBhuVv3UxuuS4f3QtJhmvNqc3IyBmoR5tv8U8oS2WYYc5d
 fa1SvElaAXYQI082OayQDvPfSHnIOXbwGPC6W+FeUl2MpDE5vF
 ITGeuMx9kPee3eo8z+fiB27dCcFewSPDSLmu8p+lDKIYZRBvLB
 oF6skRzgDp8oJVhSVAN8kKmPCnMxk9Cj+VkGwEepmj+Hp4WSyF
 JqYPkBhF70upo+M49J05YTbdAR6sVk8Ryott1Me+zcdihJ5PIC
 qof8A6GT+J93LZDSX5gvKkS4W7ObNxb+zalOzsT6uFFFYIsqlU
 MJHoZFee7Gipm6WXaotU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added attach/detach API introduces a use of -ENODEV
in linux/pm.h, which can cause build errors:

In file included from arch/arm/mach-shmobile/cpuidle.c:11:0:
include/linux/pm.h: In function 'dev_pm_domain_attach':
include/linux/pm.h:631:10: error: 'ENODEV' undeclared (first use in this function)

This is easily solved by adding an include of linux/errno.h

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 46420dd73b80 ("PM / Domains: Add APIs to attach/detach a PM domain for a device")
---
This is from last thursday, please just ignore if someone else has
the same fix.

diff --git a/include/linux/pm.h b/include/linux/pm.h
index c4cbf485a5d6..56d1a7df4321 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -21,6 +21,7 @@
 #ifndef _LINUX_PM_H
 #define _LINUX_PM_H
 
+#include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>

