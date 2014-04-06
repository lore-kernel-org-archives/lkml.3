Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaDFXlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:41:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59448 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "=?UTF-8?Q?Bj=C3=B8rn=20?=Mork" <bjorn@mork.no>,
        "Emil Goode" <emilgoode@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.354125502@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 14/18] net: asix: add missing flag to struct driver_info
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

commit d43ff4cd798911736fb39025ec8004284b1b0bc2 upstream.

The struct driver_info ax88178_info is assigned the function
asix_rx_fixup_common as it's rx_fixup callback. This means that
FLAG_MULTI_PACKET must be set as this function is cloning the
data and calling usbnet_skb_return. Not setting this flag leads
to usbnet_skb_return beeing called a second time from within
the rx_process function in the usbnet module.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/asix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1568,7 +1568,8 @@ static const struct driver_info ax88178_
 	.status = asix_status,
 	.link_reset = ax88178_link_reset,
 	.reset = ax88178_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };

