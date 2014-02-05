Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaBEU3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:29:12 -0500
Received: from mail.windriver.com ([147.11.1.11]:55271 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaBEUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Worsley <amworsley@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 149/213] USB: serial: ftdi_sio: Handle the old_termios == 0 case e.g. uart_resume_port()
Date: Wed, 5 Feb 2014 15:01:44 -0500
Message-ID: <1391630568-49251-150-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Worsley <amworsley@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c515598e0f5769916c31c00392cc2bfe6af74e55 upstream.

  Handle null old_termios in ftdi_set_termios() calls from uart_resume_port().

Signed-off-by: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 646cc5326219..882af44bf8bb 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2336,6 +2336,9 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
 	cflag = termios->c_cflag;
 
+	if (old_termios == 0)
+		goto no_skip;
+
 	if (old_termios->c_cflag == termios->c_cflag
 	    && old_termios->c_ispeed == termios->c_ispeed
 	    && old_termios->c_ospeed == termios->c_ospeed)
@@ -2349,6 +2352,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
 		goto no_data_parity_stop_changes;
 
+no_skip:
 	/* Set number of data bits, parity, stop bits */
 
 	urb_value = 0;
-- 
1.8.5.2

