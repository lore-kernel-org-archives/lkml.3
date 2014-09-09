Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaIIS74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:59:56 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:44260 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaIIS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:59:54 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 2/3 v2] sh/uapi: Add definition of TIOC[SG]RS485
Date: Tue,  9 Sep 2014 20:59:50 +0200
Message-Id: <1410289190-3913-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 (serial/8250: Add
support for RS485 IOCTLs), adds support for RS485 ioctls for 825_core on
all the archs. Unfortunaltely the definition of TIOCSRS485 and
TIOCGRS485 was missing on the ioctls.h file

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
Changelog:

v2: By GregKH

Follow the ioctl numbering scheme used by the particular
 architecture UAPI file you are editing.

 arch/sh/include/uapi/asm/ioctls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/include/uapi/asm/ioctls.h b/arch/sh/include/uapi/asm/ioctls.h
index 3422410..c9903e5 100644
--- a/arch/sh/include/uapi/asm/ioctls.h
+++ b/arch/sh/include/uapi/asm/ioctls.h
@@ -83,6 +83,8 @@
 #define TCSETS2		_IOW('T', 43, struct termios2)
 #define TCSETSW2	_IOW('T', 44, struct termios2)
 #define TCSETSF2	_IOW('T', 45, struct termios2)
+#define TIOCGRS485	_IOR('T', 46, struct serial_rs485)
+#define TIOCSRS485	_IOWR('T', 47, struct serial_rs485)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
-- 
2.1.0

