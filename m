Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3DVO3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab3DVO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.287261616@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [01/75] USB: serial: add modem-status-change wait queue
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit e5b33dc9d16053c2ae4c2c669cf008829530364b upstream.

Add modem-status-change wait queue to struct usb_serial_port that
subdrivers can use to implement TIOCMIWAIT.

Currently subdrivers use a private wait queue which may have been
released when waking up after device disconnected.

Note that we're adding a new wait queue rather than reusing the tty-port
one as we do not want to get woken up at hangup (yet).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/usb/serial.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -71,6 +71,7 @@ enum port_dev_state {
  *	port.
  * @flags: usb serial port flags
  * @write_wait: a wait_queue_head_t used by the port.
+ * @delta_msr_wait: modem-status-change wait queue
  * @work: work queue entry for the line discipline waking up.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
@@ -114,6 +115,7 @@ struct usb_serial_port {
 
 	unsigned long		flags;
 	wait_queue_head_t	write_wait;
+	wait_queue_head_t	delta_msr_wait;
 	struct work_struct	work;
 	char			throttled;
 	char			throttle_req;

