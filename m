Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaIIFR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:17:57 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:61744 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaIIFRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:17:55 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Joe Schultz <jschultz@xes-inc.com>, Ingo Molnar <mingo@elte.hu>,
        Doug Anderson <dianders@chromium.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 1/2] serial/8250_core: Add reference to uacess.h
Date: Tue,  9 Sep 2014 07:17:45 +0200
Message-Id: <1410239865-22678-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 [3/21] serial/8250: Add
support for RS485 IOCTLs, adds a building error on arch m32r.

All error/warnings:

   drivers/tty/serial/8250/8250_core.c: In function 'serial8250_ioctl':
>> drivers/tty/serial/8250/8250_core.c:2859:3: error: implicit declaration of function 'copy_from_user' [-Werror=implicit-function-declaration]
      if (copy_from_user(&rs485_config, (void __user *)arg,
      ^
>> drivers/tty/serial/8250/8250_core.c:2871:3: error: implicit declaration of function 'copy_to_user' [-Werror=implicit-function-declaration]
      if (copy_to_user((void __user *)arg, &up->rs485,
      ^
   cc1: some warnings being treated as errors

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/8250/8250_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 872c020..a0c1d64 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -37,6 +37,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/uaccess.h>
 #ifdef CONFIG_SPARC
 #include <linux/sunserialcore.h>
 #endif
-- 
2.1.0

