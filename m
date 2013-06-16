Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3FPWIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:08:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46286 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461Ab3FPWIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Andrew Worsley" <amworsley@gmail.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.28153778@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [31/83] USB: serial: ftdi_sio: Handle the old_termios == 0 case
 e.g. uart_resume_port()
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Worsley <amworsley@gmail.com>

commit c515598e0f5769916c31c00392cc2bfe6af74e55 upstream.

  Handle null old_termios in ftdi_set_termios() calls from uart_resume_port().

Signed-off-by: Andrew Worsley <amworsley@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ftdi_sio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2169,6 +2169,9 @@ static void ftdi_set_termios(struct tty_
 
 	cflag = termios->c_cflag;
 
+	if (old_termios == 0)
+		goto no_skip;
+
 	if (old_termios->c_cflag == termios->c_cflag
 	    && old_termios->c_ispeed == termios->c_ispeed
 	    && old_termios->c_ospeed == termios->c_ospeed)
@@ -2182,6 +2185,7 @@ static void ftdi_set_termios(struct tty_
 	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
 		goto no_data_parity_stop_changes;
 
+no_skip:
 	/* Set number of data bits, parity, stop bits */
 
 	urb_value = 0;

