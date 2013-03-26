Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965370Ab3CZPmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:42:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068Ab3CZPXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 098/150] USB: serial: add modem-status-change wait queue
Date: Tue, 26 Mar 2013 15:19:57 +0000
Message-Id: <1364311249-14454-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/usb/serial.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 86c0b45..0b61f01 100644
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
-- 
1.8.1.2

