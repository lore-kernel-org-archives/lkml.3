Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3H2XHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:07:25 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60927 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab3H2XHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:07:22 -0400
Date: Fri, 30 Aug 2013 01:06:59 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: liujunliang_ljl@163.com
Cc: davem@davemloft.net, horms@verge.net.au, joe@perches.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sunhecheng@vip.126.com
Subject: Re: [PATCH] USB2NET : SR9700 : One Chip USB 1.1 USB2NET SR9700
 Device Driver Support
Message-ID: <20130829230659.GC12124@electric-eye.fr.zoreil.com>
References: <1377746832-6201-1-git-send-email-liujunliang_ljl@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377746832-6201-1-git-send-email-liujunliang_ljl@163.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liu, please check those.

---
 drivers/net/usb/sr9700.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 3f05b35..3ae3caf 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -99,8 +99,9 @@ static int sr_share_read_word(struct usbnet *dev, int phy, u8 reg,
 
 	mutex_lock(&dev->phy_mutex);
 
+	// FIXME: the mistery 0x40 appears in sr_share_write_word as well.
 	sr_write_reg(dev, EPAR, phy ? (reg | 0x40) : reg);
-	sr_write_reg(dev, EPCR, phy ? 0xc : 0x4);
+	sr_write_reg(dev, EPCR, phy ? (EPCR_EPOS | EPCR_ERPRR) : EPCR_ERPRR);
 
 	ret = wait_phy_eeprom_ready(dev, phy);
 	if (ret < 0)
@@ -128,7 +129,10 @@ static int sr_share_write_word(struct usbnet *dev, int phy, u8 reg,
 	if (ret < 0)
 		goto out_unlock;
 
+	// FIXME: see sr_share_read_word above.
 	sr_write_reg(dev, EPAR, phy ? (reg | 0x40) : reg);
+	// 0x1a -> EPCR_WEP | EPCR_EPOS | EPCR_ERPRW ?
+	// 0x12 -> EPCR_WEP | EPCR_ERPRW ?
 	sr_write_reg(dev, EPCR, phy ? 0x1a : 0x12);
 
 	ret = wait_phy_eeprom_ready(dev, phy);
-- 
1.8.3.1

