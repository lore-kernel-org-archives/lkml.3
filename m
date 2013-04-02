Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab3DBXJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:09:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203Ab3DBWMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 059/124] USB: serial: add modem-status-change wait queue
Date: Tue,  2 Apr 2013 15:10:41 -0700
Message-Id: <20130402221111.019370519@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

---
 include/linux/usb/serial.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -66,6 +66,7 @@
  *	port.
  * @flags: usb serial port flags
  * @write_wait: a wait_queue_head_t used by the port.
+ * @delta_msr_wait: modem-status-change wait queue
  * @work: work queue entry for the line discipline waking up.
  * @throttled: nonzero if the read urb is inactive to throttle the device
  * @throttle_req: nonzero if the tty wants to throttle us
@@ -112,6 +113,7 @@ struct usb_serial_port {
 
 	unsigned long		flags;
 	wait_queue_head_t	write_wait;
+	wait_queue_head_t	delta_msr_wait;
 	struct work_struct	work;
 	char			throttled;
 	char			throttle_req;


