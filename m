Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3BQW5z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:57:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45839 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033Ab3BQWzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:47 -0500
Message-Id: <20130217225004.795262370@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Xose Vazquez Perez <xose.vazquez@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/66] wireless: rt2x00: rt{2500,73}usb.c put back duplicate id
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

commit 8f35f787b75e9b6435ea37dabcae2d40dc72d31c upstream.

put back 0x050d,0x7050 to rt73usb, same usb_id for two chips:

K7SF5D7050A ver 2xxx is rt2500
K7SF5D7050B ver 3xxx is rt73

<http://en-us-support.belkin.com/app/answers/detail/a_id/297/kw/K7SF5D7050>

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 1de9c75..c88fd3e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1912,7 +1912,7 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1706) },
 	{ USB_DEVICE(0x0b05, 0x1707) },
 	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050) },
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050A ver. 2.x */
 	{ USB_DEVICE(0x050d, 0x7051) },
 	/* Cisco Systems */
 	{ USB_DEVICE(0x13b1, 0x000d) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e477a96..1551366 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2412,6 +2412,7 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1723) },
 	{ USB_DEVICE(0x0b05, 0x1724) },
 	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050B ver. 3.x */
 	{ USB_DEVICE(0x050d, 0x705a) },
 	{ USB_DEVICE(0x050d, 0x905b) },
 	{ USB_DEVICE(0x050d, 0x905c) },


