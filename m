Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422650Ab3DKVKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:10:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935662Ab3DKUtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:09 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Al8x4XxDoCMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4tYXBnhvRHIA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=K0aDiagyqAaGSZtWDxEA:9 a=MSl-tDqOz04A:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202605.304240385@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 116/171 ] USB: serial: add modem-status-change wait queue
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0116-USB-serial-add-modem-status-change-wait-queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

[ Upstream commit e5b33dc9d16053c2ae4c2c669cf008829530364b ]

Add modem-status-change wait queue to struct usb_serial_port that
subdrivers can use to implement TIOCMIWAIT.

Currently subdrivers use a private wait queue which may have been
released when waking up after device disconnected.

Note that we're adding a new wait queue rather than reusing the tty-port
one as we do not want to get woken up at hangup (yet).

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/usb/serial.h |    2 ++
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
1.7.10.4


