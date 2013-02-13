Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab3BMTzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:55:51 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43361 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3BMTzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:55:49 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        George Spelvin <linux@horizon.com>
Subject: [PATCH] pps: Fix build breakage from decoupling pps from tty
Date: Wed, 13 Feb 2013 14:54:30 -0500
Message-Id: <1360785270-18264-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:
tree:   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git tty-next
head:   bc80fbe46be7430487a45ad92841932bb2eaa3e6
commit: 593fb1ae457aab28b392ac114f6e3358788da985 pps: Move timestamp read into PPS code proper
date:   78 minutes ago
config: make ARCH=sparc defconfig

All error/warnings:

   In file included from drivers/tty/serial/suncore.c:20:0:
>> include/linux/sunserialcore.h:29:15: warning: 'struct device_node' declared inside parameter list [enabled by default]
>> include/linux/sunserialcore.h:29:15: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>> include/linux/sunserialcore.h:31:18: warning: 'struct device_node' declared inside parameter list [enabled by default]
>> drivers/tty/serial/suncore.c:55:5: error: conflicting types for 'sunserial_console_match'
   include/linux/sunserialcore.h:28:12: note: previous declaration of 'sunserial_console_match' was here
>> drivers/tty/serial/suncore.c:83:1: error: conflicting types for 'sunserial_console_match'
   include/linux/sunserialcore.h:28:12: note: previous declaration of 'sunserial_console_match' was here
>> drivers/tty/serial/suncore.c:85:6: error: conflicting types for 'sunserial_console_termios'
   include/linux/sunserialcore.h:30:13: note: previous declaration of 'sunserial_console_termios' was here

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: George Spelvin <linux@horizon.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/sunserialcore.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/sunserialcore.h b/include/linux/sunserialcore.h
index 68e7430..dbe4d7f 100644
--- a/include/linux/sunserialcore.h
+++ b/include/linux/sunserialcore.h
@@ -13,6 +13,10 @@
 #ifndef _SERIAL_SUN_H
 #define _SERIAL_SUN_H
 
+#include <linux/device.h>
+#include <linux/serial_core.h>
+#include <linux/console.h>
+
 /* Serial keyboard defines for L1-A processing... */
 #define SUNKBD_RESET		0xff
 #define SUNKBD_L1		0x01
-- 
1.8.1.2

