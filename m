Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaEPPkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:40:13 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:53591 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaEPPkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:40:09 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: keyspan: fix potential null pointer dereference
Date: Fri, 16 May 2014 17:39:13 +0200
Message-Id: <1400254753-23565-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140516153000.GC8213@localhost>
References: <20140516153000.GC8213@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Move control-urb dereference to after NULL-check. There is otherwise a
risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called
cppcheck.

[Johan: modify commit message somewhat ]

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: stable <stable@vger.kernel.org>	# v2.6.12
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/keyspan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index d3acaead5a81..93cb7cebda62 100644
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
1.8.5.5

