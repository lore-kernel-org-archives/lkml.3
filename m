Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3APAGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:06:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:43136 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932492Ab3AOWdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Thomas=20Sch=C3=A4fer?= <tschaefer@t-online.de>,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 160/221] USB: option: add Telekom Speedstick LTE II
Date: Tue, 15 Jan 2013 10:51:27 -0800
Message-Id: <20130115185009.610026805@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 5ec0085440ef8c2cf50002b34d5a504ee12aa2bf upstream.

also known as Alcatel One Touch L100V LTE

The driver description files gives these names to the vendor specific
functions on this modem:

 Application1: VID_1BBB&PID_011E&MI_00
 Application2: VID_1BBB&PID_011E&MI_01
 Modem:        VID_1BBB&PID_011E&MI_03
 Ethernet:     VID_1BBB&PID_011E&MI_04

Reported-by: Thomas Schäfer <tschaefer@t-online.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -289,6 +289,7 @@ static void option_instat_callback(struc
 #define ALCATEL_VENDOR_ID			0x1bbb
 #define ALCATEL_PRODUCT_X060S_X200		0x0000
 #define ALCATEL_PRODUCT_X220_X500D		0x0017
+#define ALCATEL_PRODUCT_L100V			0x011e
 
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -1199,6 +1200,8 @@ static const struct usb_device_id option
 	  .driver_info = (kernel_ulong_t)&alcatel_x200_blacklist
 	},
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L100V),
+	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),


