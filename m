Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaCEO0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:26:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41072 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270AbaCEO0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emil Goode <emilgoode@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/131] net: asix: add missing flag to struct driver_info
Date: Wed,  5 Mar 2014 14:23:19 +0000
Message-Id: <1394029455-23128-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/asix_devices.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index ad5d1e4..97b5de7 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -915,7 +915,8 @@ static const struct driver_info ax88178_info = {
 	.status = asix_status,
 	.link_reset = ax88178_link_reset,
 	.reset = ax88178_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
-- 
1.9.0

