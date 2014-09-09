Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaIILxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:53:10 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:40215 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbaIILxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:53:08 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>
Subject: [PATCH linux-next] MIPS: ioctls: Add missing TIOC{S,G}RS485 definitions
Date: Tue, 9 Sep 2014 12:52:55 +0100
Message-ID: <1410263575-26720-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e676253b19b2d269cccf67fdb1592120a0cd0676
(serial/8250: Add support for RS485 IOCTLs) added cases for the
TIOC{S,G}RS485 commands but this broke the build for MIPS:

drivers/tty/serial/8250/8250_core.c: In function 'serial8250_ioctl':
drivers/tty/serial/8250/8250_core.c:2874:7: error: 'TIOCSRS485' undeclared
(first use in this function)
drivers/tty/serial/8250/8250_core.c:2886:7: error: 'TIOCGRS485' undeclared
(first use in this function)

This patch adds these missing definitions

Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <linux-serial@vger.kernel.org>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
---
 arch/mips/include/uapi/asm/ioctls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/uapi/asm/ioctls.h b/arch/mips/include/uapi/asm/ioctls.h
index b1e637757fe3..34050cb6b631 100644
--- a/arch/mips/include/uapi/asm/ioctls.h
+++ b/arch/mips/include/uapi/asm/ioctls.h
@@ -76,6 +76,8 @@
 
 #define TIOCSBRK	0x5427	/* BSD compatibility */
 #define TIOCCBRK	0x5428	/* BSD compatibility */
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
 #define TIOCGSID	0x7416	/* Return the session ID of FD */
 #define TCGETS2		_IOR('T', 0x2A, struct termios2)
 #define TCSETS2		_IOW('T', 0x2B, struct termios2)
-- 
2.1.0

