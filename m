Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaBMS21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:28:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54557 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaBMS2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:28:25 -0500
From: Emil Goode <emilgoode@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH Resend] net: asix: add missing flag to struct driver_info
Date: Thu, 13 Feb 2014 19:30:39 +0100
Message-Id: <1392316239-17335-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
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
 drivers/net/usb/asix_devices.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 9765a7d..5d19409 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -917,7 +917,8 @@ static const struct driver_info ax88178_info = {
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
1.7.10.4

