Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab3CDEXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:23:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60731 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755225Ab3CDDm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:28 -0500
Message-Id: <20130304033708.921881619@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 013/153] USB: option: add and update Alcatel modems
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


