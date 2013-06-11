Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab3FKUga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:36:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab3FKUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Worsley <amworsley@gmail.com>,
        Lotfi Manseur <lotfi.manseur@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [ 18/21] USB: serial: ftdi_sio: Handle the old_termios == 0 case e.g.  uart_resume_port()
Date: Tue, 11 Jun 2013 13:03:12 -0700
Message-Id: <20130611195522.132297591@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195520.003233586@linuxfoundation.org>
References: <20130611195520.003233586@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Worsley <amworsley@gmail.com>

commit c515598e0f5769916c31c00392cc2bfe6af74e55 upstream.

  Handle null old_termios in ftdi_set_termios() calls from uart_resume_port().

Signed-off-by: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lotfi Manseur <lotfi.manseur@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ftdi_sio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2141,6 +2141,9 @@ static void ftdi_set_termios(struct tty_
 
 	cflag = termios->c_cflag;
 
+	if (old_termios == 0)
+		goto no_skip;
+
 	if (old_termios->c_cflag == termios->c_cflag
 	    && old_termios->c_ispeed == termios->c_ispeed
 	    && old_termios->c_ospeed == termios->c_ospeed)
@@ -2154,6 +2157,7 @@ static void ftdi_set_termios(struct tty_
 	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
 		goto no_data_parity_stop_changes;
 
+no_skip:
 	/* Set number of data bits, parity, stop bits */
 
 	urb_value = 0;


