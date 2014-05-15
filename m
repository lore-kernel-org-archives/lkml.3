Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbaEOVyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:54:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34706 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaEOVy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:54:27 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=5D=20Fix=20for=20possible=20null=20pointer=20dereference=20in=20keyspan=2Ec?=
Date: Thu, 15 May 2014 23:55:10 +0200
Message-Id: <1400190910-28019-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/usb/serial/keyspan.c |    4 ++--
 1 fil ändrad, 2 tillägg(+), 2 borttagningar(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index d3acaea..93cb7ce 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1535,14 +1535,14 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 
 	this_urb = p_priv->outcont_urb;
 
-	dev_dbg(&port->dev, "%s - endpoint %d\n", __func__, usb_pipeendpoint(this_urb->pipe));
-
 		/* Make sure we have an urb then send the message */
 	if (this_urb == NULL) {
 		dev_dbg(&port->dev, "%s - oops no urb.\n", __func__);
 		return -1;
 	}
 
+	dev_dbg(&port->dev, "%s - endpoint %d\n", __func__, usb_pipeendpoint(this_urb->pipe));
+
 	/* Save reset port val for resend.
 	   Don't overwrite resend for open/close condition. */
 	if ((reset_port + 1) > p_priv->resend_cont)
-- 
1.7.10.4

