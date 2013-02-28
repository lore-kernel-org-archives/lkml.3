Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3B1OqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3B1OqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/139] USB: option: add and update Alcatel modems
Date: Thu, 28 Feb 2013 14:42:43 +0000
Message-Id: <1362062689-2567-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5f4ce8e..b5fd2f8 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -479,6 +479,7 @@ static const struct option_blacklist_info four_g_w14_blacklist = {
 
 static const struct option_blacklist_info alcatel_x200_blacklist = {
 	.sendsetup = BIT(0) | BIT(1),
+	.reserved = BIT(4),
 };
 
 static const struct option_blacklist_info zte_0037_blacklist = {
@@ -1215,7 +1216,14 @@ static const struct usb_device_id option_ids[] = {
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
-- 
1.8.1.2

