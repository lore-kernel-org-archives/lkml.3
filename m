Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbaE2ODs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:03:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59448 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933349AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/103] net: qmi_wwan: add a number of Dell devices
Date: Thu, 29 May 2014 15:49:10 +0200
Message-Id: <692e923edc0bb0d58001c89d549df664ca909a2e.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 6f10c5d1b1aeddb63d33070abb8bc5a177beeb1f ]

Dan writes:

"The Dell drivers use the same configuration for PIDs:

81A2: Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card
81A3: Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card
81A4: Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card
81A8: Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card
81A9: Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card

These devices are all clearly Sierra devices, but are also definitely
Gobi-based.  The A8 might be the MC7700/7710 and A9 is likely a MC7750.

>From DellGobi5kSetup.exe from the Dell drivers:

usbif0: serial/firmware loader?
usbif2: nmea
usbif3: modem/ppp
usbif8: net/QMI"

Reported-by: AceLan Kao <acelan.kao@canonical.com>
Reported-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/usb/qmi_wwan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 2353bb363c5d..dca474319c8a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -743,6 +743,11 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},	/* Olivetti Olicard 500 */
 	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 	{QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},	/* Cinterion PHxx,PXxx */
+	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
+	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
+	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
+	{QMI_FIXED_INTF(0x413c, 0x81a8, 8)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card */
+	{QMI_FIXED_INTF(0x413c, 0x81a9, 8)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
1.9.3

