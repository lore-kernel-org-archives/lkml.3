Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaBIXEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 18:04:15 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36919 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaBIXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 18:04:12 -0500
From: Emil Goode <emilgoode@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 2/2] net: asix: add missing flag to struct driver_info
Date: Mon, 10 Feb 2014 00:06:14 +0100
Message-Id: <1391987174-21828-2-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct driver_info ax88178_info is assigned the function
asix_rx_fixup_common as it's rx_fixup callback. This means that
FLAG_MULTI_PACKET must be set as this function is cloning the
data and calling usbnet_skb_return. Not setting this flag leads
to usbnet_skb_return beeing called a second time from within
the rx_process function in the usbnet module.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
Reported-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/asix_devices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 7ced4ed..19d8821 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -919,7 +919,7 @@ static const struct driver_info ax88178_info = {
 	.link_reset = ax88178_link_reset,
 	.reset = ax88178_reset,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
-		 FLAG_PARTIAL_RX_PKT,
+		 FLAG_MULTI_PACKET | FLAG_PARTIAL_RX_PKT,
 	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
-- 
1.7.10.4

