Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519Ab3B0AMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:12:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760468Ab3B0AJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 81/86] USB: option: add and update Alcatel modems
Date: Tue, 26 Feb 2013 16:08:29 -0800
Message-Id: <20130226235921.335737149@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit f8f0302bbcbd1b14655bef29f6996a2152be559d upstream.

Adding three currently unsupported modems based on information
from .inf driver files:

  Diag  VID_1BBB&PID_0052&MI_00
  AGPS  VID_1BBB&PID_0052&MI_01
  VOICE VID_1BBB&PID_0052&MI_02
  AT    VID_1BBB&PID_0052&MI_03
  Modem VID_1BBB&PID_0052&MI_05
  wwan  VID_1BBB&PID_0052&MI_06

  Diag  VID_1BBB&PID_00B6&MI_00
  AT    VID_1BBB&PID_00B6&MI_01
  Modem VID_1BBB&PID_00B6&MI_02
  wwan  VID_1BBB&PID_00B6&MI_03

  Diag  VID_1BBB&PID_00B7&MI_00
  AGPS  VID_1BBB&PID_00B7&MI_01
  VOICE VID_1BBB&PID_00B7&MI_02
  AT    VID_1BBB&PID_00B7&MI_03
  Modem VID_1BBB&PID_00B7&MI_04
  wwan  VID_1BBB&PID_00B7&MI_05

Updating the blacklist info for the X060S_X200 and X220_X500D,
reserving interfaces for a wwan driver, based on

  wwan VID_1BBB&PID_0000&MI_04
  wwan VID_1BBB&PID_0017&MI_06

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -479,6 +479,7 @@ static const struct option_blacklist_inf
 
 static const struct option_blacklist_info alcatel_x200_blacklist = {
 	.sendsetup = BIT(0) | BIT(1),
+	.reserved = BIT(4),
 };
 
 static const struct option_blacklist_info zte_0037_blacklist = {
@@ -1215,7 +1216,14 @@ static const struct usb_device_id option
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X060S_X200),
 	  .driver_info = (kernel_ulong_t)&alcatel_x200_blacklist
 	},
-	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D) },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_X220_X500D),
+	  .driver_info = (kernel_ulong_t)&net_intf6_blacklist },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, 0x0052),
+	  .driver_info = (kernel_ulong_t)&net_intf6_blacklist },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, 0x00b6),
+	  .driver_info = (kernel_ulong_t)&net_intf3_blacklist },
+	{ USB_DEVICE(ALCATEL_VENDOR_ID, 0x00b7),
+	  .driver_info = (kernel_ulong_t)&net_intf5_blacklist },
 	{ USB_DEVICE(ALCATEL_VENDOR_ID, ALCATEL_PRODUCT_L100V),
 	  .driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },


