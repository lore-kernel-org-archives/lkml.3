Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaKER04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:26:56 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40714 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756213AbaKER0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:26:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 4/9] tty: Remove defunct serial_console_init() declaration
Date: Wed,  5 Nov 2014 12:26:27 -0500
Message-Id: <1415208392-16189-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serial_console_init() is not defined by the tty core; remove
declaration.

Note that the powerpc arch boot code contains a serial_console_init()
declaration in arch/powerpc/boot/ops.h which is restricted to
the powerpc arch boot.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 97cfb31..c52a689 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -617,10 +617,6 @@ extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 extern long n_tty_compat_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
-/* serial.c */
-
-extern void serial_console_init(void);
-
 /* vt.c */
 
 extern int vt_ioctl(struct tty_struct *tty,
-- 
2.1.3

