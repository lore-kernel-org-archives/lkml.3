Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaBQVSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:18:45 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:35806 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaBQVSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:18:44 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Liu Junliang <liujunliang_ljl@163.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] USB2NET : SR9800 : Use %zu to format size_t
Date: Mon, 17 Feb 2014 22:18:39 +0100
Message-Id: <1392671920-11489-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit:

drivers/md/bcache/bset.c: In function ‘bch_dump_bset’:
drivers/md/bcache/bset.c:27: warning: format ‘%li’ expects type ‘long int’, but argument 3 has type ‘int’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/usb/sr9800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index 4175eb9fdeca..801710883727 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -823,7 +823,7 @@ static int sr9800_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size =
 			SR9800_BULKIN_SIZE[SR9800_MAX_BULKIN_2K].size;
 	}
-	netdev_dbg(dev->net, "%s : setting rx_urb_size with : %ld\n", __func__,
+	netdev_dbg(dev->net, "%s : setting rx_urb_size with : %zu\n", __func__,
 		   dev->rx_urb_size);
 	return 0;
 
-- 
1.7.9.5

