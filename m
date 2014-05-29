Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaE2E6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:58:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbaE2EiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 3.10 32/86] usb: option: add Alcatel L800MA
Date: Wed, 28 May 2014 21:37:07 -0700
Message-Id: <20140529043517.817262354@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit dd6b48ecec2ea7d15f28d5e5474388681899a5e1 upstream.

Device interface layout:
0: ff/ff/ff - serial
1: ff/00/00 - serial AT+PPP
2: ff/ff/ff - QMI/wwan
3: 08/06/50 - storage

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -287,6 +287,7 @@ static void option_instat_callback(struc
 #define ALCATEL_PRODUCT_X060S_X200		0x0000
 #define ALCATEL_PRODUCT_X220_X500D		0x0017
 #define ALCATEL_PRODUCT_L100V			0x011e
+#define ALCATEL_PRODUCT_L800MA			0x0203
 
 #define PIRELLI_VENDOR_ID			0x1266
 #define PIRELLI_PRODUCT_C100_1			0x1002
@@ -1501,6 +1502,8 @@ static const struct usb_device_id option
 	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L100V),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L800MA),
+	  .driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),


