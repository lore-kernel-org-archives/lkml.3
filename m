Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaI3VpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:45:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32894 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaI3Vi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 039/103] xtensa: replace IOCTL code definitions with constants
Date: Tue, 30 Sep 2014 14:30:44 -0700
Message-Id: <1412112708-27356-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit f61bf8e7d19e0a3456a7a9ed97c399e4353698dc upstream.

This fixes userspace code that builds on other architectures but fails
on xtensa due to references to structures that other architectures don't
refer to. E.g. this fixes the following issue with python-2.7.8:

  python-2.7.8/Modules/termios.c:861:25: error: invalid application
     of 'sizeof' to incomplete type 'struct serial_multiport_struct'
     {"TIOCSERGETMULTI", TIOCSERGETMULTI},
  python-2.7.8/Modules/termios.c:870:25: error: invalid application
     of 'sizeof' to incomplete type 'struct serial_multiport_struct'
     {"TIOCSERSETMULTI", TIOCSERSETMULTI},
  python-2.7.8/Modules/termios.c:900:24: error: invalid application
     of 'sizeof' to incomplete type 'struct tty_struct'
     {"TIOCTTYGSTRUCT", TIOCTTYGSTRUCT},

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/include/uapi/asm/ioctls.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/xtensa/include/uapi/asm/ioctls.h b/arch/xtensa/include/uapi/asm/ioctls.h
index b4cb110..a47909f 100644
--- a/arch/xtensa/include/uapi/asm/ioctls.h
+++ b/arch/xtensa/include/uapi/asm/ioctls.h
@@ -28,17 +28,17 @@
 #define TCSETSW		0x5403
 #define TCSETSF		0x5404
 
-#define TCGETA		_IOR('t', 23, struct termio)
-#define TCSETA		_IOW('t', 24, struct termio)
-#define TCSETAW		_IOW('t', 25, struct termio)
-#define TCSETAF		_IOW('t', 28, struct termio)
+#define TCGETA		0x80127417	/* _IOR('t', 23, struct termio) */
+#define TCSETA		0x40127418	/* _IOW('t', 24, struct termio) */
+#define TCSETAW		0x40127419	/* _IOW('t', 25, struct termio) */
+#define TCSETAF		0x4012741C	/* _IOW('t', 28, struct termio) */
 
 #define TCSBRK		_IO('t', 29)
 #define TCXONC		_IO('t', 30)
 #define TCFLSH		_IO('t', 31)
 
-#define TIOCSWINSZ	_IOW('t', 103, struct winsize)
-#define TIOCGWINSZ	_IOR('t', 104, struct winsize)
+#define TIOCSWINSZ	0x40087467	/* _IOW('t', 103, struct winsize) */
+#define TIOCGWINSZ	0x80087468	/* _IOR('t', 104, struct winsize) */
 #define	TIOCSTART	_IO('t', 110)		/* start output, like ^Q */
 #define	TIOCSTOP	_IO('t', 111)		/* stop output, like ^S */
 #define TIOCOUTQ        _IOR('t', 115, int)     /* output queue size */
@@ -88,7 +88,6 @@
 #define TIOCSETD	_IOW('T', 35, int)
 #define TIOCGETD	_IOR('T', 36, int)
 #define TCSBRKP		_IOW('T', 37, int)   /* Needed for POSIX tcsendbreak()*/
-#define TIOCTTYGSTRUCT	_IOR('T', 38, struct tty_struct) /* For debugging only*/
 #define TIOCSBRK	_IO('T', 39) 	     /* BSD compatibility */
 #define TIOCCBRK	_IO('T', 40)	     /* BSD compatibility */
 #define TIOCGSID	_IOR('T', 41, pid_t) /* Return the session ID of FD*/
@@ -114,8 +113,10 @@
 #define TIOCSERGETLSR   _IOR('T', 89, unsigned int) /* Get line status reg. */
   /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 # define TIOCSER_TEMT    0x01		     /* Transmitter physically empty */
-#define TIOCSERGETMULTI _IOR('T', 90, struct serial_multiport_struct) /* Get multiport config  */
-#define TIOCSERSETMULTI _IOW('T', 91, struct serial_multiport_struct) /* Set multiport config */
+#define TIOCSERGETMULTI 0x80a8545a /* Get multiport config  */
+			/* _IOR('T', 90, struct serial_multiport_struct) */
+#define TIOCSERSETMULTI 0x40a8545b /* Set multiport config */
+			/* _IOW('T', 91, struct serial_multiport_struct) */
 
 #define TIOCMIWAIT	_IO('T', 92) /* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-- 
1.9.1

