Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984AbaFQQXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:23:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50708 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964948AbaFQQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 092/121] net: qmi_wwan: add a number of Dell devices
Date: Tue, 17 Jun 2014 09:17:50 -0700
Message-Id: <1403021899-16708-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 102eaf8..4f1397b 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -604,6 +604,11 @@ static const struct usb_device_id products[] = {
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
1.9.1

