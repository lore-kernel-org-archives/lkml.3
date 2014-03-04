Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbaCDVBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:01:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbaCDUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.13 119/172] can: kvaser_usb: check number of channels returned by HW
Date: Tue,  4 Mar 2014 12:03:23 -0800
Message-Id: <20140304200303.527077082@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 862474f8b46f6c1e600d4934e40ba40646c696ec upstream.

It is needed to check the number of channels returned by the HW because it
cannot be greater than MAX_NET_DEVICES otherwise it will crash.

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -474,6 +474,8 @@ static int kvaser_usb_get_card_info(stru
 		return err;
 
 	dev->nchannels = msg.u.cardinfo.nchannels;
+	if (dev->nchannels > MAX_NET_DEVICES)
+		return -EINVAL;
 
 	return 0;
 }


