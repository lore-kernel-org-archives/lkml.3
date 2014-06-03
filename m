Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaFCLkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaFCLkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/138] usb: qcserial: add a number of Dell devices
Date: Tue,  3 Jun 2014 12:37:44 +0100
Message-Id: <1401795584-22664-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 4d7c0136a54f62501f8a34c4d08a5e0258d3d3ca upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/qcserial.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 7ed681a714a5..6c0a542e8ec1 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -151,6 +151,21 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 0)},	/* Netgear AirCard 340U Device Management */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 2)},	/* Netgear AirCard 340U NMEA */
 	{USB_DEVICE_INTERFACE_NUMBER(0x1199, 0x9051, 3)},	/* Netgear AirCard 340U Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 0)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a2, 3)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a3, 0)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a3, 2)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a3, 3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a4, 0)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a4, 2)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a4, 3)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a8, 0)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a8, 2)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a8, 3)},	/* Dell Wireless 5808 Gobi(TM) 4G LTE Mobile Broadband Card Modem */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a9, 0)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card Device Management */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a9, 2)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card NMEA */
+	{USB_DEVICE_INTERFACE_NUMBER(0x413c, 0x81a9, 3)},	/* Dell Wireless 5808e Gobi(TM) 4G LTE Mobile Broadband Card Modem */
 
 	{ }				/* Terminating entry */
 };
-- 
1.9.1

