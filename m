Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbbAZFXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:23:03 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38433 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbAZFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:22:59 -0500
Date: Mon, 26 Jan 2015 07:22:54 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andri Yngvason <andri.yngvason@marel.com>
Cc: Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 2/7] can: kvaser_usb: Send correct context to URB
 completion
Message-ID: <20150126052254.GC3014@Darwish.PC>
References: <20141223154654.GB6460@vivalin-002>
 <20150126051755.GA3014@Darwish.PC>
 <20150126052039.GB3014@Darwish.PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126052039.GB3014@Darwish.PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <ahmed.darwish@valeo.com>

Send expected argument to the URB completion hander: a CAN
netdevice instead of the network interface private context
`kvaser_usb_net_priv'.

This was discovered by having some garbage in the kernel
log in place of the netdevice names: can0 and can1.

Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
---
 drivers/net/can/usb/kvaser_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 978a25e..f0c6207 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -587,7 +587,7 @@ static int kvaser_usb_simple_msg_async(struct kvaser_usb_net_priv *priv,
 			  usb_sndbulkpipe(dev->udev,
 					  dev->bulk_out->bEndpointAddress),
 			  buf, msg->len,
-			  kvaser_usb_simple_msg_callback, priv);
+			  kvaser_usb_simple_msg_callback, netdev);
 	usb_anchor_urb(urb, &priv->tx_submitted);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-- 
1.7.7.6

